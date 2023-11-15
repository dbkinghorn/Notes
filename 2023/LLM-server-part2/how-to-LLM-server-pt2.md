# This will be the container setup post -- Part 2 (after removing the base OS stuff)

## Introduction

**This post is Part 1 in a series on how to configure a system for LLM deployments and development usage.** The configuration will be suitable for multi-user deployments and also useful for smaller development systems. I will describe configuration steps in detail with commands suitable for scripts to automate the process. **Part 1 is about the base Linux server setup.**


I have recently had the pleasure of diving into the world of modern AI with Large Language Models. Now is truly a history-changing time in computer-human interaction. The pace of development is almost frantic. It's been challenging staying informed of new developments and trying new ideas.
Fortunately, I have had on-prem access to capable hardware for development and experimentation. The system I've been mostly working with is the nicely designed [Puget Systems Qudad NVIDIA 6000Ada 5U system](https://www.pugetsystems.com/solutions/scientific-computing-workstations/machine-learning-ai/buy-404/).

**Of course, working with bare-metal hardware requires a system setup!** Linux system configuration is something I enjoy doing. The system I'm using has proven capable of supporting many simultaneous users with state-of-the-art LLMs here at Puget Systems. This is in large part due to the great LLM server software from [Hugging Face](https://huggingface.co/). 

There are lots of details! To keep things manageable (for me and you) I will break this into several posts. This post will cover the base system setup. At the end of the post series, I should be able to provide a script to automate the entire process.

## Hardware requirements/recommendations

The main system I've been working with is configured as follows:
- CPU: Intel Xeon w9-3475X 36-core Sapphire Rapids
- RAM: 512GB DDR5 4800MHz Reg ECC
- Motherboard: ASUS PRO WS W790E-SAGE SE
- 2 x Sabrent Rocket 4 Plus 2TB PCIe Gen 4 M.2 SSD
- GPUs: 4 x NVIDIA RTX 6000 Ada Generation 48GB
- Ubuntu 22.04 LTS

This system is capable of serving Llama2-70b and derivatives with good performance. I recommend a configuration like this for small-scale on-prem deployment. With 20-50 end users for inference or a small development work group working on applications and fine-tuning with smaller models.

However, the instructions in this post (and its follow-ups) are suitable for use with much more modest hardware! Almost any system with one or more NVIDIA GPUs that have 16GB or more of VRAM will get you started. 

Note: at this point, I am only recommending NVIDIA GPU acceleration. However, soon AMD GPUs will be supported enough to be useful. I have already started experimenting with them. CPU-only deployment is also possible and I will investigate the feasibility of that in the future.

For hardware configurations see [Puget Systems "Workstations for Machine Learning / AI"](https://www.pugetsystems.com/solutions/scientific-computing-workstations/machine-learning-ai/). 

## Base Ubuntu Server install and config

I will describe a server config. However, you can do this setup for a personal AI dev system too possibly using Ubuntu Desktop instead of server.

### Step 1 - Install Ubuntu Server

Get a fresh copy of Ubuntu Server Live Installer for "Jammy" (22.04).
[https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/](https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/)

Burn that to a USB and do a standard install. You will probably want to enable ssh. Don't try to add "extra drivers" at this point. I would also skip installing any snaps for things like docker since I will cover that install in the next post. Just do a simple install following the install prompts.

After first boot update and upgrade the system. It should already be mostly up to date if you grabbed a fresh install ISO.
```bash
sudo apt update
sudo apt upgrade
```

### Step 1.1 - Fix Ubuntu Server Annoyances (optional?)

#### Annoyance 1 - "A start job is running for wait for network to be configured" 
**How to prevent unused network interfaces from waiting for DHCP on boot.**

Ubuntu Server by default uses `networkd` with `netplan` to configure networking. [I will often configure NetworkManager as the renderer](https://gist.github.com/dbkinghorn/ed923bbcb7ec3f53bd2da5fe5e9b49b2) however in this guide I will stay with networkd but change the config to prevent the annoyance of unused interfaces waiting for DHCP on boot.

You will need to edit the `netplan` config file in `/etc/netplan`.
First create a backup of the original install config file.
```bash
sudo cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
```
Then edit the file with your favorite editor. As an example, the system I'm using while writing this post has 2 network interfaces and only one is being used. This was configured by the installer and looks like this: (yours will probably be different.)
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
Using `ip addr` I see that enp6s0 is an interface I'm not using on this system. On boot, networkd will wait (over 2min!) for this interface to get an address from DHCP even though is not connected i.e. has NO-CARRIER. To fix this we will make the interface "optional" by adding the `optional: true` line to the config. The config will now look like this:
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
Now apply the config with: `sudo netplan apply`.
On the next boot there will be no more waiting for unused interfaces to get an address from DHCP! Yay!

**You (or ask your network administrator) should assign a "static lease" from your DHCP server to the interface you want to be running your services on.** You can get your current assigned IP address and interface MAC address with: `ip addr`. Alternatively you can arrange to use a static IP address and configure `netplan` accordingly. [See the docs](https://netplan.readthedocs.io/en/stable/).

#### Annoyance 2 - Grub menu time out is set to 0 seconds (optional)
**How to get the grub boot menu to show during boot in Ubuntu.**

In the file /etc/default/grub change the GRUB_TIMEOUT value to 6 (the number of seconds you want it to wait for a key press) and change "hidden" to "menu". Then run update-grub. Do this manually or with the following scriptable commands:
```bash
sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=6/g' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub
sudo update-grub
```
Now you will see the grub menu for 6 seconds and have a chance to select a different kernel or set kernel boot options to fix problems if needed! (You can use [esc] during the start of boot to get to grub menu too if you don't want to make this change. I prefer to see the menu by default.)

#### Annoyance 3 - Stop unscheduled automatic updates from regularly breaking your server setup.
**How to disable "some" Ubuntu server automatic updates**

On a server OS deployment, you want to keep packages current with security updates. However, you should be doing this on your schedule not letting some default config do it without your knowledge or control. When important packages like the kernel, driver modules and packages from 3rd party repositories are updated there is a chance your system will break and require a reboot or more to get things working again. That can make users and administrators very unhappy! Ubuntu server will happily update and break your system automatically at irregular intervals if you don't stop it. Let's change that for automatic kernel and NVIDIA driver updates. 

**Think carefully about this since you will need to handle security updates yourself for the packages that you exclude from auto updating.**

You will need to edit `/etc/apt/apt.conf.d/50unattended-upgrades`.

This a config file with many options. We add a couple of simple excludes to the `Unattended-Upgrade::Package-Blacklist` section. The section starts as,

```
// Python regular expressions, matching packages to exclude from upgrading
Unattended-Upgrade::Package-Blacklist {
    // The following matches all packages starting with linux-
//  "linux-";
...
...
};
```

Excluding Linux kernel updates and NVIDIA driver updates will probably be all you need to keep your system from breaking from automatic updates. We will exclude all packages that start with `linux-` and `nvidia-`

To see what those pagkages are you can do,
```bash
apt list --installed | grep '^linux-'
apt list --installed | grep '^nvidia-'
```

The following script lines should do it.

```bash
sudo cp /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.bak

sudo sed -i 's|//  "linux-";|"  linux-";\n  "nvidia-";|' /etc/apt/apt.conf.d/50unattended-upgrades

```

With those applied that section of the config file will look like this,
```
// Python regular expressions, matching packages to exclude from upgrading
Unattended-Upgrade::Package-Blacklist {
    // The following matches all packages starting with linux-
  "linux-";
  "nvidia-";
...
...
};
```

The next time the `unattended-upgrades` service is run those changes will be read.

Those are the main annoyances I would feel remiss if I didn't include fixes for in this post.

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
```bash
sudo shutdown -r now
```
After restarting check that the driver is loaded with:
```bash
nvidia-smi
```

## Next Steps

I'm going to stop this Part 1 post here. The configuration steps above should provide a stable base server platform suitable for the next configuration steps toward a robust AI server platform.

The next post will cover container runtime setups. This will include,
- The ubiquitous Docker 
- My favorite container tool, NVIDIA Enroot
- And possibly Podman which is in nearly all cases, a good alternative to Docker. And it can be used in user space without elevated privileges. 

After the container runtime configuration post we will move on to [Hugging Face TGI server](https://github.com/huggingface/text-generation-inference) and [Chat-ui interface.](https://github.com/huggingface/chat-ui)

... to be continued ...

**Happy computing --dbk @dbkinghorn**


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

