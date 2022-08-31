# LTSP Configuration for Benchmark Platform of Diskless Workstations

In this post we look at using a testing Lab of Windows systems as a benchmarking platform for Linux scientific application using network boot with nfsroot and home mounts. Linux is boot on the systems "diskless" leaving teh Windows installs untouched. LTSP turned out to be a great time saver for setting up the configuration.

## Introduction:

![LTSP logo](./logo-penguins.png)

[The Linux Terminal Server Project (ltsp)](https://ltsp.org**) was re-written in 2019 to support modern configurations with systemd, and dnsmasq for dhcp and tftp. It is much different than the legacy ltsp5 which was focused on Linux thin clients i.e. compute on the server. **The new LTSP still sets up and manages network booting but now adds remote root file-system management to the clients with the intent that the clients will run their own jobs.**

**In my use case the LTSP logo above would have a little penguin for the server and big penguins for the clients!**

The client root images can come from,

- A raw virtual machine image (VirtualBox VM)
- A server maintained chroot root directory
- Or "chrootless" which uses the server root as the template for the clients

The chrootless option is the simplest to maintain since updates applied on the server can be made available for clients with a single command.

The client root images are compressed with mksquashfs and exported to the client network read-only with NFS and served using nfsroot at boot. These root images are mounted on the clients together with tmpfs and overlayfs to provide temporary "copy-on-write" writable storage on the clients similar to a "live CD".

The client /home directories are mounted from the server using SSHFS (secure shell file system). [possibly with NBD (network block device) with NVMe over fabric? later maybe.] User authentication is with SSH (or SSHFS) from the server.

The setup described above is configured and deployed with a few simple commands provided by LTSP!

## Use Case:

My personal use case is for benchmarking on a variety of (x86) hardware configurations setup in Puget Systems Labs. These systems are typically running locally installed Windows OS. But, I need to benchmark Scientific and Machine Learning/AI applications under Linux. I typically limit my hardware testing because of the inconvenience of having to be physically present to manually swap out drives and do installs and setups. With a Diskless Workstation server in Labs I'll be able to remote reboot these system to a PXE network boot with a server that has the needed configuration for my benchmark runs and testing. We will be using 10Gb network connections on a private subnet so performance should be adequate, but, we will likely be investigating higher performance network in the future (100Gb Ethernet).

Because of my use case, what I describe below will be for a generic Ubuntu 20.04 server based root file system to mount on the clients. This root image should easily run on the variety of hardware we have in Labs. It is possible with LTSP, and in fact typical, to do this type of diskless workstation setup with Desktop GUI based root images for clients in something like a teaching computer lab. If that is your interest then I would probably recommend using a "network friendly" desktop environment like Mate.

**My setup:**

- LTSP server: Ubuntu 20.04 server
- "chrootless" image option: System level packages I want on the clients are,
  - Extras: build-essential, emacs-nox, dkms, ssh, NetworkManager
  - NVIDIA driver: for compute! I will not have an NVIDIA GPU on the LTSP server but most of the client systems will.
  - libnvidia-container-tools, fuse-overlayfs, pigz, squashfuse (extras for enroot)
  - NVIDIA enroot for containerized applications. See my post [Self Contained Executable Containers Using Enroot Bundles](https://www.pugetsystems.com/labs/hpc/Self-Contained-Executable-Containers-Using-Enroot-Bundles-2181/).
- /home on server with all of the tools I'll use on the clients: python (Miniconda), benchmarks, enroot container bundles, etc..

## Server configuration:

- Intel NUC
- BIOS: secureboot disabled and set to (Other OS)
- Basic Ubuntu 20.04.4 server + ssh install + updates
  -Extras:

```
sudo apt install build-essential emacs-nox dkms
sudo apt install --no-install-recommends nvidia-driver-470
```

- NVIDIA Enroot and libnvidia-container-tools: See post linke in >My setup" for details.

**libnvidia-container-tools:**

```
DIST=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list |
sudo tee /etc/apt/sources.list.d/libnvidia-container.list
sudo apt-get update
sudo apt-get install --yes libnvidia-container-tools
```

**Enroot:**

```
RELEASE=3.4.0
arch=$(dpkg --print-architecture)

curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot_${RELEASE}-1_${arch}.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot+caps_${RELEASE}-1_${arch}.deb # optional

sudo apt-get install --yes ./enroot_${RELEASE}-1_${arch}.deb
sudo apt-get install --yes ./enroot+caps_${RELEASE}-1_${arch}.deb
```

```
rm ./enroot_${RELEASE}-1_${arch}.deb
rm ./enroot+caps_${RELEASE}-1_${arch}.deb
```

**Network:**

Changing to NetworkManager
See,
https://gist.github.com/dbkinghorn/ed923bbcb7ec3f53bd2da5fe5e9b49b2

**/etc/netplan/00-ltsp-config.yaml**

```
# set with external network on enp3s0
# LSTP 10G net ports  ens1f0 and ens1f1
network:
  renderer: NetworkManager
  ethernets:
    enp3s0:
      dhcp4: true
    ens1f0:
      dhcp4: false
      addresses: [192.168.67.1/24]
    ens1f1:
      dhcp4: false
      addresses: [192.168.67.2/24]
  version: 2

```

```
sudo netplan generate
sudo netplan apply

sudo apt install network-manager
systemctl enable NetworkManager.service
systemctl restart NetworkManager.service

sudo shutdown -r now

```

## LSTP server configuration:

```
sudo add-apt-repository ppa:ltsp
sudo apt update

sudo apt install --install-recommends ltsp ltsp-binaries dnsmasq nfs-kernel-server openssh-server squashfs-tools ethtool net-tools
```

Note: I did not install epoptes for client management since I am using a purely server based setup.

Errors on install from trying to start dnsmasq;

```
● dnsmasq.service - dnsmasq - A lightweight DHCP and caching DNS server
     Loaded: loaded (/lib/systemd/system/dnsmasq.service; enabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since Tue 2022-03-15 20:43:36 UTC; 3ms ago
    Process: 1943 ExecStartPre=/usr/sbin/dnsmasq --test (code=exited, status=0/SUCCESS)
    Process: 1944 ExecStart=/etc/init.d/dnsmasq systemd-exec (code=exited, status=2)
...
Mar 15 20:43:36 ltsp systemd[1]: Failed to start dnsmasq - A lightweight DHCP and caching DNS server.
```

This is caused by systemd-resolved using port 53.

**FIX NOT NEEDED** we will be using --dns=1 option to ltsp dnsmasq This will automatically apply the proper fix to systemd-resolvd and enable name service with dnsmasq.

---

**Here's the fix for reference. (you do not need to do this!)**
Check that systemd-resolved is using port 53

```
sudo lsof -i :53
```

Edit /etc/systemd/resolved.conf and set DNSStubListener=no

```
[Resolve]
#DNS=
#FallbackDNS=
#Domains=
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#DNSOverTLS=no
#Cache=no-negative
DNSStubListener=no
#ReadEtcHosts=yes

```

```
sudo systemctl restart systemd-resolved.service
sudo lsof -i :53
sudo systemctl restart dnsmasq.service
sudo systemctl status dnsmasq.service


```

---

**YOU NEED TO ENABLE DNS SERVICE WITH DNSMASQ**

ltsp dnsmasq --dns=1 --proxy-dhcp=0 --dns-server="1.1.1.1 8.8.8.8"

Here's the output of that command showing the proper handling of systemd-resolved,

```
kinghorn@ltsp:~$ sudo ltsp dnsmasq --dns=1 --proxy-dhcp=0 --dns-server="1.1.1.1 8.8.8.8"
[sudo] password for kinghorn:
Installed /usr/share/ltsp/server/dnsmasq/ltsp-dnsmasq.conf in /etc/dnsmasq.d/ltsp-dnsmasq.conf
Disabled DNSStubListener in systemd-resolved
Symlinked /etc/resolv.conf to ../run/systemd/resolve/resolv.conf
Restarted dnsmasq

```

This also enables DHCP and TFTP by default

**Client root (/) setup:**
To use "chrootless" i.e. use the server root at client template

```
sudo ltsp image /
```

Takes a few minutes ...

**Update iPXE:**

```
sudo ltsp ipxe
```

**NFS for client nfsroot:**
This is read-only root with overlays

```
sudo ltsp nfs
```

**home directories:**
/home will be mounted automatically via sshfs

**Create ltsp.img:**
This adds an additional initrd to run on clients with users infor etc.
**(this command needs to be run whenever changes are made to /etc/ltsp/ltsp.conf, when packages are updated on the server or new users are added)**

```
sudo ltsp initrd
```

## Client configuration and ssh login setup

By default the ltsp tools removes the ssh host keys from the client image. That's a good thing for security. I'm using the "chrootless" image option so having the keys transferred to the clients would mean that every client would have a copy of the server keys. However, for my use case, I do need to be able to ssh to the clients from the server.

I will do a ssh setup on the client that creates new host keys on every boot. This is the most secure option that allows ssh from the server to client. The only real downside is, with new keys at every boot, my known_hosts file will have old signatures every time a client is restarted and this will cause ssh to complain and refuse to connect until the client key is removed from known_hosts. For a use case where the clients are rebooted often this would be a nuisance. I am using a privet subnet for the clients and will present a per user ssh config that will remove this annoyance.

**Create an editable ltsp.conf file,**

```
install -m 0660 -g sudo /usr/share/ltsp/common/ltsp/ltsp.conf /etc/ltsp/ltsp.conf
```

The following edits need to be made to the ltps,conf file,

**Force NAT:** I want to be sure NAT starts up on the server even if the 10Gb network card is not plugged in (i.e. DOWN). It is automatic if it's detected but this config change will enable it in any case.

```
[server]
# Enable NAT on dual NIC servers
NAT=1

```

**Setup for ssh to clients**

```
[clients]
# Keep the ssh service available and generate new keys
# (dpkg-reconfigure is the easiest way to do this on Ubuntu or Debian)
KEEP_SYSTEM_SERVICES="ssh"
POST_INIT_CONFIG_SSH="dpkg-reconfigure openssh-server"

```

**Update initrd for the client image:**

```
sudo ltsp initrd
```

**Now reboot a client. You now have ssh access from the server.**

**User ssh config:**
I did one more thing to to take care of the annoyance of known_host key mismatch caused from new host keys being generated on the clients at boot.

In my user home directory on the server (which gets mounted on the clients) I added an ssh config to get rid of the host key checks on the private subnet that the clients connect to the server on.

I created ~/.ssh/config with the following,

```
Host 192.168.67.*
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
```

and then

```
chmod 600 ~/.ssh/config
```

That config keeps ssh on the LTSP client subnet from complaining about the stale host keys and blocking login. You don't have to do this but you will probably get tired of deleting stale keys from known_hosts if you don't.

## Conclusion

This diskless workstation setup with LTSP is not the normal usage for the project but, it was ideal for my use case and relatively easy to setup. The LTSP tools saved a LOT of configuration work!

Here is a recap of my usage;

I needed a way to run Scientific and ML/AI benchmarks on our testing Lab full of systems that are running Windows by default. I wanted to boot the test systems over a private network with their root file system mounted as nfsroot and home directory with all of my testing code network mounted as well.
LTSP with just a few configuration changes turned out to work very well.

I do have a dual 10G nic on the server to have 2 systems going at the same time and we will likely add a 4 port 10G nic or even a multi-port 10G switch.

This should make it much easier for me to do testing so expect to see more blog posts with performance benchmarking for Scientific and ML/AI applications!

**Happy Computing! --dbk @dbkinghorn**
