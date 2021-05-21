# NVIDIA A100 PCIe HPL HPL-AI HPCG

## Introduction

The NVIDIA A100 GPU is an extraordinary computing device. It's not just for ML/AI types of workloads. General scientific computing use for many tasks requiring high performance numerical linear algebra run exceptionally well on the A100. The NVIDIA RTX 30xx and "Quadro" x000 GPUs are also good for some numerical computing tasks as long as they don't require double precision i.e. FP64 floating point for accuracy. The A100 provides very good double precision FP64 and lower precision performance and also includes 32-bit Tensor-cores, TF32, which when used with mixed precision can gave a large performance boost and still provide good accuracy. The memory performance of the A100 is also a big plus for memory-bound applications, and the A100 comes with 40 or 80 GB of memory!

>In this post I will present results of running "standard" HPC benchmarks on the A100 with comparison to CPUs and a few other GPUs.    

The benchmarks presented are,

- [**HPL:** The HPL Linpack benchmark](https://www.netlib.org/benchmark/hpl/) is used to rank the [Top500 supercomputers](https://www.top500.org/) and is an optimized measure of double precision floating point performance from matrix operations. The benchmark finds a solution to a set of linear equations.

- [**HPL-AI:** Mixed Precision Benchmark](https://icl.bitbucket.io/hpl-ai/) Is the same HPL benchmark but using lower/mixed precision that would typically be used for training ML/AI models. One the A100 this utilizes TF32, 32-bit Tensor-Cores. This benchmark is now also part of the Top500 supercomputer rankings.

- **HPCG:** High Performance Conjugate Gradients, this is another benchmark used for ranking on the Top500 list. It is a multi-grid solver using CG and is a workload of many problems involving solutions of sets of differential equations. This is very much memory/IO-bound.


## Test Systems

**NVIDIA A100 system**
-  **CPU** - 2 x Intel Xeon Platinum 8180 28-core
- **Motherboard** - Tyan Thunder HX GA88-B5631 Rack Server
- **Memory** - 12 x 32GB Reg ECC DDR4 (384BG total)
- **GPU** - 1-4 NVIDIA A100 PCIe 40GB

**NVIDIA Titan-V system**
- **CPU** - Intel Xeon W-2295 18 Core
- **Motherboard** - Asus WS C422 PRO_SE
- **Memory** - Kingston 128GB DDR4-2400 (8x16GB) [My personal system]
- **GPU** - 1-2 NVIDIA Titan-V PCIe 12GB

The other machines are from older CPU only HPC benchmarks. See, for example the, recent [Intel Rocket Lake post]() or [AMD Threadripper Pro post](https://www.pugetsystems.com/labs/hpc/AMD-Threadripper-Pro-3995x-HPL-HPCG-NAMD-Performance-Testing-Preliminary-2085/) for reference.

**Software**
- Ubuntu 20.04
- NVIDIA driver 460
- [NVIDIA HPC-Benchmarks 21.4](https://ngc.nvidia.com/catalog/containers/nvidia:hpc-benchmarks) (NGC container)
- [NVIDIA Enroot 3.3](https://github.com/NVIDIA/enroot) (for running containers )



## NGC HPC Benchmark container setup with enroot


```
kinghorn@i9:~/containers$ enroot import 'docker://$oauthtoken@nvcr.io#nvidia/hpc-benchmarks:20.10-hpl'
[INFO] Querying registry for permission grant
[INFO] Authenticating with user: $oauthtoken
Enter host password for user '$oauthtoken':
[INFO] Authentication succeeded
[INFO] Fetching image manifest list
[INFO] Fetching image manifest
[INFO] Downloading 9 missing layers...


kinghorn@i9:~/containers$ enroot import 'docker://$oauthtoken@nvcr.io#nvidia/hpc-benchmarks:20.10-hpcg'
[INFO] Querying registry for permission grant
[INFO] Authenticating with user: $oauthtoken
Enter host password for user '$oauthtoken':
[INFO] Authentication succeeded
[INFO] Fetching image manifest list
[INFO] Fetching image manifest
[INFO] Downloading 32 missing layers...


kinghorn@i9:~/containers$ enroot create --name nv-hpl-bench nvidia+hpc-benchmarks+20.10-hpl.sqsh 

enroot create --name nv-hpcg-bench nvidia+hpc-benchmarks+20.10-hpcg.sqsh



mkdir -p /home/kinghorn/.local/share/enroot/nv-hpc-bench/sys/class/infiniband


export MELLANOX_VISIBLE_DEVICES="none"

enroot start nv-hpl-bench

# this is on my 2 TitanV sys

(nv-hpl-bench)kinghorn@i9:~/projects/A100-testing/nv-hpc-bench/workspace/hpl-linux-x86_64$ mpirun --mca btl smcuda,self  -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc  -np 2 hpl.sh  --dat ./HPL.dat --cpu-affinity 0:0 --cpu-cores-per-rank 4 --gpu-affinity 0:1


(nv-hpl-bench)kinghorn@i9:~/projects/A100-testing/nv-hpc-bench/workspace/hpl-linux-x86_64$ mpirun --mca btl smcuda,self -x MELLANOX_VISIBLE_DEVICES="none" -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc  -np 2 hpl.sh --xhpl-ai --dat ./HPL.dat --cpu-affinity 0:0 --cpu-cores-per-rank 4 --gpu-affinity 0:1


(nv-hpc-bench)kinghorn@i9:~/projects/A100-testing/nv-hpc-bench/workspace/hpcg-linux-x86_64$ mpirun --mca btl smcuda,self  -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc  -np 2 hpcg.sh --dat ./hpcg.dat --cpu-affinity 0:0 --cpu-cores-per-rank 4 --gpu-affinity 0:1 | tee hpcg-titanVx2-256-180.out 

```
