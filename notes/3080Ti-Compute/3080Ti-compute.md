# NVIDIA 3080Ti vs 3090 Compute Performance 

## Introduction

The NVIDIA RTX3080Ti is out and will hopefully be available to ease the difficulty that people are having finding high-end GPUs for their work (or play). I think the intention for the 3080Ti is to provide a GPU with performance near the RTX3090 but with the 12GB memory size being more appropriate for gaming use.

 For computing tasks like Machine Learning and some Scientific computing the RTX3080TI is an alternative to the RTX3090 when the 12GB of GDDR6X is sufficient. (Compared to the 24GB available of the RTX3090). 12GB is in line with former NVIDIA GPUs that were "work horses" for ML/AI like the Titan series and the wonderful 2080Ti. 

 >There is definitely a use case for the RTX3080Ti for computing. However, given the "relatively small" price difference and advantages of the RTX3090's larger memory size. I would say "leave the RTX3080Tis for the gamers!" ... but, these days you may have to go with whatever is available!       

In this post I present a few HPC and ML benchmarks with the 3080Ti mostly comparing against the 3090. This is not a comprehensive evaluation of the 3080Ti but should give you and idea of performance for numerical computing tasks.


## The benchmarks ResNet50, HPC, HPC-AI, HPCG

I decided to run the 

- [**HPL:** The HPL Linpack benchmark](https://www.netlib.org/benchmark/hpl/) is used to rank the [Top500 supercomputers](https://www.top500.org/) and is an optimized measure of double precision floating point performance from matrix operations. The benchmark finds a solution to large dense sets of linear equations.

- [**HPL-AI:** Mixed Precision Benchmark](https://icl.bitbucket.io/hpl-ai/) Is the same HPL benchmark but using lower/mixed precision that would more typically be used for training ML/AI models. On the A100 this utilizes TF32, 32-bit Tensor-Cores. This benchmark is now also part of the Top500 supercomputer rankings.

- [**HPCG:** High Performance Conjugate Gradients](https://www.hpcg-benchmark.org/), this is another benchmark used for ranking on the Top500 list. It is a multigrid preconditioned conjugate gradient algorithm, with sparse matrix-vector multiplication with global IO patterns. It is a workload typical of many problems involving numerical solutions of sets of differential equations. This is very much memory/IO-bound!

These 3 benchmarks provide a good measure of the numerical computing performance of a computer system. These are the benchmarks used to rank the largest supercomputer clusters in the world. Of course I'm running them on a single server or workstation. Still, having "grown up" with supercomputers I'm always impressed by the performance from a single node modern system. The 4 x A100 system I've tested provides more computing performance than the first multi million-dollar, Top500 supercomputer deployment I was involved with!

**Keep in mind these are "Benchmarks"!** I made an effort to find (large) problem sizes and good parameters that would showcase the hardware. Measured GPU performance is particularly sensitive to problems size (larger is generally better). For the GPU benchmarks I have used NVIDIA's optimized ["NVIDIA HPC-Benchmarks 21.4" container from NGC](https://ngc.nvidia.com/catalog/containers/nvidia:hpc-benchmarks). That is their Supercomputer benchmark set!  


## Test Systems

**NVIDIA RTX3080Ti system**
-  **CPU** - 2 x Intel Xeon 6258R 28-core
- **Motherboard** - ASUS WS-C621E-SAGE
- **Memory** - 12 x 32GB Reg ECC DDR4 (384GB total)
- **GPU** - 1 NVIDIA RTX3080Ti 12GB 320W

**NVIDIA RTX3090 system**
-  **CPU** - 2 x Intel Xeon 6258R 28-core
- **Motherboard** - ASUS WS-C621E-SAGE
- **Memory** - 12 x 32GB Reg ECC DDR4 (384GB total)
- **GPU** - 1 NVIDIA RTX3090 24GB 350W

**NVIDIA A100 system**
-  **CPU** - 2 x Intel Xeon Platinum 8180 28-core
- **Motherboard** - Tyan Thunder HX GA88-B5631 Rack Server
- **Memory** - 12 x 32GB Reg ECC DDR4 (384GB total)
- **GPU** - 1-4 NVIDIA A100 PCIe 40GB 250W

**NVIDIA Titan-V system**
- **CPU** - Intel Xeon W-2295 18 Core
- **Motherboard** - Asus WS C422 PRO_SE
- **Memory** - Kingston 128GB DDR4-2400 (128GB total) [My personal system]
- **GPU** - 1-2 NVIDIA Titan-V PCIe 12GB

The other machines are from older CPU HPC benchmark posts (HPL and HPCG). See, for example the, recent [Intel Rocket Lake post](https://www.pugetsystems.com/labs/hpc/Intel-Rocket-Lake-Compute-Performance-Results-HPL-HPCG-NAMD-and-Numpy-2116/) or [AMD Threadripper Pro post](https://www.pugetsystems.com/labs/hpc/AMD-Threadripper-Pro-3995x-HPL-HPCG-NAMD-Performance-Testing-Preliminary-2085/) for references.

**Software**
- Ubuntu 20.04
- NVIDIA driver 460
- [NVIDIA HPC-Benchmarks 21.4](https://ngc.nvidia.com/catalog/containers/nvidia:hpc-benchmarks) (NGC containers)
- 
- [NVIDIA Enroot 3.3](https://github.com/NVIDIA/enroot) (for running containers )

## Results

Here's the good stuff!

3080Ti
```
Convergence history: Classical Iterative Refinement
Iteration      Residual
        0     6.868E-06
        1     1.000E-10
        2     1.528E-14


info===> HPL_Classic_IR_niter 2 timer total   1.318/  1.318= redit   0.000 + Classic_IR   1.318/  1.318 :    MV   0.943    Pcond   0.375    dot   0.000 

================================================================================================================================================================
         T/V                N    NB     P     Q               Time                 Gflops          FGMRES          Gflops_IRS
--------------------------------------------------------------------------------------------------------------------------------------------------------------
HPL_AI   WR03L2L2       44000   288     1     1               3.74              1.517e+04         1.32214           1.121e+04
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=       2.774020E-03 ...... PASSED

```

3090
```
Convergence history: Classical Iterative Refinement
Iteration      Residual
        0     6.868E-06
        1     1.000E-10
        2     1.528E-14


info===> HPL_Classic_IR_niter 2 timer total   1.320/  1.319= redit   0.000 + Classic_IR   1.320/  1.319 :    MV   0.944    Pcond   0.375    dot   0.000 

================================================================================================================================================================
         T/V                N    NB     P     Q               Time                 Gflops          FGMRES          Gflops_IRS
--------------------------------------------------------------------------------------------------------------------------------------------------------------
HPL_AI   WR03L2L2       44000   288     1     1               3.82              1.488e+04         1.32339           1.105e+04
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=       2.774020E-03 ...... PASSED

```

3090Fail
```
Convergence history: Classical Iterative Refinement
Iteration      Residual
        0           NAN
        1           NAN
        2           NAN
        3           NAN
        4           NAN
        5           NAN
        6           NAN
        7           NAN
        8           NAN
        9           NAN
       10           NAN


info===> HPL_Classic_IR_niter 10 timer total  10.976/ 10.976= redit   0.000 + Classic_IR  10.976/ 10.976 :    MV   7.258    Pcond   3.717    dot   0.001 

================================================================================================================================================================
         T/V                N    NB     P     Q               Time                 Gflops          FGMRES          Gflops_IRS
--------------------------------------------------------------------------------------------------------------------------------------------------------------
HPL_AI   WR03L2L2       64000   288     1     1               8.32              2.100e+04        10.98160           9.054e+03
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=                NAN ...... FAILED

```
