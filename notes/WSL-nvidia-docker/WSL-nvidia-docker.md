# Note: How to Install and configure Docker on WSL

Using Ubuntu 20.04 image for WSL2

## Step 1) Preparation and Clean Up

**Docker:**
We will be installing the latest docker-ce for Ubuntu 20.04. If you have a docker install from the "standard" Ubuntu repos the it will be out of date. So start by removing any old docker installs.

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

## Step 2) Install docker-ce

The Docker community edition is simple to install and keep up-to-date on Ubuntu by adding the official repo. 

We'll be able to follow the install described in the official documentation, https://docs.docker.com/install/linux/docker-ce/ubuntu/  

1) Install some required packages, (they may already be installed)
```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

2) Add and check the docker key,
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
```
The fingerprint should match "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"

3) Now add the repository

```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

**Note: Docker-ce 19.03+ is fully supported on Ubuntu 20.04. 

1) Install docker-ce.
```
sudo apt-get update
sudo apt-get install docker-ce  docker-ce-cli  containerd.io
```
Note: "containerd.io" is independent of docker but included in that repository.

2) Start the docker service
```
sudo service docker start
```

3) Check docker,

```
sudo docker run --rm hello-world
```
That should pull and run the hello-world container from Docker Hub. At this point only "root" can run docker. We will add user configuration in step 4).

## Step 3) Install NVIDIA Container Toolkit
 
1) Go to https://github.com/NVIDIA/nvidia-docker and check what is the latest Ubuntu version supported. As of this writing supported Ubuntu versions are 14.04, 16,04, and 18.04 (all long term support versions). If you are using Ubuntu 18.04 or one of the other LTS releases then this will be simple. If you are using Ubuntu 19.04 then you will need to make one small change.

2) Configure repo and install
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install nvidia-container-toolkit

sudo systemctl restart docker
```
---
**Note for Ubuntu 19.04**
You will need to force the the repo to Ubuntu 18.04. The simplest thing will be to set "distribution" to ubuntu18.04 where it is used in "curl",

```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install nvidia-container-toolkit

sudo systemctl restart docker
```
I've used this on several Ubuntu 19.04 installs and have not had any problems.

---

3) For a quick test of your install try the following (still running as root for now),

```
sudo docker run --gpus all --rm nvidia/cuda nvidia-smi
```
 After the container downloads you should see the nvidia-smi output from the latest cuda release.

 ## Step 4) User Group, UserNamespace Configuration, and GPU Performance Tuning 

This section is where we turn docker into a more pleasant to use experience on a personal Workstation. 

**The most important aspect of this section will be setting up a configuration where "you" will "own" any files you create while using a container.** You will be able to mount working directories from your home directory into a container and retain full ownership of any files after the container is shutdown.   

 1) Add your user name to the docker group
The first thing to do is add your user account to the docker group so that you can run docker without sudo.
```
sudo usermod -aG docker your-user-name
```
**Note:** You will need to logout and back in for this to take effect.

2) Add your user and group id's as "subordinate id's".

Now we do the configuration to give you process and file ownership from inside a container.

See [How-To Setup NVIDIA Docker and NGC Registry on your Workstation - Part 3 Setup User-Namespaces](https://www.pugetsystems.com/labs/hpc/How-To-Setup-NVIDIA-Docker-and-NGC-Registry-on-your-Workstation---Part-3-Setup-User-Namespaces-1114/) for a detailed discussion of how and why you might want to do this.

Add a subordinate user and group id. I used my user-id 1000 and user-name "kinghorn". Use your own user-name and id. You can use the `id` command to check your user and group ids.
```
sudo usermod -v 1000-1000 kinghorn
```
and a subordinate group
```
sudo usermod -w 1000-1000 kinghorn
```

## Gotcha #1 "subuid ordering"
The commands above append the subuid (gid) to /etc/subuid and /etc/subgid. This "used" to be fine but now the order of entries matters. By default there will be other entries in those files including a "high ID range" default for your user. My setup looked like the following after running the above commands,
```
kinghorn:165536:65536
kinghorn:1000:1
```
You can ignore entries for lxd and root. You can also leave entries like "kinghorn:165536:65536" in-place but you will need to move the entry like "kinghorn:1000:1" to be above higher numbered subuid's. You will need to be root to edit the file so first do, `sudo -s` to get a root shell and then use you editor of choice (nano is fine) to edit the files to change the ordering, i.e. it should look more like,
```
kinghorn:1000:1
kinghorn:165536:65536
```
**Edit both /etc/subuid and /etc/subgid to reflect this reordering**

3) Setup the docker configuration file for your User Namespace, and GPU compute performance optimizations.   

You cannot access the docker configuration directory unless you are "root" so before you edit the file /etc/docker/daemon.json
do, `sudo -s` to give yourself a root shell and then `cd /etc/docker`. 

If there is an existing docker `daemon.json` config file create a backup and then create a new file with the following JASON. (when I did this for testing there was no existing daemon.json file in the directory)

```
{
    "userns-remap": "kinghorn",
    "default-shm-size": "1G",
    "default-ulimits": {
	     "memlock": { "name":"memlock", "soft":  -1, "hard": -1 },
	     "stack"  : { "name":"stack", "soft": 67108864, "hard": 67108864 }
    }
}
```

```
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "userns-remap": "kinghorn",
    "default-shm-size": "1G",
    "default-ulimits": {
	     "memlock": { "name":"memlock", "soft":  -1, "hard": -1 },
	     "stack"  : { "name":"stack", "soft": 67108864, "hard": 67108864 }
    }
}
```


Now do,
```
chmodd 600 daemon.json
```
to secure the config file.

**Note:** Be sure to to change that "kinghorn" to your own user name! 

Docker will read this file on startup. 

This config sets up your "user" in the docker User Namespace. That means that even though you see a root prompt in a docker container any files you create will belong to you in your system namespace. Please reed the post I mentioned in part (2) of this step to understand the full meaning of this.

The last part ot the config changes the (pitiful) default performance parameters so the you can run large GPU accelerated compute jobs. 

4) Restart docker
```
sudo service docker restart
```

5) Do a quick test. 
Exit out of the root shell if you are still in it. Then from your user account do,

```
kinghorn@[U20.04-docker]:~$ docker run --rm -it -v $HOME:/workspace alpine
/ # ls
bin        etc        lib        mnt        proc       run        srv        tmp        var
dev        home       media      opt        root       sbin       sys        usr        workspace
/ # cd workspace/
/workspace # touch file-from-alpine
/workspace # echo "Hello from Apline ... check who owns this file ..." > file-from-alpine
/workspace # ls -l file-from-alpine
-rw-r--r--    1 root     root            51 Jun 22 22:28 file-from-alpine
/workspace #

/workspace # exit
kinghorn@[U20.04-docker]:~$ ls -l file-from-alpine
-rw-r--r-- 1 kinghorn kinghorn 51 Jun 22 15:28 file-from-alpine
```
We bound our $HOME directory to /workspace in the container with 
```
-v $HOME:/workspace
```

Inside the container everything is owned by root but outside the container YOU own it!

Done!

## Install the NVIDIA container toolkit

**DO NOT INSTALL THE NVIDIA DISPLAY DRIVER IN WSL**

```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container-experimental.list | sudo tee /etc/apt/sources.list.d/libnvidia-container-experimental.list


        
```


## Examples

If you want to use some of the (many) nice containers that NVIDIA has put together on [NGC then go to their site](https://ngc.nvidia.com) and see what they have put together. It's pretty impressive!

![NGC image](NGC-page.png)

## Gotcha #2 NGC needs updated documentation to reflect the nvidia-docker2 deprecation

If you look at the [TensorFlow page on NGC](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow) you will see the old start-up syntax. That wont work with the new nvidia-container-toolkit! Hopefully this will get fixed soon (that may be the case by the time you read this post??)

On that page the documentation lists, **(old syntax)**

```
nvidia-docker run -it --rm -v local_dir:container_dir nvcr.io/nvidia/tensorflow:<xx.xx>-py<x>
```
 To use your new docker + nvidia-container-toolkit install you would need to do something like, **(new syntax)**

```
 docker run --gpus all -it --rm -v local_dir:container_dir nvcr.io/nvidia/tensorflow:<xx.xx>-py<x>
```

I would start up their TensorFlow container with something like,

```
docker run --gpus all --rm -it -v $HOME/projects:/projects nvcr.io/nvidia/tensorflow:19.08-py3
```
**Note:** The `-v $HOME/projects:/projects` part of that line is mapping a directory named "projects" in my home directory to the directory "/projects" in the container. Any files created there will be owned by me and remain there after exiting from the container instance. 


## Conclusion

You now have an up-to-date personal Workstation docker configuration with GPU acceleration.  

I hope you find this to as useful as I have!


---


**Happy computing! --dbk**


#OUTPUT

```
kinghorn@[U20.04-docker]:~/projects$ docker run --gpus all --rm -it -v $HOME/projects:/projects nvcr.io/nvidia/tensorflow:20.03-tf2-py3
Unable to find image 'nvcr.io/nvidia/tensorflow:20.03-tf2-py3' locally
20.03-tf2-py3: Pulling from nvidia/tensorflow
423ae2b273f4: Pulling fs layer
de83a2304fa1: Pulling fs layer
f9a83bce3af0: Pulling fs layer
b6b53be908de: Waiting                                                                                                                                 031ae32ea045: Waiting                                                                                                                                 2e90bee95401: Waiting                                                                                                                                 23b28e4930eb: Waiting                                                                                                                                 440cfb09d608: Pulling fs layer
440cfb09d608: Waiting                                                                                                                                 b0444ce283f5: Pulling fs layer
b0444ce283f5: Waiting                                                                                                                                 6cb1b0c70efa: Pulling fs layer
8326831bdd40: Waiting                                                                                                                                 69bbced5c7a2: Pulling fs layer
5f6e40c02ff4: Waiting                                                                                                                                 ca7835aa5ed2: Waiting                                                                                                                                 69bbced5c7a2: Waiting                                                                                                                                 d85924290896: Pulling fs layer
4c512b1ff8a5: Waiting                                                                                                                                 d85924290896: Waiting                                                                                                                                 97bb0d3f884c: Waiting                                                                                                                                 51bcf8ebb1f7: Waiting                                                                                                                                 56a4e3b147c2: Waiting                                                                                                                                 6cb1b0c70efa: Waiting                                                                                                                                 14329437244d: Pulling fs layer
b2ba5d718dcb: Waiting                                                                                                                                 b16eb8a7f87e: Waiting                                                                                                                                 7e81dbfaa02d: Waiting                                                                                                                                 1643a8046e60: Waiting                                                                                                                                 3df58a25273f: Waiting
f4334ae2487b: Pull complete
5a134e0a5a86: Pull complete
aa14850d8d09: Pull complete
648045a5e42c: Pull complete
a38c180d9a8e: Pull complete
778b95a412e8: Pull complete
4fa9a5a7da3f: Pull complete
a45f38fa01b3: Pull complete
843015d5d8fc: Pull complete
4eec2f65f5bd: Pull complete
ade3a1b104fe: Pull complete
f8fce5eb99c6: Pull complete
3c725e0cb2aa: Pull complete
2a61d4307596: Pull complete
2dc6eeb2b2ce: Pull complete
fbc0f016bf6f: Pull complete
2e247e179dee: Pull complete
de8df21ad28a: Pull complete
47400f46ac96: Pull complete
ec2496fe77d3: Pull complete
a4793e891f7b: Pull complete
d87dba1b9241: Pull complete
d963c99c12f3: Pull complete
bd8ddc6d2768: Pull complete
4a5473270b44: Pull complete
1a7c7ae19bcf: Pull complete
4ad7d30af36f: Pull complete
9ccbec004e59: Pull complete
b766107cf862: Pull complete
d51a648a7641: Pull complete
b86c139f3aa7: Pull complete
Digest: sha256:7b74f2403f62032db8205cf228052b105bd94f2871e27c1f144c5145e6072984
Status: Downloaded newer image for nvcr.io/nvidia/tensorflow:20.03-tf2-py3

================
== TensorFlow ==
================

NVIDIA Release 20.03-tf2 (build 11026100)
TensorFlow Version 2.1.0

Container image Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
Copyright 2017-2019 The TensorFlow Authors.  All rights reserved.

Various files include modifications (c) NVIDIA CORPORATION.  All rights reserved.
NVIDIA modifications are covered by the license terms that apply to the underlying project or file.

WARNING: The NVIDIA Driver was not detected.  GPU functionality will not be available.
   Use 'nvidia-docker run' to start this container; see
   https://github.com/NVIDIA/nvidia-docker/wiki/nvidia-docker .

NOTE: MOFED driver for multi-node communication was not detected.
      Multi-node communication performance may be reduced.

root@8eb0cf7f4704:/workspace# ls
README.md  docker-examples  nvidia-examples
root@8eb0cf7f4704:/workspace# cd nvidia-examples/cnn/
root@8eb0cf7f4704:/workspace/nvidia-examples/cnn# ls
README.md  nvutils  resnet.py  resnet_ctl.py  resnet_model.py  trivial.py
root@8eb0cf7f4704:/workspace/nvidia-examples/cnn# python resnet.py  --batch_size=64 --precision=fp32
2020-06-22 23:32:23.250536: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudart.so.10.2
2020-06-22 23:32:23.874530: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libnvinfer.so.7
2020-06-22 23:32:23.875116: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libnvinfer_plugin.so.7
PY 3.6.9 (default, Nov  7 2019, 10:44:02)
[GCC 8.3.0]
TF 2.1.0
Script arguments:
  --image_width=224
  --image_height=224
  --distort_color=False
  --momentum=0.9
  --loss_scale=128.0
  --image_format=channels_last
  --data_dir=None
  --data_idx_dir=None
  --batch_size=64
  --num_iter=300
  --iter_unit=batch
  --log_dir=None
  --export_dir=None
  --tensorboard_dir=None
  --display_every=10
  --precision=fp32
  --dali_mode=None
  --use_xla=False
  --predict=False
2020-06-22 23:32:24.482789: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcuda.so.1
2020-06-22 23:32:25.254837: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:25.255848: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1555] Found device 0 with properties:
pciBusID: 0000:65:00.0 name: GeForce RTX 2080 Ti computeCapability: 7.5
coreClock: 1.545GHz coreCount: 68 deviceMemorySize: 11.00GiB deviceMemoryBandwidth: 573.69GiB/s
2020-06-22 23:32:25.255978: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudart.so.10.2
2020-06-22 23:32:25.256158: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcublas.so.10
2020-06-22 23:32:25.260732: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcufft.so.10
2020-06-22 23:32:25.261597: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcurand.so.10
2020-06-22 23:32:25.266359: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcusolver.so.10
2020-06-22 23:32:25.269876: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcusparse.so.10
2020-06-22 23:32:25.270046: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudnn.so.7
2020-06-22 23:32:25.271251: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:25.273041: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:25.273965: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1697] Adding visible gpu devices: 0
2020-06-22 23:32:25.344388: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 3503995000 Hz
2020-06-22 23:32:25.354104: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x478d3c0 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2020-06-22 23:32:25.354158: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2020-06-22 23:32:26.208249: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:26.209659: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x4771800 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2020-06-22 23:32:26.209790: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): GeForce RTX 2080 Ti, Compute Capability 7.5
2020-06-22 23:32:26.223504: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:26.224431: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1555] Found device 0 with properties:
pciBusID: 0000:65:00.0 name: GeForce RTX 2080 Ti computeCapability: 7.5
coreClock: 1.545GHz coreCount: 68 deviceMemorySize: 11.00GiB deviceMemoryBandwidth: 573.69GiB/s
2020-06-22 23:32:26.224578: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudart.so.10.2
2020-06-22 23:32:26.224683: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcublas.so.10
2020-06-22 23:32:26.224774: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcufft.so.10
2020-06-22 23:32:26.224874: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcurand.so.10
2020-06-22 23:32:26.224977: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcusolver.so.10
2020-06-22 23:32:26.225105: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcusparse.so.10
2020-06-22 23:32:26.225198: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudnn.so.7
2020-06-22 23:32:26.226156: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:26.228015: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:26.228733: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1697] Adding visible gpu devices: 0
2020-06-22 23:32:26.228887: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudart.so.10.2
2020-06-22 23:32:27.725233: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1096] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-06-22 23:32:27.725296: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1102]      0
2020-06-22 23:32:27.725309: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] 0:   N
2020-06-22 23:32:27.727008: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:27.727516: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1324] Could not identify NUMA node of platform GPU id 0, defaulting to 0.  Your kernel may not have been built with NUMA support.
2020-06-22 23:32:27.728591: E tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:967] could not open file to read NUMA node: /sys/bus/pci/devices/0000:65:00.0/numa_node
Your kernel may have been built without NUMA support.
2020-06-22 23:32:27.729175: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1241] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 9309 MB memory) -> physical GPU (device: 0, name: GeForce RTX 2080 Ti, pci bus id: 0000:65:00.0, compute capability: 7.5)
WARNING:tensorflow:Expected a shuffled dataset but input dataset `x` is not shuffled. Please invoke `shuffle()` on input dataset.
2020-06-22 23:32:43.214511: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcublas.so.10
2020-06-22 23:32:43.799864: I tensorflow/stream_executor/platform/default/dso_loader.cc:44] Successfully opened dynamic library libcudnn.so.7
2020-06-22 23:32:52.019963: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:52.020060: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:52.459564: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:52.459733: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:53.029522: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.34GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:53.029590: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.34GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:53.229229: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:53.229334: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:54.230296: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
2020-06-22 23:32:54.230411: W tensorflow/core/common_runtime/bfc_allocator.cc:243] Allocator (GPU_0_bfc) ran out of memory trying to allocate 2.55GiB with freed_by_count=0. The caller indicates that this is not a failure, but may mean that there could be performance gains if more memory were available.
global_step: 10 images_per_sec: 15.5
global_step: 20 images_per_sec: 139.1
global_step: 30 images_per_sec: 138.1
global_step: 40 images_per_sec: 145.7
global_step: 50 images_per_sec: 131.6
global_step: 60 images_per_sec: 134.2
global_step: 70 images_per_sec: 145.6
global_step: 80 images_per_sec: 150.3
global_step: 90 images_per_sec: 140.9
global_step: 100 images_per_sec: 150.3
global_step: 110 images_per_sec: 142.4
global_step: 120 images_per_sec: 137.4
global_step: 130 images_per_sec: 146.4
global_step: 140 images_per_sec: 139.4
global_step: 150 images_per_sec: 138.1
global_step: 160 images_per_sec: 134.3
global_step: 170 images_per_sec: 131.0
global_step: 180 images_per_sec: 132.2
global_step: 190 images_per_sec: 138.6
global_step: 200 images_per_sec: 139.1
global_step: 210 images_per_sec: 139.0
global_step: 220 images_per_sec: 140.5
global_step: 230 images_per_sec: 135.2
global_step: 240 images_per_sec: 138.6
global_step: 250 images_per_sec: 143.6
global_step: 260 images_per_sec: 140.5
global_step: 270 images_per_sec: 140.1
global_step: 280 images_per_sec: 142.3
global_step: 290 images_per_sec: 141.3
global_step: 300 images_per_sec: 139.3
epoch: 0 time_taken: 174.2
300/300 - 174s - loss: 9.1441 - top1: 0.7829 - top5: 0.8117
root@8eb0cf7f4704:/workspace/nvidia-examples/cnn#
```
