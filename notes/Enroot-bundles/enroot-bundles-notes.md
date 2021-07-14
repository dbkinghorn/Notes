 7335  enroot export np-miniforge
 7336  ls -sh
 7337  enroot bundle np-miniforge.sqsh 
 7338  ls
 7339  ls -sh
 7340  ./np-miniforge.run 
 7341  OMP_NUM_THREADS=18 ./np-miniforge.run 
 7342  enroot create --name np-intel ubuntu.sqsh 
 7343  cd ../Downloads/
 7344  ls
 7345  rsync -av Miniforge3-Linux-x86_64.sh /home/kinghorn/.local/share/enroot/np-intel/opt/
 7346  cd ../containers/
 7347  enroot start --root --rw np-intel
 7348  set-enroot-prompt np-intel
 7349  enroot start --root --rw np-intel
 7350  ls
 7351  enroot start np-intel
 7352  ls
 7353  enroot export np-intel 
 7354  enroot bundle np-intel.sqsh 
 7355  ls -sh
 7356  ./np-intel.run 
 7357  ./np-intel.run /bin/bash


## Example numpy openBLAS benchmark bundle

We'll use an Ubuntu 20.04 container imported from DockerHub as a base.


```
enroot import docker://ubuntu
```
That pulls th container image and creates a squash FS file to create a container "sandbox" from.

We will create a container instance (sandbox) from that container image and name it np-openblas

```
enroot create --name np-openblas ubuntu.sqsh
```

```
kinghorn@i9:~/containers$ du -sh ubuntu.sqsh 
51M     ubuntu.sqsh
kinghorn@i9:~/containers$ du -sh ~/.local/share/enroot/np-openblas
78M     /home/kinghorn/.local/share/enroot/np-openblas
```

Now start the container with --root and --rw so we can install wget and then miniforge 

First make sure you are not mounting your home directory since we are starting as root in the container, otherwise your user home directory will get mounted on /root  [This is only needed if you have changed the enroot default settings and have your $HOME mounted by default]

```
export ENROOT_MOUNT_HOME=n
```

```
enroot start --root --rw np-openblas
```

We will need curl or wget to download the miniforge installer (you could download it locally and then just copy it into the container image instead which is what I would normally do but I wanted to illustrate doing and apt install in the container for this post)

```
apt-get update

kinghorn@i9:~/.local/share/enroot$ du -sh np-openblas
106M	np-openblas

apt-get install wget --no-install-recommend

kinghorn@i9:~/.local/share/enroot$ du -sh np-openblas
111M	np-openblas

rm -rf /var/lib/apt/lists/*

kinghorn@i9:~/.local/share/enroot$ du -sh np-openblas
83M	np-openblas

cd /opt
wget --no-check-certificate  https://github.com/conda-forge/miniforge/releases/download/4.10.2-0/Miniforge3-4.10.2-0-Linux-x86_64.sh

sh Miniforge3-4.10.2-0-Linux-x86_64.sh 

[/root/miniforge3] >>> /opt/miniforge3

rm Miniforge3-4.10.2-0-Linux-x86_64.sh

kinghorn@i9:~/.local/share/enroot$ du -sh np-openblas
429M	np-openblas

./miniforge3/bin/conda install numpy 

kinghorn@i9:~/.local/share/enroot$ du -sh np-openblas
612M	np-openblas


```

It is probably possible to shrink the size of the container bundle but it may or may not be worth the effort depending on your use case.

Note that doing this with the a Numpy linked to Intel MKL will result in a container approx. 3 times larger!

Next step in the example is to add a bit of code that will run when the container starts.

```
#!/usr/bin/env python3

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

This is a fragment of a numpy benchmark code I'm working on.

Copy this to /usr/local/bin   so it is on the default path.

I'll just copy it into the container file system directly from the host.

```
kinghorn@i9:~/projects/Notes/notes/Enroot-bundles$ rsync -av np-norm-openblas.py /home/kinghorn/.local/share/enroot/np-openblas/usr/local/bin/
sending incremental file list
np-norm-openblas.py

sent 1,039 bytes  received 35 bytes  2,148.00 bytes/sec
total size is 914  speedup is 0.85
kinghorn@i9:~/projects/Notes/notes/Enroot-bundles$ cd 
kinghorn@i9:~$ cd .local/share/enroot/np-openblas/usr/local/bin/
kinghorn@i9:~/.local/share/enroot/np-openblas/usr/local/bin$ ls
np-norm-openblas.py
kinghorn@i9:~/.local/share/enroot/np-openblas/usr/local/bin$ chmod 755 np-norm-openblas.py
```

set the python that we want to use to run the benchmark

```
#!/opt/miniforge3/bin/python3 
```

```
kinghorn@i9:~/.local/share/enroot/np-openblas/usr/local/bin$ enroot start np-openblas
(np-openblas)kinghorn@i9:/$ np-norm-openblas.py
running numpy norm test
norm: 25003427.73        Run time: 3.06277 seconds       GFLOPS: 653
running numpy norm test
norm: 25002406.43        Run time: 3.04929 seconds       GFLOPS: 656
running numpy norm test
norm: 24998160.53        Run time: 3.08600 seconds       GFLOPS: 648
```

It runs. Now edit the /etc/rc file so to run that code when the container starts.

From
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

 To
```
...
else
    exec  'np-norm-openblas.py'
```

```
kinghorn@i9:~/.local/share/enroot/np-openblas/etc$ enroot start np-openblas
running numpy norm test
norm: 24999969.01        Run time: 3.11192 seconds       GFLOPS: 643
running numpy norm test
norm: 25002053.70        Run time: 3.08933 seconds       GFLOPS: 647
running numpy norm test
norm: 25000211.45        Run time: 3.05952 seconds       GFLOPS: 654
```

 Pass and environment variable to the container when it starts so the benchmark doesn't get slowed down by using hyperthreads.

```
kinghorn@i9:~/.local/share/enroot/np-openblas/etc$ enroot start --env OMP_NUM_THREADS=18  np-openblas
running numpy norm test
norm: 25001325.49        Run time: 1.94516 seconds       GFLOPS: 1028
running numpy norm test
norm: 25004158.39        Run time: 1.95138 seconds       GFLOPS: 1025
running numpy norm test
norm: 25001399.35        Run time: 1.93977 seconds       GFLOPS: 1031
```

## Now create export the altered container image and create a bundle

```
kinghorn@i9:~/containers$ enroot export -o np-norm-openblas.sqsh  np-openblas 
[INFO] Creating squashfs filesystem...

```

```
kinghorn@i9:~/containers$ enroot bundle np-norm-openblas.sqsh 
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
kinghorn@i9:~/containers$ ls
bundles           np-intel.run      np-miniforge.sqsh      nvidia+hpc-benchmarks+20.10-hpcg.sqsh  nvidia+tensorflow+21.05-tf1-py3.sqsh  ubuntu.sqsh
np-anaconda.run   np-intel.sqsh     np-norm-openblas.run   nvidia+hpc-benchmarks+20.10-hpl.sqsh   tf1.15-resnet50.run
np-anaconda.sqsh  np-miniforge.run  np-norm-openblas.sqsh  nvidia+tensorflow+21.05-tf1-py3.run    tf1.15-resnet50.sqsh
```

```
kinghorn@i9:~/containers$ ./np-norm-openblas.run --env OMP_NUM_THREADS=18
Extracting [####################] 100%
running numpy norm test
norm: 24998510.71        Run time: 2.16960 seconds       GFLOPS: 922
running numpy norm test
norm: 25001283.32        Run time: 2.07059 seconds       GFLOPS: 966
running numpy norm test
norm: 25002515.97        Run time: 2.09371 seconds       GFLOPS: 955
```

```
kinghorn@i9:~/containers$ du -sh np-norm-openblas.run 
594M    np-norm-openblas.run
```

Verify option
```
kinghorn@i9:~/containers$ ./np-norm-openblas.run --verify
Kernel version:

Linux version 5.11.0-22-generic (buildd@lgw01-amd64-033) (gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #23~20.04.1-Ubuntu SMP Thu Jun 17 12:51:00 UTC 2021

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

## Try it on a system without enroot installed

This is a AMD Ryzen 5800x 8 core system 

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

Lets try running the container bundle on a Windows WSL Ubuntu install.

works fine!  Gave 119 GFLOPS on my LG Gram notebook with an Intel i7-1065G7 4-core 1.3GHz CPU

