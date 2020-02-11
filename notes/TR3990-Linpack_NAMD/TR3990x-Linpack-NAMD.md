# AMD 3990x 64-core Linpack and NAMD Performance (Linux)

## Introduction

64 cores! The latest AMD Threadripper is out, the 3990x 64-core. I've spent the last couple of days running benchmarks and have some results showing raw numerical compute performance using my standard CPU testing applications HPL Linpack and the molecular dynamics program NAMD. The 3990x is a great processor, however, there were difficulties and some disappointments during the testing. 

It is nice having AMD making exceptionally great processors again. This 64-core Threadripper 3990x is the pinnacle of the "consumer" Zen2 core processors. (EPYC Rome is the server line based on Zen2 core) 

**THESE RESULTS ARE PRELIMINARY** 

## Difficulties 

I'll start with some of the problems I encountered during the testing that prompted me to remark that these "results are preliminary". This should temper the results that follow. There is room for improvement! 

**Install issues**

- Ubuntu with any kernel newer than 5.0.0 would hang during install (on the hardware I was using).
  - Ubuntu 18.04 with HWE kernel would boot but would hang after update
  - Ubuntu 19.10 would hang during install
  - I had to drop back to Ubuntu 18.04 with 4.15 kernel for a stable install. That is too old to be fully "Zen2 aware".

I expect this to be a better platform using the finial release of Ubuntu 20.04 in April. 

**HPL Linpack anomalies**

- HPL Linpack did not achieve expected performance based on comparison with 32-core 3970x
  - Performance was better with 3990x than 3970x but I could drop 16 cores from the 3990x with only minimally lower performance.  

I did experiments with openMP threads and hybrid parallelism with openMP threads and MPI ranks. Results are approximately 25% lower than expected. 

NAMD performance was very good but I can't help but think results could be better based on what I saw with Linpack. 


## System Configuration

- AMD Threadripper 3990x
- Motherboard Gigabyte TRX40 AORUS 
- Memory 8x DDR4-2933 16GB (128GB total)
- 1TB Samsung 960 EVO M.2
- 2 x NVIDIA RTX Titan GPU's
- 
- Ubuntu 18.04
- Kernel 4.15
- [AMD BLIS library v 2.0](https://developer.amd.com/amd-aocl/blas-library/) 
- [HPL Linpack 2.2](Using pre-compiled binary at link above)
- [OpenMPI 3.1.3](installed from source)
- [NAMD 2.13 (Molecular Dynamics)](http://www.ks.uiuc.edu/Research/namd/)

**Notes:**
- The Ryzen 3900x and 3950x worked well on Ubuntu 19.10. Both the Threadripper 3970x and 3990x required dropping back to 18.04.
- **New results in this post are for Threadripper 3990x only.** The other results are from previous testing.

## Linpack

**Notes:**
-  I'm using the same HPL binary that was used for testing the 3970x i.e. the pre-built muit-threaded HPL binary provided by AMD. This is the "MT" build but it still looks for MPI header files on start-up and uses the HPL.dat file for job run configuration. This is why an OpenMPI install is needed to run this benchmark.  

- AMD BLIS (a.k.a. AMD's BLAS library) version 2.0 with specific support for Zen2 was used. 
- Several combinations with MPI ranks together with OMP threads were tried. The best results obtained were using only OMP threads and the pre-built binary without MPI.  **1 OMP thread per "real" core gave the best result. (WITH SMT DISABLED IN THE BIOS)**
 
 - There is a detailed description of HPL Linpack testing for Threadripper 2990WX in the post, [How to Run an Optimized HPL Linpack Benchmark on AMD Ryzen Threadripper -- 2990WX 32-core Performance](https://www.pugetsystems.com/labs/hpc/How-to-Run-an-Optimized-HPL-Linpack-Benchmark-on-AMD-Ryzen-Threadripper----2990WX-32-core-Performance-1291/)  

 - The Intel CPU's were tested with the (highly) optimized Linpack benchmark program included with Intel MKL performance library.

 - A large problem size approx. 90% (104GB) of available memory (128GB) was used in order to maximize performance results, Ns=116000.

```
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4      116000  1024     1     1             662.21             1.5714e+03
HPL_pdgesv() start time Thu Feb  6 10:50:10 2020

HPL_pdgesv() end time   Thu Feb  6 11:01:12 2020

--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   3.80355268e-03 ...... PASSED
================================================================================
```

Here is an excerpt from the HPL.dat file used, [this file automates using 3 problems sizes (Ns) and 3 Block sizes (NBs), also note that P and Q are set to 1 i.e. 1 MPI Rank, parallelism was from OMP threads]
```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
3            # of problems sizes (N)
112000 114000 116000 Ns
5            # of NBs
512 640 768 896 1024  NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
1            Ps
1            Qs
...
```

The following environment variables were set for the Ryzen and Threadripper Linpack runs
```
export OMP_PROC_BIND=TRUE
export OMP_PLACES=cores
export OMP_NUM_THREADS=64 
```

**The AMD Threadripper 3990x results are not as high as expected and can likely be improved**

The following plot shows HPL Linpack results (in GFLOPS).

![TR3970x Linpack](TR32-linpack.png)

The TR3990x results are impressive for a processors with AVX2 (rather than AVX512) but I expect that these results could be better. (see "issues" section) I will repeat this testing after Ubuntu 20.04 is released.

The Intel processors with AVX-512 vector units have an advantage for Linpack. Also,the Linpack used for the Intel processors is built with the BLAS library from Intel's excellent MKL (Math Kernel Library). 

## NAMD

NAMD is one of my favorite programs to use for benchmarking because it has great parallel scaling across cores (and cluster nodes). It does not significantly benefit from linking with the Intel MKL library and it runs on a wide variety of hardware and OS platforms. It's also a very important Molecular Dynamics research program. 

NAMD also has very good GPU acceleration. Adding CUDA capable GPU's will increase throughput significantly. However,with NAMD and other codes like it, only a portion of the heavy compute can be offloaded to GPU. A good CPU is necessary to achieved balanced performance.

This plot shows the performance of a molecular dynamics simulation on the million atom "stmv" ( satellite tobacco mosaic virus ). These job runs are with CPU and with 1 or 2 RTX Titan GPU's added. Performance is in "day/ns" (days to compute a nano second of simulation time) This is the standard output for NAMD. If you prefer ns/day then just take the reciprocal.  

![NAMD TR3970x](TR32-namd-stmv.png)

**The Threadripper 3990x gave excellent performance for NAMD.** Results are exceptionally good for CPU alone and with added GPU's These are the best results I have ever obtained for these job runs. 

This last set of results is using the smaller ApoA1 problem (it's still pretty big with 92000 atoms!) These results are CPU only. (Results with added RTX Titan are 0.031 day/ns and 2 x RTX Titan 0.020 day/ns)

![NAMD Ryzen 3900X](TR32-namd-apoa1.png)

**I expected the TR3990x 64-core CPU together with 2-4 high-end NVIDIA GPU's to "set the bar" for performance as a workstation platform for this class of applications. I believe this is indeed the case!**  

## Conclusion

The AMD Threadripper 3990x is mile-stone in computing. A 64-core desktop workstation processor was unimaginable a few years ago. This is definitely a "specialty" processor. This is a processor for large parallel computing problems that have excellent scalability. It will be a very compelling Scientific Workstation processor. 
