# LLM Server Setup Part 2 -- Container Tools

## Introduction

**This post is Part 2 in a series on how to configure a system for LLM deployments and development usage.** The configuration will be suitable for multi-user deployments and also useful for smaller development systems. I will describe configuration steps in detail with commands suitable for scripts to automate the process. **Part 2 is about installing and configuring container tools, Docker and NVIDIA Enroot.**

**These individual HowTo posts will be useful on their own and not just for LLM server configs!**

- **Part 1** -- [LLM Server Setup Part 1 – Base OS](https://www.pugetsystems.com/labs/hpc/llm-server-setup-part-1-base-os/) Describes installing Ubuntu Server 22.04, applying configuration changes/fixes and installing the NVIDIA driver package.

Containerization has become the most sensible server application deployment methodology. Really, for deploying any complex application code. This is equally true for deployments in the cloud, on-prem server hardware, or even personal computers for development work. 

For reference the machines that are my deployment targets are a couple of these, [Puget Systems Qudad NVIDIA 6000Ada 5U system](https://www.pugetsystems.com/solutions/scientific-computing-workstations/machine-learning-ai/buy-404/). These are capable of serving Llama2-70b and derivatives form multi-user use with good performance. I am also doing this at home with a much more modest personal system.

We will go through two container development and runtime environments, Docker and NVIDIA Enroot.
### Docker
[Docker](https://www.docker.com/) is essentially the default containerization framework. It is becoming common for applications to include a Dockerfile or Compose file for deployment. This is a very welcomed trend! When you are dealing with packages that have non-trivial setup requirements and dependencies, if they do not include access to a docker container or build file then you are usually best served to build one yourself.

The biggest downside of using Docker is that its installation digs itself deep into your system. It runs as a privileged daemon process and installation makes significant changes on your system. However, you likely need to have Docker available at least for development purposes. For application deployment, you may be able to use a simpler user-space container runtime application.

### NVIDIA Enroot
[NVIDIA Enroot](https://github.com/NVIDIA/enroot) is my favorite container runtime tool! It is not well known but it is a true gem. I have written blog post introducing Enroot that I recommend checking out if you are curious and want to see the arguments for using it. [Run “Docker” Containers with NVIDIA Enroot](https://www.pugetsystems.com/labs/hpc/run-docker-containers-with-nvidia-enroot-2142/) 

One of my principal reasons for including Enroot in this post is that it can be used to create **container bundles**. These container bundles are self-contained, portable, minimal dependency, runnable container applications that do not require any container runtime to be installed on the target system. Enroot will include itself in the bundle to run the container! I have a post describing this, [Self Contained Executable Containers Using Enroot Bundles](https://www.pugetsystems.com/labs/hpc/self-contained-executable-containers-using-enroot-bundles-2181/).

Here is a clip from the [Enroot GitHub page](https://github.com/NVIDIA/enroot),

#### Key Concepts
- Adheres to the KISS principle and Unix philosophy
Standalone (no daemon)
- Fully unprivileged and multi-user capable (no setuid binary, cgroup inheritance, per-user configuration/container store...)
- Easy to use (simple image format, scriptable, root remapping...)
- Little to no isolation (no performance overhead, simplifies HPC deployments)
- Entirely composable and extensible (system-wide and user-specific configurations)
- Fast Docker image import (3x to 5x speedup on large images)
- Built-in GPU support with libnvidia-container
- Facilitate collaboration and development workflows (bundles, in-memory containers...)


Most of this post will be concerned with installing and configuring Docker since it is much more complicated than Enroot (which doesn't require configuration.) After the Docker setup steps, I'll give instructions for installing Enroot. I will use Enroot in later posts (in addition to Docker.) 

## Container Tools 

We are picking up from where we left off in [Part 1](https://www.pugetsystems.com/labs/hpc/llm-server-setup-part-1-base-os/) after the OS setup and NVIDIA driver install.

### Step 1 - Install the NVIDIA Container Toolkit
This is a set of tools that will allow us to run containers with NVIDIA GPU support. [Note that this has been recently updated and as of this writing there are mixed instructions on the web.] [Current reference guide.](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

Add the signing key and install the repository information.
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list 
```

Update and install the toolkit.
```bash
sudo apt update
sudo apt install -y nvidia-container-toolkit
```

### Step 2 - Install Docker

Docker is ubiquitous and well-supported. I use it for creating/distributing new containers. I do prefer user-space container applications when I can use them. [Podman](https://podman.io/) for example is a great alternative to docker but it is unfortunately not well supported (kept current) by Canonical/Ubuntu. (I may do a separate post about installing an up-to-date Podman on Ubuntu.)  Also, there are times when you just really need to use docker. 

I will mostly follow the official Docker docs for the base Install.
Reference: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

For GPU setup we will take guidance from NVIDIA. 
Reference: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

### Step 2.1 - Uninstall old versions
This post is assuming a fresh Ubuntu server install but if you have an old version of Docker installed for any reason you will want to remove it first. 

```bash
sudo apt-get remove docker docker-engine docker.io docker-compose docker-doc containerd runc
```

### Step 2.2 - Add Docker's official GPG key:
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### Step 2.3 - Add the Docker repository to Apt sources:
```bash
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```
### Step 2.4 - Install the Docker packages:
```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
### Step 2.5 - Verify that Docker Engine is installed correctly by running the hello-world image.
```bash
sudo docker run hello-world
```
That should run successfully as root. We will want to run docker as a non-root user and will configure that next.

### Step 3 - Docker Post Install
Reference: [https://docs.docker.com/engine/install/linux-postinstall/](https://docs.docker.com/engine/install/linux-postinstall/)

### Step 3.1 Create a docker user access group.
```bash
sudo groupadd docker
```
### Step 3.2 Add your user account to the docker group.
```bash
sudo usermod -aG docker $USER
```
### Step 3.3 Activate the changes to the system groups.
```bash
newgrp docker
```

After these steps (no re-login required) you should be able to run docker as a regular user. The containers still run as root though.

### Step 3.4 Verify that you can run docker commands without sudo.
```bash
docker run hello-world
```

### Step 3.5 Enable docker service daemons to start on boot
```bash
sudo systemctl enable --now docker.service 
sudo systemctl enable --now containerd.service
```
The `--now` option will start the service immediately.

### Step 3.6 "Arrrrggg!!" - What to do if Docker breaks your LAN! (hopefully optional)
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
 
Hopefully, you won't need any of that!

### Step 3.7 - Configure Docker to use the NVIDIA Container Toolkit
In step 1 we installed the NVIDIA Container Toolkit. Now we need to configure Docker to use it.

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```
### Step 3.8 Fix Docker default shm size and other runtime configuration env parameters
The shared memory size for docker is too small for containers doing heavy computation. We will fix this by editing the /etc/docker/daemon.json file. If the file does not exist yet, create it. We will also add a few other heavy-load performance environment changes. See my 2018 post for details (it's still relaxant.) [How-To Setup NVIDIA Docker and NGC Registry on your Workstation – Part 5 Docker Performance and Resource Tuning](https://www.pugetsystems.com/labs/hpc/how-to-setup-nvidia-docker-and-ngc-registry-on-your-workstation-part-5-docker-performance-and-resource-tuning-1119/)

```bash
echo '{
    "default-shm-size": "8G",
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

You should now have a Docker install with good support for demanding GPU-accelerated applications. If you want a useful container tool that is much lighter weight than Docker then check out Enroot next.

### Step 4 - Install NVIDIA Enroot (optional but recommended)

My favorite container runtime is [NVIDIA Enroot](https://github.com/NVIDIA/enroot) and I use it whenever I can. I will cover its installation in this next section. You can consider this optional but I do recommend that you give Enroot a try if you want a simple container runtime tool that can be surprisingly useful. See the reference links near the top of this post for some usage examples. I will include some Enroot usage examples in later parts of this series of blog posts.  

#### Take a look at the Enroot GitHub pages

[https://github.com/NVIDIA/enroot](https://github.com/NVIDIA/enroot/)

I will do this section as an install script section for Enroot. You will want to have the NVIDIA driver installed and I recommend having the NVIDIA container toolkit installed.  

```bash
# Install dependencies and useful tools
sudo apt-get update
sudo apt-get install --yes curl gawk jq squashfs-tools parallel
sudo apt-get install --yes fuse-overlayfs pigz squashfuse

# Get the latest release tag from the GitHub API and remove the 'v'
RELEASE=$(curl -s https://api.github.com/repos/NVIDIA/enroot/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' | tr -d 'v')

# Print the release tag
echo "Installing enroot release: $RELEASE"


## Install
arch=$(dpkg --print-architecture)
# arch is amd64
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot_${RELEASE}-1_${arch}.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot+caps_${RELEASE}-1_${arch}.deb 

sudo apt-get install --yes ./enroot_${RELEASE}-1_${arch}.deb
sudo apt-get install --yes ./enroot+caps_${RELEASE}-1_${arch}.deb

# Clean up
rm ./enroot_${RELEASE}-1_${arch}.deb
rm ./enroot+caps_${RELEASE}-1_${arch}.deb

```

## Next Steps

With [Part 1](https://www.pugetsystems.com/labs/hpc/llm-server-setup-part-1-base-os/)  and Part 2 of this post series implemented you will have a good base server platform suitable for the development and deployment of a robust AI server platform.

The next posts in this series will be LLM server and model deployments. This will include,
- [Hugging Face Text Generation Inference (TGI) server](https://github.com/huggingface/text-generation-inference)
- [Hugging Face Chat-UI](https://github.com/huggingface/chat-ui)
- Other server and user interfaces, such as [Ollama](https://ollama.ai/),  NVIDIA [triton](https://www.nvidia.com/en-us/ai-data-science/products/triton-inference-server/) server and [tensorRT](https://github.com/NVIDIA/TensorRT) optimizations, [NeMo](https://github.com/NVIDIA/NeMo), etc.
- Example model deployments, Llama-2, CodeLama, etc. 

... more to come ...

**Happy computing --dbk @dbkinghorn**