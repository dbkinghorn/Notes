# LLM Server Setup Part 1 - Base OS


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

However, **the instructions in this post (and its follow-ups) are suitable for use with much more modest hardware!** Almost any system with one or more NVIDIA GPUs that have 16GB or more of VRAM will get you started. 

Note: at this point, I am only recommending NVIDIA GPU acceleration. But, soon AMD GPUs will be supported enough to be useful. I have already started experimenting with them. CPU-only deployment is also possible and I will investigate the feasibility of that in the future.

For hardware configurations see [Puget Systems "Workstations for Machine Learning / AI"](https://www.pugetsystems.com/solutions/scientific-computing-workstations/machine-learning-ai/). 

## Base Ubuntu Server install and config

I will describe a server config. However, you can do this setup for a personal AI dev system too, possibly using Ubuntu Desktop instead of server. The tips and fixes below should be helpful for Desktops too.

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

#### Annoyance 2 - Grub menu timeout is set to 0 seconds (optional)
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


