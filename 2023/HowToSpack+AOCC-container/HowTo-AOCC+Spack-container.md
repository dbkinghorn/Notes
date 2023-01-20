# How To Create A Docker Container For AMD AOCCv4 Compiler Plus Spack Build Tools

AMD has recently released version 4.0 of their AOCC compiler which includes support for AVX512 on the Zen4 architecture. I was very impressed with Ryzen 7950x performance on applications built using the previous AOCCv3.2 (Zen3) compilers. We have been anticipating the release of AOCCv4 to see if this performance can be further improved with targeted Zen4 optimizations, including, the now supported AVX512 capability. Of course, I am also eager to do testing on the new EPYC Genoa Zen4 CPUs! This post describes the preparatory setup for a containerized application build system using these new compilers.   

I have been doing scientific application builds and benchmarks using the [Spack package manager/build system](https://spack.readthedocs.io/en/latest/). Spack is a sophisticated tool for managing complex application builds and installations that provides direct access to build optimizations and install conflict isolation. I will be writing about how this is used in future posts.

Containerization is proving to be the best way to handle complex application installation. It provides dependency isolation, reproducibility, ease of deployment and distribution. Spack has features to assist with doing optimized application builds in containers using **multi-stage Dockerfile's**. In order to use AMD AOCCv4 compilers in a Spack build container we will modify a base container to include AOCCv4 and add it to the Spack compiler list. **This container will provide the build stage for Zen4 optimized application containers.**

The AMD AOCC compiler package is behind a "License Wall" and is not re-distributable. This means that I cannot give you direct access to my container on Docker Hub. Instead **This post will give you instructions on how to build the container** yourself. 

Further posts in this series will appear on the [Puget Systems HPC-blog](https://www.pugetsystems.com/all-hpc/)

## Step 0) Prerequisites 

You should be able to do this container build on any Linux system with a recent docker install. I am using.

- Ubuntu 22.04.1 LTS server base install with added build-essentials
- Docker version 20.10.22

**References:**
- **Docker Docs** [https://docs.docker.com](https://docs.docker.com)
- **Spack Docs** [https://spack.readthedocs.io/en/latest/](https://spack.readthedocs.io/en/latest/)

**Project resources:**
- **Puget Systems - Docker Hub** [https://hub.docker.com/orgs/pugetsystems/repositories](https://hub.docker.com/orgs/pugetsystems/repositories)
- **GitHub - Benchmark Containers** [https://github.com/dbkinghorn/Benchmark-Containers](https://github.com/dbkinghorn/Benchmark-Containers)

Note: The "build-image" container listed in our Docker Hub repo is *not* related to my projects.
The container images and GitHub repo are in the process of being refreshed for the new AOCCv4 compilers. Posts describing each individual container build will be published. The project will eventually include optimized application containers **and benchmarks** for hardware based on AMD, Intel and NVIDIA. 

## Step 1) Get AOCCv4

Create a directory for the container build and download the AMD AOCC compiler package.
```
mkdir spack-aoccv4
cd spack-aoccv4
```
The AMD compilers and tools are behind a "License-Wall". I was not able to come up with a command-line download command.
Use a web browser to download aocc-compiler-4.0.0_1_amd64.deb AOCCv4 from [https://developer.amd.com/amd-aocc/](https://developer.amd.com/amd-aocc/) Accept the License and save to the spack-aoccv4/ directory created above.

You could also download the AOCLv4 Optimized Libraries aocl-linux-aocc-4.0_1_amd64.deb that includes AOCL-BLIS (BLAS), AOCL-libFLAME (LAPACK), AOCL-FFTW and other libs. [https://developer.amd.com/amd-aocl/](https://developer.amd.com/amd-aocl/)  **This is not necessary when using Spack** since it is able to pull these AOCL libs as dependencies without having a local install. I will not include it in the container build. However, you could modify the Dockerfile below to include it in the same way as the AOCCv4 compilers if you want to build a more complete build tools image to use without Spack.

## Step 2) Create Dockerfile

Create the following Dockerfile in the spack-aoccv4 directory,

```
# Spack Build image with AMD aocc compilers installed and ready for use with spack
FROM docker.io/spack/ubuntu-jammy:v0.19.0 

WORKDIR /root
# You need to have a downloaded copy of aocc
COPY ./aocc-compiler-4.0.0_1_amd64.deb .
RUN apt update && \
    apt install -y ./aocc-compiler-4.0.0_1_amd64.deb && \
    apt install -y vim && \
    rm -rf /var/lib/apt/lists/* && \
    rm ./aocc-compiler-4.0.0_1_amd64.deb

# Add the aocc compiler to spack
RUN . /opt/spack/share/spack/setup-env.sh && \
    . /opt/AMD/aocc-compiler-4.0.0/setenv_AOCC.sh && \
    spack compiler find && \
    echo ". /opt/AMD/aocc-compiler-4.0.0/setenv_AOCC.sh" >> /etc/profile.d/AOCC-setup.sh && \
    echo ". /opt/spack/share/spack/setup-env.sh" >> /etc/profile.d/SPACK-setup.sh

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/profile", "-l", "-c", "$*", "--" ]
CMD [ "/bin/bash" ]

```
Note: I had originally used the base Spack image tagged ubuntu/jammy:latest. It turned out that "latest" was the 0.20.0.dev0 branch that had been push just a couple of hours before I did this build. (it is being actively developed!) I edited the Dockerfile to us the stable-versioned tag ubuntu-jammy:v0.19.0. I suggest you use this stable release. 


## Step 3) Build the container

```
docker build -t spack-aoccv4.0.0:v0.1 .
```
Of course, you can use a different name and tag if you like.

## Step 4) Check the build

The Spack+AOCCv4 build container is large!

```
docker images

REPOSITORY           TAG       IMAGE ID       CREATED          SIZE
spack-aoccv4.0.0     v0.1      b452fc959229   22 seconds ago   1.82GB
spack/ubuntu-jammy   v0.19.0   47a9eea5c069   7 weeks ago      840MB

```
**You can see that AOCCv4 adds approx. 1TB to the 854MB Spack base image. This is part of why we are doing this! This will be the build stage in our multi-Stage Dockerfiles. Most of that Spack+AOCCv4 build environment will be excluded in the finial application containers and they will be reasonably sized.**

Check versions and make sure that Spack can use the AOCC compiler.

```
docker run -it --rm spack-aoccv4.0.0:v0.1

root@d5a8d9a2f03d:~# spack --version
0.19.0

root@d5a8d9a2f03d:~# spack compilers
==> Available compilers
-- aocc ubuntu22.04-x86_64 --------------------------------------
aocc@4.0.0

-- gcc ubuntu22.04-x86_64 ---------------------------------------
gcc@11.3.0

```

Check the AOCC compiler install
```
root@d5a8d9a2f03d:~# /opt/AMD/aocc-compiler-4.0.0/AOCC-prerequisites-check.sh 

Check:PASSED
Passing Checks:
	1) AOCC clang compiler bin => /opt/AMD/aocc-compiler-4.0.0/bin
	2) AOCC clang++ compiler bin => /opt/AMD/aocc-compiler-4.0.0/bin
	3) AOCC flang compiler bin => /opt/AMD/aocc-compiler-4.0.0/bin
	4) Glibc version => 2.35-0ubuntu3.1
	5) libstdc++ => libstdc++.so.6 (libc6,x86-64) => /lib/x86_64-linux-gnu/libstdc++.so.6
	6) libxml2 => libxml2.so.2 (libc6,x86-64) => /lib/x86_64-linux-gnu/libxml2.so.2
	7) libquadmath => libquadmath.so.0 (libc6,x86-64) => /lib/x86_64-linux-gnu/libquadmath.so.0
	8) AMD LibM (libalm) => /opt/AMD/aocc-compiler-4.0.0/lib
	9) AMD's memory allocation lib (libamdalloc) => /opt/AMD/aocc-compiler-4.0.0/lib
	10) libz.so => libz.so.1 (libc6,x86-64) => /lib/x86_64-linux-gnu/libz.so.1
	11) OpenMP library => /opt/AMD/aocc-compiler-4.0.0/lib/libomp.so
	12) Check for crt files crt1.o, crti.o and crtn.o passed
	13) Check for libc passed
	14) Check for libm passed
	15) Python 3.5 or above is present
	16) In PATH opt-viewer is present

```

```
root@d5a8d9a2f03d:~# clang --version
AMD clang version 14.0.6 (CLANG: AOCC_4.0.0-Build#434 2022_10_28) (based on LLVM Mirror.Version.14.0.6)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /opt/AMD/aocc-compiler-4.0.0/bin

```

**We are good to go!**  

## Step 5) Tag and push to Docker Hub (Optional)

I have to push this to my personal Docker Hub account to a **PRIVATE repo**. I will try to see if AMD will allow this on [our PUBLIC repo](https://hub.docker.com/orgs/pugetsystems/repositories). You could skip pushing to Docker Hub if you cannot create a private repo. Then just maintain this container on your local system to use with the multi-Stage builds that will be described in future posts.  

```
# Login to your Docker Hub account and create a new PRIVATE repo (i.e. spack-aoccv4)
docker login

# Create a new name and tag using your new repo path and chosen tag
docker tag spack-aoccv4.0.0:v0.1 dbkinghorn/spack-aoccv4:latest

# Push to Docker Hub
docker push dbkinghorn/spack-aoccv4:latest
```

## Conclusion 

This post details building a Docker image containing the Spack package manager/build system together with AMD AOCCv4.0.0 compilers. This will be used as the build image for multi-stage Dockerfiles that will be used to compile scientific applications and benchmarks with targeted Zen3/4 optimizations. It is the first step in that process. 

The application containers created with this image will be pushed to [the Puget Systems public Docker Hub repo](https://hub.docker.com/orgs/pugetsystems/repositories). (At least all of them that allow redistribution.) Expect to see several posts over the next few weeks discussing these applications and benchmarks.

**There are already 9 applications publicly available at the [Puget Systems Docker Hub repo](https://hub.docker.com/orgs/pugetsystems/repositories) These images are --at this moment-- optimized with AOCCv3.2 targeted Zen3. They will soon be recompiled and optimized to Zen4 using the build container described in this post.**

- NWChem
- GROMACS
- OpenFOAM
- WRF
- LAMMPS
- HMMER
- HPL
- HPCG
- Quantum Espresso
- NAMD  (this is still private until I get permission to make it public)

**Also, expect to soon see a benchmark post looking at AVX512 performance on the surprisingly good AMD Ryzen 7950x!**

Further posts in this series will appear on the [Puget Systems HPC-blog](https://www.pugetsystems.com/all-hpc/)

**Happy Computing! --dbk @dbkinghorn**