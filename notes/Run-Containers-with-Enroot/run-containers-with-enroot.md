# Run "Docker" Containers with NVIDIA Enroot


## Introduction

[Enroot](https://github.com/NVIDIA/enroot/blob/master/doc/usage.md) is a simple and modern way to run "docker" containers. It provides an unprivileged user "sandbox" that integrates easily with a "normal" end user workflow. I like it for running development environments and especially for running NVIDIA NGC containers. This has been my preferred way to use containers for over a year now and this is the first time I have written about it!  

I've been using docker and containers for several years. I first wrote about docker in early 2017 starting with [Docker and NVIDIA-docker on your workstation: Motivation](https://www.pugetsystems.com/labs/hpc/Docker-and-NVIDIA-docker-on-your-workstation-Motivation-892/). That post was followed by 6 other posts in 2017 about setting up and using docker. In 2018 I did a series of posts refreshing docker usage for running NVIDIA NGC containers. The last post (containing links to the others) was [How-To Setup NVIDIA Docker and NGC Registry on your Workstation - Part 5 Docker Performance and Resource Tuning](https://www.pugetsystems.com/labs/hpc/How-To-Setup-NVIDIA-Docker-and-NGC-Registry-on-your-Workstation---Part-5-Docker-Performance-and-Resource-Tuning-1119/) Those ideas and configurations are still valid. However, I stopped installing and using docker in 2019 after great conversations with the enroot developers at GTC19. 

**Note: I'm presenting this from a personal end-user perspective.** Enroot is useful for larger infrastructure too. It integrates easily with the distributed resource manager [SLURM](https://slurm.schedmd.com/documentation.html) See for example the slides from this Fosdem 2020 talk [Distributed HPC Applications with Unprivileged Containers](https://archive.fosdem.org/2020/schedule/event/containers_hpc_unprivileged/attachments/slides/3711/export/events/attachments/containers_hpc_unprivileged/slides/3711/containers_hpc_unprivileged.pdf) Or [this YouTube video of the talk.](https://www.youtube.com/watch?v=hAYhQkcFCfA&t=4s)  I have also used enroot to successfully add containers along with locally installed environments with JupyterHub. For these kinds of container uses [Singularity](https://singularity.lbl.gov/archive/docs/v2-4/about) is often used and you will see reference usage instructions on most of the NGC containers. However, enroot is an attractive alternative in my opinion (and finally some NVIDIA's NGC containers are referencing it! ).   

In this post I'll go through steps for installing enroot and some simple usage examples including running NVIDIA NGC containers. This post will be a reference for setup reproducibility when I use enroot as a container runtime in the future.

## Why or Why not to use Enroot

If you have tried to use docker with containers as a local "application" or development-environment install alternative then I probably don't have to provide much argument to convince you to try something else! Docker can be frustrating for that. Docker is useful (on your system) if you are doing container development work to submit to a production DevOps environment using containers. Maybe a Kubernetes cluster or cloud deployment. 

- **Enroot is simple.** This one of the design principles. You can pull containers from registries (local or remote). It uses overlays to avoid redundant downloads. It creates a [squashfs](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) container image. And then from that image you 'enroot create' what is a basically a named chroot sandbox but utilizing user and mount namespaces. Then you 'enroot start' to run the container. 
- **It runs as an unprivileged user-space application**, no system daemon is used. Root is not required nor used as the user in the container. 
- **The user owns the created file-systems.** You can start a container with --root and --rw for read write root access to make system level changes if needed (without root privilege on the host system). You can bind your home directory into the container at start time for a **seamless workflow with your local system**.
- **It is fast** to download containers, create images and quick to start.  
- It has **built in GPU support with libnvidia-container.** 
- It **works well with resource managers and application servers** (like **SLURM** and **JupyterHub**).
- You can **create containers with docker or other build tools** and import and use them with enroot.
- **It wont interfere** with any other container runtime applications you may be using.
- **Enroot is a great way to use NVIDIA's excellent container and resources on NGC!**

... on the down side,
- You **can use a lot of disk space** with framework and dev environment containers (that's true for any container runtime)
- It **could use better documentation.** It's simple enough but the documentation supplied for the project on GitHub covers functionality and usage but is minimal and could be difficult to understand for users not familiar with the underling technology. [I keep thinking I should help with that!]
- **It's not docker!** For some people that could be a problem. If you need to be using a fully docker compatible/command-equivalent container runtime then I would highly recommend looking at **[Podman](https://podman.io/)**. In fact having both enroot and podman on your system is not a bad idea.   

## Installing Enroot

I'll be installing on Ubuntu 20.04 but any recent Linux distribution should be OK.

**NOTE:** **Enroot will work on Windows 10 under WSL2!** The current Windows Insider dev channel build also has support for GPU usage with libnvidia-container. That will become part of the GA Windows release (hopefully soon). I will probably be writing about this sometime after the MS BUILD 2021 meeting.

**Note:** I'm using Ubuntu 20.04 on x86_64 for this install guide. Enroot supports x86_64, ARM64, and POWER architectures, and distributions based on Debian, RHEL and also builds from source.  

## Step 1) Prerequisites 

The enroot deb installer will have most of these packages as dependencies and install them but, we can also install them first. (some of them may already be installed)

```
sudo apt install -yes curl gawk jq squashfs-tools parallel zstd bsdmainutils
```
These are optional (recommended and suggested) I install them,
```
sudo apt install -yes fuse-overlayfs pigz squashfuse
```

Additionally, if you are planning to use GPU support with libnvidia-container-tools then be sure you have a recent NVIDIA driver installed. [You can use enroot without GPU support but what's the fun in that!]

## Step 2) Install the latest libnvidia-container-tools for GPU support


I recommend using the latest version of libnvidia-container-tools from the NVIDIA repository, (add the repo and install)
```
DIST=$(. /etc/os-release; echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -

curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list | \
    sudo tee /etc/apt/sources.list.d/libnvidia-container.list

sudo apt-get update
sudo apt-get install --yes libnvidia-container-tools
```

## Step 3) Check the latest release version of enroot and run the "check" script

Go to [https://github.com/NVIDIA/enroot/releases](https://github.com/NVIDIA/enroot/releases) and check the latest release version number. [As I write this it is at version 3.3.0 -- which will be entered in the RELEASE variable below.]

```
RELEASE=3.3.0

curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot-check_${RELEASE}_$(uname -m).run

chmod 755 enroot-check_*.run

./enroot-check_*.run --verify
```

The output should look something like,
```
kinghorn@i9:~/projects/enroot$ ./enroot-check_3.3.0_x86_64.run --verify
Kernel version:

Linux version 5.8.0-50-generic (buildd@lgw01-amd64-030) (gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #56~20.04.1-Ubuntu SMP Mon Apr 12 21:46:35 UTC 2021

Kernel configuration:

CONFIG_NAMESPACES                 : OK
CONFIG_USER_NS                    : OK
CONFIG_SECCOMP_FILTER             : OK
CONFIG_OVERLAY_FS                 : OK (module)
CONFIG_X86_VSYSCALL_EMULATION     : OK
CONFIG_VSYSCALL_EMULATE           : KO (required if glibc <= 2.13)
CONFIG_VSYSCALL_NATIVE            : KO (required if glibc <= 2.13)

Kernel command line:

vsyscall=native                   : KO (required if glibc <= 2.13)
vsyscall=emulate                  : KO (required if glibc <= 2.13)

Kernel parameters:

kernel.unprivileged_userns_clone  : OK
user.max_user_namespaces          : OK
user.max_mnt_namespaces           : OK

Extra packages:

nvidia-container-cli              : OK
```
The "KO" messages are from checks for configuration that would be needed on an old distribution using an old glibc. You can ignore these on Ubuntu 20.04.

If you want to check your glibc version do this,
```
ldd --version 
```
On my system that's,
```
kinghorn@i9:~/projects/enroot$ ldd --version
ldd (Ubuntu GLIBC 2.31-0ubuntu9.2) 2.31
...
```

## Step4) Install Enroot

```
RELEASE=3.3.0
arch=$(dpkg --print-architecture)

curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot_${RELEASE}-1_${arch}.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot+caps_${RELEASE}-1_${arch}.deb # optional

sudo apt-get install --yes ./enroot_${RELEASE}-1_${arch}.deb
sudo apt-get install --yes ./enroot+caps_${RELEASE}-1_${arch}.deb

```
The "+caps" installer provides extra capabilities for unprivileged users to import and convert container images. You want that if you are configuring for your own personal use i.e. not a restricted multi-user server setup.

You can clean up the install with,
```
rm ./enroot_${RELEASE}-1_${arch}.deb
rm ./enroot+caps_${RELEASE}-1_${arch}.deb
rm ./enroot-check_*.run
```

## Step 5) Optional configuration

There are several configuration changes that you can make but the defaults are well chosen. If you are using enroot to run containers as part of your workflow you may want to have your home director mounted in the container sandbox by default. This is the one change I like to make. This makes the container applications "feel" like they are just part of your normal workflow.

Enroot has a configuration directory at, /etc/enroot
```
kinghorn@i9:~$ ls /etc/enroot
enroot.conf environ.d  hooks.d  mounts.d
```
Edits in this directory will require root. To set mounting of $HOME by default edit /etc/enroot/enroot.conf  and uncomment the appropriate line and change the default from "no" to "yes",
```
# Mount the current user's home directory by default.
ENROOT_MOUNT_HOME          yes
```

Alternatively, you can set that as an environment variable in your .bashrc file.
```
export ENROOT_MOUNT_HOME=yes
```
or when starting a container sandbox use the --env flag i.e.
```
enroot start --env ENROOT_MOUNT_HOME=y  ... 
```

## Step 6) Read the docs!

I highly recommend you read the documentation on GitHub. Start at the [main Enroot GitHub page](https://github.com/NVIDIA/enroot). Read through some of the philosophy and design principles and then check out the doc links. 

I will warn you that there is not a lot of details there. Enroot is actually simple but if you don't understand what it is doing you may be a little lost. Enroot is easy enough to use in a productive way that hopefully you wont have trouble with it. 

## Examples of using Enroot

Keep in mind the typical procedure,
- use **enroot import** to pull a container. Usually in docker format from a container repository. Like [DockerHub](https://hub.docker.com/) or [NVIDIA NGC](https://ngc.nvidia.com/catalog) for example. 
- That import will pull a container image as a squashfs file. For example is may look something like "nvidia+cuda+10.0-base.sqsh". I have a directory named "containers" in my home directory where I keep these. 
- Then **enroot create --name ...** with that downloaded .sqsh file to make a "container sandbox" out of it. That will be a file system for the container instance that will by default be in $HOME/.local/share/enroot/
- **enroot start ...** to run the container sandbox

**Create and run basic ubuntu container,**


```
enroot import docker://ubuntu
```
The **docker://**  prefix will pull from any docker registry (DockerHub, NGC, etc.). You can think of that as replacement for "docker pull"  

In this case we have pulled the latest [default Ubuntu container from DockerHub](https://hub.docker.com/_/ubuntu). I imported/pulled it into my $HOME/container directory where it is named ubuntu.sqsh.

Now create the container sandbox, 
```
enroot create --name ubuntu ubuntu.sqsh
``` 
The "sandbox" filesystem should be in $HOME/.local.share.enroot/ubuntu.

This will show a list of your container sandboxes,
```
# enroot list
```

Now start the container,

```
enroot start ubuntu
```

Note: if you didn't make mounting your home directory default as I suggest in the configuration section then you wantt want to do,
```
export ENROOT_MOUNT_HOME=y   
enroot start ubuntu 

# (or use enroot start --env ENROOT_MOUNT_HOME=y ubuntu)
```
You should now be in the "sandbox". 

Note that at this point you will have your home directory mounted in the sandbox and you can do anything you would normally do but you will only have the applications that are in that container.  

You will probably want to modify the container by installing so packages for example. To do this you will need to start the container with --root --rw  so that you can read/write into the container file system.

first exit the container with, you guessed it, **exit**.  Then restart the container to make changes,

```
enroot start --root --rw ubuntu
```
You will have a root prompt. Now you can do things like,
```
apt-get update
apt-get install build-essential
```

**exit** when you are done. It's that easy to make changes.

Removing the container sandbox is simple, first exit from the container, then,
```
enroot remove ubuntu
```
That removes the director tree $HOME/.local/share/enroot/ubuntu. You can create a new one using the .sqsh file that you saved in your "containers" directory (or wherever you saved it).

## NVIDIA NGC containers
There are many useful GPU optimized container on [NVIDIA NGC](https://ngc.nvidia.com/catalog)!

Note: I will likely do separate post on using NGC.

**NGC TensorFlow 1.15 optimized with Ampere support (RTX30xx and "A" series GPUs)**

We will import the latest container build,

```
enroot import docker://nvcr.io#nvidia/tensorflow:21.04-tf1-py3
```

Note: This is importing the container anonymously. Many containers are public and available for anonymous download on NGC but some do require that you use a oath-token. 

To use a oath authentication and a token you would need to sign-up/sign-in and create a token (which you can save for reuse) and then do the container import as,
```
enroot import 'docker://$oauthtoken@nvcr.io#nvidia/tensorflow:21.04-tf1-py3'
```
Running this command would ask you for a password. You can simply paste in your oath token if you have not setup a credentials file for enroot. 

See the enroot documentation on ["credential file" for import](https://github.com/NVIDIA/enroot/blob/master/doc/cmd/import.md) from various registries. That link has an example credentials file with configuration for, NGC, DockerHub, Google Container Registry, and Amazon Elastic Container Registry.

Create the container sandbox,
```
enroot create --name tf1.15-ngc nvidia+tensorflow+21.04-tf1-py3.sqsh
```

Start it,
```
kinghorn@i9:~/containers$ enroot start tf1.15-ngc
                                                                                                                                                
================
== TensorFlow ==
================

NVIDIA Release 21.04-tf1 (build 22382986)
TensorFlow Version 1.15.5
...
```

## Conclusions

There you have it, an interesting way to run containers without using docker. Enroot works well as a personal container workflow runtime. I really like it's simplicity and the general usability. 

I wrote most of the commands for install in a way that you could put them into a bash shell script. I do that and enroot is one of the first things I install after a basic Ubuntu and NVIDIA driver install on systems that I'm working with. This is how I do my hardware benchmarking. I've been doing this for over a year and felt it was about time that I let folks know how I use it.

Expect to see more posts on enroot. I will give enroot usage info in posts where I am using it to run containers. Expect to see an interesting post on HPL, HPL-AI and HPCG performance on the (phenomenal) NVIDIA A100 GPU soon!

**Happy computing! --dbk @dbkinghorn** 

