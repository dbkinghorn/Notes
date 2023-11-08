
## Introduction

## Hardware requirements/recommendations

## Base Ubuntu Server install and config

### Step 1 - Install Ubuntu Server

You can do this with Ubuntu Desktop as well. My intention is to describe a server config. However, you can do this setup for a personal AI dev system too.

Get a fresh copy of Ubuntu Server Live Installer for "Jammy" (22.04).
[https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/](https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/)

Do a standard install. You will probably want to enable ssh. Don't try to add "extra drivers" at this point. I would also skip installing any snaps.

After first boot update and upgrade the system. It should already be mostly up to date if you grabbed a fresh install ISO.
```bash
sudo apt update
sudo apt upgrade
```

### Step 1.1 - Fix Ubuntu Server Annoyances (optional?)

#### Annoyance 1 - "A start job is running for wait for network to be configured" 
**How to prevent unused network interfaces from waiting for DHCP on boot.**

Ubuntu Server uses networkd with netplan to configure networking. I will often configure NetworkManager as the renderer however in this guide I will stay with networkd but change the config to prevent the annoyance of unused interfaces waiting for DHCP on boot.

You will need to edit the netplan config file in `/etc/netplan`.
First create a backup of the original config file.
```bash
sudo cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
```
Then edit the file with your favorite editor. As an example, the system I'm using while writing this post has 2 network interfaces and only one is being used. This was configured by the installer and looks like this: (yours will probably be different)
```bash
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp5s0:
      dhcp4: true
    enp6s0:
      dhcp4: true
  version: 2
```
Using `ip addr` I see that enp6s0 is an interface I'm not using on this system. On boot, networkd will wait for this (over 2min!) interface to get an address from DHCP even though is not connected i.e. NO-CARRIER. To fix this we will make the interface "optional" by adding the `optional: true` line to the config. The config will now look like this:
```bash
network:
  ethernets:
    enp5s0:
      dhcp4: true
    enp6s0:
      dhcp4: true
      optional: true
  version: 2
```
Now apply the config with:
On the next boot there will be no more waiting for unused interfaces to get an address from DHCP! Yay!

**You (or ask your network administrator) should assign a "static lease" from your DHCP server to the interface you want to be running your services on.** You can get your current assigned IP address and interface MAC address with: `ip addr`. Alternatively you can arrange to use a static IP address and configure netplan accordingly. [See the docs](https://netplan.readthedocs.io/en/stable/).

#### Annoyance 2 - Grub menu time out is set to 0 seconds
**How to get the grub boot menu back in Ubuntu.**

In the file /etc/default/grub change the GRUB_TIMEOUT value to 10. Then run update-grub. Do this manually or with the following scriptable commands:
```bash
sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=10/g' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub
sudo update-grub
```
Now you can get to the grub menu and select a different kernel or set kernel boot options to fix problems if needed! (If you feel this is a security risk you can skip this fix.)

Those are the two annoyances I would feel remiss if I didn't include fixes for in this post.

### Step 2 - Install Nvidia drivers
I'm going to recommend installing the latest NVIDIA driver from the standard Ubuntu repos. This will hopefully be stable and working properly. 

You can check the driver versions available with:
```bash
apt search nvidia-driver-* | grep ^nvidia-driver-
```
You will want the highest-numbered version. Don't worry about "server" or "open". `--no-install-recommends` will do the right thing.

```bash
sudo apt install --no-install-recommends nvidia-driver-535
```
Restart to load the new driver.
After restarting check that the driver is loaded with:
```bash
nvidia-smi
```

### Step 3 - Install the NVIDIA Container Toolkit
This is a set of tools that will allow us to run containers with GPU support. [Note that this has been recently updated and as of this writing there are mixed instructions on the web.] [Current reference guide.](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list 
```

```bash
sudo apt update
sudo apt install -y nvidia-container-toolkit
```

Now on to container runtime installation. I'll cover Docker and NVIDIA Enroot.

### Step 4 - Install Docker

Docker is ubiquitous and well-supported. I use it for creating/distributing new containers. I do prefer user-space container applications when I can use them. [Podman]( ) for example is a great alternative but it is unfortunately not well supported (kept current) by Canonical/Ubuntu. There are times when you just need to use docker. 

I will mostly follow the official Docker docs for the base Install.
Reference: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

For GPU setup we will take guidence from NVIDIA. 
Reference: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

#### Uninstall old versions
This post is about a fresh Ubuntu server install but if you have an old version of Docker installed for any reason you will want to remove it first. 

```bash
sudo apt-get remove docker docker-engine docker.io docker-compose docker-doc containerd runc
```

#### Add Docker's official GPG key:
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

#### Add the Docker repository to Apt sources:
```bash
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```
#### Install Docker:
```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
#### Verify that Docker Engine is installed correctly by running the hello-world image.
```bash
sudo docker run hello-world
```
That should run successfully as root. We will want to run docker as a non-root user.

### Step 4.1 - Docker Post Install
[Reference: https://docs.docker.com/engine/install/linux-postinstall/](https://docs.docker.com/engine/install/linux-postinstall/)

#### Create a docker group.
```bash
sudo groupadd docker
```
##### Add your user account to the docker group.
```bash
sudo usermod -aG docker $USER
```
#### Activate the changes to groups.
```bash
newgrp docker
```

#### Verify that you can run docker commands without sudo.
```bash
docker run hello-world
```

#### Set to start on Boot
```bash
sudo systemctl enable --now docker.service 
sudo systemctl enable --now containerd.service
```
The `--now` option will start the service immediately.

### Step "Arrrrggg!!" - What to do if Docker breaks your LAN! (hopefully optional)
Docker is a fairly intrusive application. Mysterious network problems occasionally happen. The one I have to deal with most often is docker starting its internal network pool on the same subnet as an already-in-use LAN at my location. This causes all kinds of problems and it is not well documented. 

#### Check the docker network config
```bash
docker network inspect bridge
```
If the docker bridge network is on the same subnet as one of your LAN segments you will need to change it. 
**DO NOT DO THIS IF YOU DON'T HAVE TO!**
You can change the docker default network pools by editing `/etc/docker/daemon.json`. With a fresh Docker install the daemon.json file won't exist yet. The following script section will create the file and change the default network pool to 10.13.0.0/16, (assuming that does not interfere with your LAN.)
```bash
echo '{
  "default-address-pools": [
    {"base":"10.13.0.0/16","size":24}
  ]
}' | sudo tee /etc/docker/daemon.json > /dev/null
```
 
Hopefully, you won't need and of that!

### Step 4.3 - Configure Docker to use the NVIDIA Container Toolkit
In step 3 we installed the NVIDIA Container Toolkit. Now we need to configure Docker to use it.

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```
#### Fix Docker default shm size
The shared memory size for docker is too small for containers doing heavy computation. We will fix this by editing the /etc/docker/daemon.json file. If the file does not exist yet, create it. 
```bash
echo '{
    "default-shm-size": "1G",
    "default-ulimits": {
         "memlock": { "name":"memlock", "soft":  -1, "hard": -1 },
         "stack"  : { "name":"stack", "soft": 67108864, "hard": 67108864 }
    }
}' | sudo tee -a /etc/docker/daemon.json > /dev/null
```

#### Restart Docker
```bash
sudo systemctl restart docker
```

### Step 5 - Install NVIDIA Enroot

My favorite container runtime is [NVIDIA Enroot]( ) and I use it whenever I can, however, it is not widely adopted. I will cover its installation in the next section. 

#***** GO CHECK FOR THE CURRENT RELEASE! *****#
# ***** AND ENTER IT HERE                *****#
# https://github.com/NVIDIA/enroot/releases
RELEASE=3.4.1

# Install dependencies
#apt-get update
apt-get install --yes curl gawk jq squashfs-tools parallel
apt-get install --yes fuse-overlayfs pigz squashfuse


## Install
arch=$(dpkg --print-architecture)
# arch is amd64
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot_${RELEASE}-1_${arch}.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot+caps_${RELEASE}-1_${arch}.deb # optional

sudo apt-get install --yes ./enroot_${RELEASE}-1_${arch}.deb
sudo apt-get install --yes ./enroot+caps_${RELEASE}-1_${arch}.deb

# Clean up
rm ./enroot_${RELEASE}-1_${arch}.deb
rm ./enroot+caps_${RELEASE}-1_${arch}.deb
rm ./enroot-check_*.run

