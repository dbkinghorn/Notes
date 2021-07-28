# Self-Contained Executable Containers Using Enroot Bundles

## Introduction

Containers have become a standard way to provide applications environments that contain all the necessary utility to run their designed task (except for their own runtime platform). They may be run with Docker, Podman, Kubernettes or other modern container runtime tools. My favorite container runtime application is NVIDIA Enroot.I like it's simplicity and logical workflow. It is designed to be flexible enough to work well in large HPC cluster environments. This simplicity and flexibility also makes it exceptionally usable as a "desktop container runtime environment".

All of the current container-runtime applications that I know of require that you install the underlying runtime infrastructure to use them.  This certainly makes sense and is completely expected. It may mean installing and enabling the Docker daemon and interface, Podman user-space environment or setting up a Kubernettes cluster, etc.. To fully use all the features of Enroot you would, as expected, need to install Enroot too. **However, Enroot has a unique feature that will let you easily create an executable, self-contained, single file package with a container image AND the runtime to start it up! This allows creation of a container package that will run itself on a system with or without Enroot installed on it! "Enroot Bundles".**

In this post I'll explain what Enroot Bundles are and go through a detailed example using many features of Enroot to create a custom container for running a Python Numpy benchmark.  This container will be converted to an Enroot Bundle and run on a system with only a base Ubuntu 20.04 server install. All the needed runtime capability is included in the single ".run" Enroot Bundle! 

## What is an Enroot Bundle

Your first question might be; What is Enroot? This post may help with that, ["Run "Docker" Containers with NVIDIA Enroot"](https://www.pugetsystems.com/labs/hpc/Run-Docker-Containers-with-NVIDIA-Enroot-2142/). Read through that post and take a look at the [documentation on GitHub](https://github.com/NVIDIA/enroot).

One of the things I didn't discus in the post above is Enroot Bundles. Honestly I hadn't tried them at that point. When I did create my first "bundle" I was amazed at the simplicity and potential utility. Here are a few points about Enroot Bundles,

- An Enroot Bundle is a runnable shell-archive. It's a ".run" file. A shell-archive is a shell script that combines shell commands and binary files into a single file. It is common to see them as install scripts. For example the NVIDIA driver and CUDA toolkit for Linux are optionally available this way.
- The simplicity and modularity of Enroot allow its needed runtime components to be contained in a "bundle" along with a container image.  
- By default a "bundle" will unpack itself, start its container image and then remove itself when you exit the container.
- You can specify a --target directory instead of the default /tmp where the container image sandbox file system will be created. 
- You can use --keep to keep the container sandbox filesystem from being removed at exit. You will then have that container sandbox available to "start" with Enroot (if you have it installed).
- You can run applications in the container as command-line arguments to the bundle ".run" file.
- You can modify or pass a startup "rc" file to the bundle when you run it.
- For a container image that is only using CPU there are essentially no dependencies other than a fairly modern kernel. A minimal Ubuntu server install is sufficient.
- Enroot has GPU support. For containers with GPU acceleration the client system will need to have a recent NVIDIA driver installed and one additional library, libnvidia-container installed. 
- The bundle ".run" file has a flag --verify that will display conformation that the kernel has the needed features to run a container and will indicate if GPU support is available.

## Example: Portable, Self Running Enroot Bundle for a Numpy Benchmark.

The best way to get a feel for what can be done with an Enroot bundle is to go through an example use case. For the creation of the bundle you will need to have Enroot installed, [(see my post introducing Enroot for that.)](https://www.pugetsystems.com/labs/hpc/Run-Docker-Containers-with-NVIDIA-Enroot-2142/) 

In this example we will use Enroot to;
- Create a minimal Ubuntu server 20.04 container sandbox instance using the official docker Ubuntu image
- Start the container read/write with root privilege and install Miniforge3 
- Install Numpy with OpenBLAS from condaforge
- Modify the container sandbox file system directly from the host. To add the benchmark code
- Export the modified container to a new container image 
- Create an Enroot bundle from the new image
- Run the benchmark on a separate system that does not have, Enroot, Miniforge, or Numpy installed.

The steps above will illustrate several features of using Enroot. I am building the bundle on my personal Ubuntu 20.04 Intel based development workstation with Enroot 3.3 installed. 

## Import the Ubuntu container from DockerHub

```
enroot import docker://ubuntu
```
That pulls the container image and creates a squash FS file to create a container "sandbox" from.

## Create the container sandbox

We will create a container instance (sandbox) from that container image and name it np-openblas

```
enroot create --name np-openblas ubuntu.sqsh
```

I'll report the size of components as we proceed.
```
du -sh ubuntu.sqsh 
51M     ubuntu.sqsh

du -sh ~/.local/share/enroot/np-openblas
78M     /home/kinghorn/.local/share/enroot/np-openblas
```
You see the default location for file system of the container instanced above. Enroot runs in user-space and the user "owns" the container image.

## Install Numpy in the container instance

Now start the container with --root and --rw so we can install wget and then miniforge 

First make sure you are not mounting your home directory since we are starting as root in the container, otherwise your user home directory will get mounted on /root  [This is only needed if you have changed the enroot default settings and have your $HOME mounted by default (which I normally do).]

```
export ENROOT_MOUNT_HOME=n
```

```
enroot start --root --rw np-openblas
```

We will need curl or wget to download the miniforge installer (you could download it locally and then just copy it into the container image instead which is what I would normally do but I wanted to illustrate doing an apt install in the container instance for this post)

```
apt-get update

apt-get install wget --no-install-recommend

rm -rf /var/lib/apt/lists/*
```
I'll do a "system" install of miniforge3 in /opt
```
cd /opt
wget --no-check-certificate  https://github.com/conda-forge/miniforge/releases/download/4.10.2-0/Miniforge3-4.10.2-0-Linux-x86_64.sh

sh Miniforge3-4.10.2-0-Linux-x86_64.sh 

(change the install location)
[/root/miniforge3] >>> /opt/miniforge3

rm Miniforge3-4.10.2-0-Linux-x86_64.sh

(Installing numpy into the "base" env)
/opt/miniforge3/bin/conda install numpy 

exit
```

Numpy is now installed in the container image and we have shut down the container.

The container size is now,
```
du -sh np-openblas
612M	np-openblas
```

It is probably possible to shrink the size of the container bundle but it may or may not be worth the effort depending on your use case.

Note that doing this with the a Numpy linked to Intel MKL will result in a container approx. 3 times larger!

Next step in the example is to add a bit of code that will run when the container starts.

## A simple numpy benchmark

Here is an executable Python numpy benchmark that you can use for testing.

```
#!/opt/miniforge3/bin/python3

import numpy as np
import time

def run_np_norm(size,dtype):

    sizes = {'huge': 40000, 'large': 20000, 'small': 10000, 'tiny': 5000, 'test': 100}
    
    n = sizes[size]
    A = np.array(np.random.rand(n,n),dtype=dtype)
    B = np.array(np.random.rand(n,n),dtype=dtype)   

    start_time = time.time()
    the_norm = np.linalg.norm(A@B)
    run_time = time.time() - start_time
    
    ops = 2E-9 * (n**3 + n**2)
    gflops = ops/run_time
    
    return the_norm, run_time, gflops

def main():
    
    repeats = 3
    prob_size = 'small'
    dtype = np.float64

    for i in range(repeats):
        print("running numpy norm test")
        result, run_time, gflops = run_np_norm(prob_size,dtype)
        print(f'norm: {result:.2f}\t Run time: {run_time:.5f} seconds\t GFLOPS: {gflops:.0f}')

# --------------------------------------------------
if __name__ == '__main__':
    main()
```

Save that in a file named np-norm-openblas.py  Note that I have set the "!#" line to the path to the python that we installed into the container image.

## Add the numpy benchmark to the container image directly from the host

I wanted to do this from the host so that you can see how easy it is to modify the container file-system (sandbox).

```
cp  np-norm-openblas.py /home/kinghorn/.local/share/enroot/np-openblas/usr/local/bin/
```

Make that file executable,
```
chmod 755 ~/.local/share/enroot/np-openblas/usr/local/bin/np-norm-openblas.py
```

## Test the modified container image and modify the startup "rc" file

Lets see what we have done. We'll start the container and run the benchmark program.

```
enroot start np-openblas
```

We are now in the container and since the benchmark file is executable and on the default path we cna just run it.

```
(np-openblas)kinghorn@i9:/$ np-norm-openblas.py
running numpy norm test
norm: 25003427.73        Run time: 3.06277 seconds       GFLOPS: 653
running numpy norm test
norm: 25002406.43        Run time: 3.04929 seconds       GFLOPS: 656
running numpy norm test
norm: 24998160.53        Run time: 3.08600 seconds       GFLOPS: 648

exit
```

It runs. Now edit the /etc/rc file to have it run that code when the container starts. I'm doing this from the host for simplicity. The rc file is located,

```
~/.local/share/enroot/np-openblas/etc/rc
```

```
mkdir -p "/" 2> /dev/null
cd "/" && unset OLDPWD || exit 1

if [ -s /etc/rc.local ]; then
    . /etc/rc.local
fi

if [ $# -gt 0 ]; then
    exec  "$@"
else
    exec  'bash'
fi
```

The ' exec "$@" ' line would read the command line when you start the container and run whatever you have there in the container. Otherwise it passes to starting a base shell in the container. We'll change it so that it runs the benchmark if we don't give it any other commands.


```
...
else
    exec  'np-norm-openblas.py'
```

Now running the container executes the benchmark and exits.
```
enroot start np-openblas
```
```
running numpy norm test
norm: 24999969.01        Run time: 3.11192 seconds       GFLOPS: 643
running numpy norm test
norm: 25002053.70        Run time: 3.08933 seconds       GFLOPS: 647
running numpy norm test
norm: 25000211.45        Run time: 3.05952 seconds       GFLOPS: 654
```

 You can pass an environment variable to the container when it starts so the benchmark. For example lets specify the number of threads so it doesn't get slowed down by using hyperthreads. (This is a Xeon W 2295 18 core CPU)

```
enroot start --env OMP_NUM_THREADS=18  np-openblas
```
```
running numpy norm test
norm: 25001325.49        Run time: 1.94516 seconds       GFLOPS: 1028
running numpy norm test
norm: 25004158.39        Run time: 1.95138 seconds       GFLOPS: 1025
running numpy norm test
norm: 25001399.35        Run time: 1.93977 seconds       GFLOPS: 1031
```

## Now, finally,  "export" the altered container image and create an Enroot "bundle"

```
enroot export -o np-norm-openblas.sqsh  np-openblas

[INFO] Creating squashfs filesystem...
```

That will create the the modified container.

Create the bundle,

```
enroot bundle np-norm-openblas.sqsh
```
``` 
[INFO] Extracting squashfs filesystem...

Parallel unsquashfs: Using 36 processors
24363 inodes (19651 blocks) to write

[==================================================================================================================================-] 19651/19651 100%

created 13702 files
created 2483 directories
created 2589 symlinks
created 0 devices
created 0 fifos

[INFO] Generating bundle...

Header is 644 lines long

About to compress 627276 KB of data...
Adding files to archive named "/home/kinghorn/containers/np-norm-openblas.run"...
skipping crc at user request
Skipping md5sum at user request

Self-extractable archive "/home/kinghorn/containers/np-norm-openblas.run" successfully created.
```

We now have the bundle ".run" file (you can name it anything you want, I used the default).

Here is the size of our runnable bundle file,
```
du -sh np-norm-openblas.run 
594M    np-norm-openblas.run
```

**That file has everything needed to run the container we created without installing anything else on the system we run it on!**

## Try it on a system without enroot installed

This is a AMD Ryzen 5800x 8 core system with a minimal Ubuntu 20.04 server install.

```
kinghorn@amd:~$ ./np-norm-openblas.run 
Extracting [####################] 100%
running numpy norm test
norm: 25000646.68        Run time: 4.41505 seconds       GFLOPS: 453
running numpy norm test
norm: 24999666.45        Run time: 4.43121 seconds       GFLOPS: 451
running numpy norm test
norm: 24997198.27        Run time: 4.43797 seconds       GFLOPS: 451
kinghorn@amd:~$ ./np-norm-openblas.run --env OMP_NUM_THREADS=8
Extracting [####################] 100%
running numpy norm test
norm: 25001991.45        Run time: 4.74803 seconds       GFLOPS: 421
running numpy norm test
norm: 24999995.20        Run time: 4.41286 seconds       GFLOPS: 453
running numpy norm test
norm: 25002003.28        Run time: 4.97854 seconds       GFLOPS: 402
```


## Run it on Windows 10 WSL2

Lets try running the container bundle on a Windows WSL Ubuntu install. I copied the np-norm-openblas.run file to my LG Gram notebook with an Intel i7-1065G7 4-core 1.3GHz CPU running Windows 10 with WSL2. 

Works fine! Gave 119 GFLOPS on my wonderful but, not high-performance, laptop!

## What about GPU acceleration?

The example above is CPU only. However, Enroot has NVIDIA GPU support by default. The only addition requirement for say, a TensorFlow or PyTorch bundle would be have the NVIDIA driver installed and libnvidia-container installed.

## Conclusion

Hopefully this post has given you ideas of your own for how you could make use of Enroot Bundles. I also hope that it has provided an overview of using Enroot in general. I find its simplicity, flexibility, ease of use and utility very helpful in my daily work. I now mostly use Enroot Container sandboxes for programing and application environments. It provides the advantages of containers within the scope of a user workflow without getting too much in the way. Enroot is also very well suited for providing container workspaces in a many user environment with a resource manager like SLURM or with a JupyterHub deployment.  
