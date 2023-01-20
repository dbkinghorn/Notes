
## HPL Ryzen 7950x (Zen4 optimizations including AVX512)

```
kinghorn@ltsp225:~/amd-avx512/amd-zen-hpl-2022_11$ OMP_NUM_THREADS=16 OMP_PROC_BIND=TRUE OMP_PLACES=cores ./xhpl
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
Modified by Julien Langou, University of Colorado Denver
================================================================================

An explanation of the input/output parameters follows:
T/V    : Wall time / encoded variant.
N      : The order of the coefficient matrix A.
NB     : The partitioning blocking factor.
P      : The number of process rows.
Q      : The number of process columns.
Time   : Time in seconds to solve the linear system.
Gflops : Rate of execution for solving the linear system.

The following parameter values will be used:

N      :   80576 
NB     :     384 
PMAP   : Row-major process mapping
P      :       1 
Q      :       1 
PFACT  :   Crout 
NBMIN  :      48 
NDIV   :       8 
RFACT  :   Right 
BCAST  :  HybBcast 
DEPTH  :       0 
SWAP   : Mix (threshold = 64)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0


================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR0XR8C48       80576   384     1     1             344.99             1.0110e+03
HPL_pdgesv() start time Mon Jan 16 23:42:43 2023

HPL_pdgesv() end time   Mon Jan 16 23:48:28 2023

--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   4.80122068e-03 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================
```

## HPL Ryzen 7950x (Zen3 optimizations AVX2)

```
kinghorn@ltsp225:~/zen3/hpl$ ./hpl-bench.sh -c 16
************************************************************************
Running HPL benchmark with 16 cores and problem size of 80576
************************************************************************
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
Modified by Julien Langou, University of Colorado Denver
================================================================================

An explanation of the input/output parameters follows:
T/V    : Wall time / encoded variant.
N      : The order of the coefficient matrix A.
NB     : The partitioning blocking factor.
P      : The number of process rows.
Q      : The number of process columns.
Time   : Time in seconds to solve the linear system.
Gflops : Rate of execution for solving the linear system.

The following parameter values will be used:

N      :   80576 
NB     :     384 
PMAP   : Row-major process mapping
P      :       1 
Q      :       1 
PFACT  :   Right 
NBMIN  :       4 
NDIV   :       2 
RFACT  :   Right 
BCAST  :   2ring 
DEPTH  :       1 
SWAP   : Spread-roll (long)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4       80576   384     1     1             433.39             8.0474e+02
HPL_pdgesv() start time Tue Jan 17 00:31:52 2023

HPL_pdgesv() end time   Tue Jan 17 00:39:05 2023

--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   3.93581682e-03 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

It was faster with NB 768! The Zen4 build was slower with that.

```
kinghorn@ltsp225:/benchmarks$ ./hpl-bench.sh -c 16 
************************************************************************
Running HPL benchmark with 16 cores and problem size of 80576
************************************************************************
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
Modified by Julien Langou, University of Colorado Denver
================================================================================

An explanation of the input/output parameters follows:
T/V    : Wall time / encoded variant.
N      : The order of the coefficient matrix A.
NB     : The partitioning blocking factor.
P      : The number of process rows.
Q      : The number of process columns.
Time   : Time in seconds to solve the linear system.
Gflops : Rate of execution for solving the linear system.

The following parameter values will be used:

N      :   80576 
NB     :     768 
PMAP   : Row-major process mapping
P      :       1 
Q      :       1 
PFACT  :   Right 
NBMIN  :       4 
NDIV   :       2 
RFACT  :   Right 
BCAST  :   2ring 
DEPTH  :       1 
SWAP   : Spread-roll (long)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4       80576   768     1     1             380.85             9.1576e+02
HPL_pdgesv() start time Tue Jan 17 00:18:28 2023

HPL_pdgesv() end time   Tue Jan 17 00:24:49 2023


--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   4.15528718e-03 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

## HPL-MxP

From README.md
```
VERSION:    AMD-ZEN-HPL-MXP-2022\_12

# HPL-MxP
A distributed-memory implementation of HPL-MxP for AMD CPUs based on Fugaku HPL-AI code

The HPL-MxP benchmark seeks to highlight the emerging convergence of
high-performance computing (HPC) and artificial intelligence (AI) workloads.
While traditional HPC focused on simulation runs for modeling phenomena in
physics, chemistry, biology, and so on, the mathematical models that drive
these computations require, for the most part, 64-bit accuracy. On the other
hand, the machine learning methods that fuel advances in AI achieve desired
results at 32-bit and even lower floating-point precision formats. This lesser
demand for accuracy fueled a resurgence of interest in new hardware platforms
that deliver a mix of unprecedented performance levels and energy savings to
achieve the classification and recognition fidelity afforded by higher-accuracy
formats.

HPL-MxP strives to unite these two realms by delivering a blend of modern
algorithms and contemporary hardware while simultaneously connecting to the
solver formulation of the decades-old HPL framework of benchmarking the largest
supercomputing installations in the world. The solver method of choice is a
combination of LU factorization and iterative refinement performed afterwards
to bring the solution back to 64-bit accuracy. The innovation of HPL-MxP lies
in dropping the requirement of 64-bit computation throughout the entire
solution process and instead opting for low-precision (likely 16-bit) accuracy
for LU, and a sophisticated iteration to recover the accuracy lost in
factorization. The iterative method guaranteed to be numerically stable is
the generalized minimal residual method (GMRES), which uses application of
the L and U factors to serve as a preconditioner. The combination of these
algorithms is demonstrably sufficient for high accuracy and may be
implemented in a way that takes advantage of the current and upcoming
devices for accelerating AI workloads.

### Dependencies

 - System: Zen4 system with AVX512BF16 support.
 - OS: RHEL 8+/Ubuntu 22.04
 - MPI Library: OpenMPI 4.1


### Running the AMD Zen HPL MxP Benchmark Application

#### Recommended Settings

- Boost : ON 
- Transparent Hugepages : Always
- SMT : OFF
- NPS : 4
- Determinism : Power

For threading, if `BLIS_NUM_THREADS` is not set, BLIS will attempt to query the value of `OMP_NUM_THREADS`. If neither variable is set, the default number of threads is 1.

The number of threads of OpenMP should be set by
```
export OMP_NUM_THREADS=<num>
```

#### How to Run

 * Ensure OpenMPI 4.x is installed and loaded in your environment. 
 * Invoke HPL MxP, supplying arguments for the size of the matrix (N) and blocksize (NB)

#### Example Run Command for Single Node
```
mpirun -np 24 -map-by l3cache:PE=8 -bind-to core -x OMP_NUM_THREADS=8 -x OMP_PROC_BIND=spread -x OMP_PLACES=cores ./hplMxP.x -N 65535 -B 1024
```

## Licensing
Please read Copyright Notice and Licensing terms in AMD Zen HPCG EULA (version 2022\_11).pdf file.
```


```
(ompi)kinghorn@ltsp225:~/amd-avx512/amd-zen-hpl-mxp-2022_12$ OMP_PROC_BIND=TRUE OMP_NUM_THREADS=16 OMP_PLACES=cores ./hplMxP.x -N 65535 -B 1024
jobid=0
N=65536 B=1024 P=1 R=1 C=1
numa=1 pmap=ROWDIST nbuf=2
FHIGH precision: 4
FLOW precision: 2
epoch_size = 1024
#BEGIN: Tue Jan 17 21:34:52 2023
!epoch 1/64: elapsed=0.000000, 0.000000 Gflops (estimate)
!epoch 2/64: elapsed=0.184982, 46812.021271 Gflops (estimate)
!epoch 3/64: elapsed=2.344103, 7272.785090 Gflops (estimate)
!epoch 4/64: elapsed=4.436929, 5672.990513 Gflops (estimate)
!epoch 5/64: elapsed=6.462091, 5111.528470 Gflops (estimate)
!epoch 6/64: elapsed=8.427557, 4821.559676 Gflops (estimate)
!epoch 7/64: elapsed=10.326105, 4646.802941 Gflops (estimate)
!epoch 8/64: elapsed=12.166156, 4527.615004 Gflops (estimate)
!epoch 9/64: elapsed=13.943950, 4442.009340 Gflops (estimate)
!epoch 10/64: elapsed=15.663873, 4376.575426 Gflops (estimate)
!epoch 11/64: elapsed=17.323297, 4325.554371 Gflops (estimate)
!epoch 12/64: elapsed=18.925347, 4284.184442 Gflops (estimate)
!epoch 13/64: elapsed=20.469490, 4250.172111 Gflops (estimate)
!epoch 14/64: elapsed=21.959438, 4221.178165 Gflops (estimate)
!epoch 15/64: elapsed=23.393289, 4196.566699 Gflops (estimate)
!epoch 16/64: elapsed=24.774584, 4174.986330 Gflops (estimate)
!epoch 17/64: elapsed=26.104235, 4155.844749 Gflops (estimate)
!epoch 18/64: elapsed=27.380846, 4139.046120 Gflops (estimate)
!epoch 19/64: elapsed=28.606989, 4123.962885 Gflops (estimate)
!epoch 20/64: elapsed=29.785721, 4110.028701 Gflops (estimate)
!epoch 21/64: elapsed=30.914416, 4097.535073 Gflops (estimate)
!epoch 22/64: elapsed=31.995824, 4086.053788 Gflops (estimate)
!epoch 23/64: elapsed=33.029917, 4075.569714 Gflops (estimate)
!epoch 24/64: elapsed=34.020196, 4065.655941 Gflops (estimate)
!epoch 25/64: elapsed=34.966923, 4056.319183 Gflops (estimate)
!epoch 26/64: elapsed=35.868453, 4047.785101 Gflops (estimate)
!epoch 27/64: elapsed=36.727691, 4039.760589 Gflops (estimate)
!epoch 28/64: elapsed=37.546024, 4032.148825 Gflops (estimate)
!epoch 29/64: elapsed=38.324150, 4024.937806 Gflops (estimate)
!epoch 30/64: elapsed=39.062362, 4018.161160 Gflops (estimate)
!epoch 31/64: elapsed=39.761946, 4011.752491 Gflops (estimate)
!epoch 32/64: elapsed=40.425111, 4005.561726 Gflops (estimate)
!epoch 33/64: elapsed=41.052224, 3999.630752 Gflops (estimate)
!epoch 34/64: elapsed=41.643103, 3994.052857 Gflops (estimate)
!epoch 35/64: elapsed=42.199940, 3988.693587 Gflops (estimate)
!epoch 36/64: elapsed=42.724241, 3983.491641 Gflops (estimate)
!epoch 37/64: elapsed=43.217277, 3978.411922 Gflops (estimate)
!epoch 38/64: elapsed=43.677151, 3973.710323 Gflops (estimate)
!epoch 39/64: elapsed=44.107801, 3969.107288 Gflops (estimate)
!epoch 40/64: elapsed=44.509848, 3964.632100 Gflops (estimate)
!epoch 41/64: elapsed=44.883758, 3960.327433 Gflops (estimate)
!epoch 42/64: elapsed=45.229674, 3956.263444 Gflops (estimate)
!epoch 43/64: elapsed=45.549886, 3952.322700 Gflops (estimate)
!epoch 44/64: elapsed=45.845825, 3948.466455 Gflops (estimate)
!epoch 45/64: elapsed=46.118213, 3944.718397 Gflops (estimate)
!epoch 46/64: elapsed=46.365958, 3941.256226 Gflops (estimate)
!epoch 47/64: elapsed=46.592249, 3937.892701 Gflops (estimate)
!epoch 48/64: elapsed=46.796966, 3934.723471 Gflops (estimate)
!epoch 49/64: elapsed=46.983105, 3931.582543 Gflops (estimate)
!epoch 50/64: elapsed=47.149232, 3928.676193 Gflops (estimate)
!epoch 51/64: elapsed=47.297884, 3925.878646 Gflops (estimate)
!epoch 52/64: elapsed=47.428972, 3923.283668 Gflops (estimate)
!epoch 53/64: elapsed=47.544588, 3920.804478 Gflops (estimate)
!epoch 54/64: elapsed=47.645066, 3918.500583 Gflops (estimate)
!epoch 55/64: elapsed=47.731790, 3916.344984 Gflops (estimate)
!epoch 56/64: elapsed=47.806016, 3914.322128 Gflops (estimate)
!epoch 57/64: elapsed=47.868731, 3912.438826 Gflops (estimate)
!epoch 58/64: elapsed=47.921134, 3910.684909 Gflops (estimate)
!epoch 59/64: elapsed=47.963654, 3909.113492 Gflops (estimate)
!epoch 60/64: elapsed=47.997854, 3907.685249 Gflops (estimate)
!epoch 61/64: elapsed=48.024703, 3906.409811 Gflops (estimate)
!epoch 62/64: elapsed=48.045060, 3905.305882 Gflops (estimate)
!epoch 63/64: elapsed=48.059804, 3904.390826 Gflops (estimate)
!epoch 64/64: elapsed=48.070476, 3903.628229 Gflops (estimate)
LU factorization time: 48.077266
# iterative refinement: step=  0, residual=6.1516646070169537e-07 hpl-harness=5.577507e+08
# iterative refinement: step=  1, residual=1.1924198758836368e-11 hpl-harness=1.079394e+04
# iterative refinement: step=  2, residual=1.8811596734073759e-16 hpl-harness=1.702850e-01
IR time: 0.843261
#END__: Tue Jan 17 21:35:49 2023
48.920533071 sec. 3835.94 GFlop/s resid = 1.881160e-16 hpl-harness = 1.702850e-01

=============================================================================
matrix size (N): 65536
block size (B): 1024
epoch_size: 1024
LU alg 0
Right panel tiled
nbuf: 2
total MPIs: 1
MPI map: P*Q, P: 1, Q: 1
numa size: 1
pmap: ROWDIST
Ring type: 0, bi-direction
LU factorization time: 48.077266 s
IR time: 0.843261 s
overall time: 48.9205 s
overall performance: 3835.94 GFlops
Avg performance per MPI: 3835.94 GFlops
=============================================================================
```

```
(ompi)kinghorn@ltsp225:~/amd-avx512/amd-zen-hpl-mxp-2022_12$ OMP_PROC_BIND=TRUE OMP_NUM_THREADS=16 OMP_PLACES=cores ./hplMxP.x -N 98303 -B 1024
jobid=0
N=98304 B=1024 P=1 R=1 C=1
numa=1 pmap=ROWDIST nbuf=2
FHIGH precision: 4
FLOW precision: 2
epoch_size = 1024
#BEGIN: Tue Jan 17 21:49:35 2023
!epoch 1/96: elapsed=0.000000, 0.000000 Gflops (estimate)
!epoch 2/96: elapsed=0.250701, 78124.017982 Gflops (estimate)
!epoch 3/96: elapsed=5.014166, 7730.798672 Gflops (estimate)
!epoch 4/96: elapsed=9.679830, 5944.064238 Gflops (estimate)
!epoch 5/96: elapsed=14.248583, 5327.695666 Gflops (estimate)
!epoch 6/96: elapsed=18.718759, 5015.907441 Gflops (estimate)
!epoch 7/96: elapsed=23.095482, 4826.925533 Gflops (estimate)
!epoch 8/96: elapsed=27.377031, 4700.372099 Gflops (estimate)
!epoch 9/96: elapsed=31.569452, 4608.950418 Gflops (estimate)
!epoch 10/96: elapsed=35.671157, 4539.911255 Gflops (estimate)
!epoch 11/96: elapsed=39.684933, 4485.633815 Gflops (estimate)
!epoch 12/96: elapsed=43.608562, 4442.038229 Gflops (estimate)
!epoch 13/96: elapsed=47.444867, 4406.054030 Gflops (estimate)
!epoch 14/96: elapsed=51.193047, 4375.938379 Gflops (estimate)
!epoch 15/96: elapsed=54.855170, 4350.257431 Gflops (estimate)
!epoch 16/96: elapsed=58.434417, 4327.901688 Gflops (estimate)
!epoch 17/96: elapsed=61.930740, 4308.277652 Gflops (estimate)
!epoch 18/96: elapsed=65.341298, 4291.124342 Gflops (estimate)
!epoch 19/96: elapsed=68.673416, 4275.615836 Gflops (estimate)
!epoch 20/96: elapsed=71.921544, 4261.861306 Gflops (estimate)
!epoch 21/96: elapsed=75.092838, 4249.239295 Gflops (estimate)
!epoch 22/96: elapsed=78.184403, 4237.786524 Gflops (estimate)
!epoch 23/96: elapsed=81.200771, 4227.152727 Gflops (estimate)
!epoch 24/96: elapsed=84.138266, 4217.456546 Gflops (estimate)
!epoch 25/96: elapsed=87.003880, 4208.287838 Gflops (estimate)
!epoch 26/96: elapsed=89.790864, 4199.937598 Gflops (estimate)
!epoch 27/96: elapsed=92.508867, 4191.919619 Gflops (estimate)
!epoch 28/96: elapsed=95.152172, 4184.484564 Gflops (estimate)
!epoch 29/96: elapsed=97.727724, 4177.315186 Gflops (estimate)
!epoch 30/96: elapsed=100.229515, 4170.669229 Gflops (estimate)
!epoch 31/96: elapsed=102.664191, 4164.266439 Gflops (estimate)
!epoch 32/96: elapsed=105.026625, 4158.321434 Gflops (estimate)
!epoch 33/96: elapsed=107.325050, 4152.513428 Gflops (estimate)
!epoch 34/96: elapsed=109.555988, 4146.994516 Gflops (estimate)
!epoch 35/96: elapsed=111.719490, 4141.773913 Gflops (estimate)
!epoch 36/96: elapsed=113.814670, 4136.895255 Gflops (estimate)
!epoch 37/96: elapsed=115.846548, 4132.189371 Gflops (estimate)
!epoch 38/96: elapsed=117.813245, 4127.742022 Gflops (estimate)
!epoch 39/96: elapsed=119.717826, 4123.463518 Gflops (estimate)
!epoch 40/96: elapsed=121.560269, 4119.375440 Gflops (estimate)
!epoch 41/96: elapsed=123.344579, 4115.364226 Gflops (estimate)
!epoch 42/96: elapsed=125.067391, 4111.566000 Gflops (estimate)
!epoch 43/96: elapsed=126.731085, 4107.923280 Gflops (estimate)
!epoch 44/96: elapsed=128.335407, 4104.466579 Gflops (estimate)
!epoch 45/96: elapsed=129.885285, 4101.061731 Gflops (estimate)
!epoch 46/96: elapsed=131.376120, 4097.878782 Gflops (estimate)
!epoch 47/96: elapsed=132.814183, 4094.745005 Gflops (estimate)
!epoch 48/96: elapsed=134.196468, 4091.778806 Gflops (estimate)
!epoch 49/96: elapsed=135.528473, 4088.837180 Gflops (estimate)
!epoch 50/96: elapsed=136.807277, 4086.034840 Gflops (estimate)
!epoch 51/96: elapsed=138.037423, 4083.261363 Gflops (estimate)
!epoch 52/96: elapsed=139.216911, 4080.602547 Gflops (estimate)
!epoch 53/96: elapsed=140.346969, 4078.047563 Gflops (estimate)
!epoch 54/96: elapsed=141.430911, 4075.526105 Gflops (estimate)
!epoch 55/96: elapsed=142.466548, 4073.127690 Gflops (estimate)
!epoch 56/96: elapsed=143.457371, 4070.778113 Gflops (estimate)
!epoch 57/96: elapsed=144.403302, 4068.506094 Gflops (estimate)
!epoch 58/96: elapsed=145.304772, 4066.325531 Gflops (estimate)
!epoch 59/96: elapsed=146.164960, 4064.173739 Gflops (estimate)
!epoch 60/96: elapsed=146.982283, 4062.121346 Gflops (estimate)
!epoch 61/96: elapsed=147.759681, 4060.113198 Gflops (estimate)
!epoch 62/96: elapsed=148.496714, 4058.187956 Gflops (estimate)
!epoch 63/96: elapsed=149.195422, 4056.316138 Gflops (estimate)
!epoch 64/96: elapsed=149.856008, 4054.518724 Gflops (estimate)
!epoch 65/96: elapsed=150.480884, 4052.756947 Gflops (estimate)
!epoch 66/96: elapsed=151.070495, 4051.045643 Gflops (estimate)
!epoch 67/96: elapsed=151.626186, 4049.375370 Gflops (estimate)
!epoch 68/96: elapsed=152.148323, 4047.763122 Gflops (estimate)
!epoch 69/96: elapsed=152.639189, 4046.174838 Gflops (estimate)
!epoch 70/96: elapsed=153.097289, 4044.676819 Gflops (estimate)
!epoch 71/96: elapsed=153.525827, 4043.210959 Gflops (estimate)
!epoch 72/96: elapsed=153.925000, 4041.798847 Gflops (estimate)
!epoch 73/96: elapsed=154.295920, 4040.437964 Gflops (estimate)
!epoch 74/96: elapsed=154.640026, 4039.117390 Gflops (estimate)
!epoch 75/96: elapsed=154.957637, 4037.855588 Gflops (estimate)
!epoch 76/96: elapsed=155.250347, 4036.637787 Gflops (estimate)
!epoch 77/96: elapsed=155.518940, 4035.470370 Gflops (estimate)
!epoch 78/96: elapsed=155.764398, 4034.354727 Gflops (estimate)
!epoch 79/96: elapsed=155.988902, 4033.261217 Gflops (estimate)
!epoch 80/96: elapsed=156.192234, 4032.222479 Gflops (estimate)
!epoch 81/96: elapsed=156.375713, 4031.231279 Gflops (estimate)
!epoch 82/96: elapsed=156.540603, 4030.282024 Gflops (estimate)
!epoch 83/96: elapsed=156.687565, 4029.384633 Gflops (estimate)
!epoch 84/96: elapsed=156.818322, 4028.521774 Gflops (estimate)
!epoch 85/96: elapsed=156.932769, 4027.723148 Gflops (estimate)
!epoch 86/96: elapsed=157.032239, 4026.981568 Gflops (estimate)
!epoch 87/96: elapsed=157.118555, 4026.277286 Gflops (estimate)
!epoch 88/96: elapsed=157.192263, 4025.623431 Gflops (estimate)
!epoch 89/96: elapsed=157.254218, 4025.025220 Gflops (estimate)
!epoch 90/96: elapsed=157.306161, 4024.465185 Gflops (estimate)
!epoch 91/96: elapsed=157.349072, 4023.945436 Gflops (estimate)
!epoch 92/96: elapsed=157.383206, 4023.486597 Gflops (estimate)
!epoch 93/96: elapsed=157.410201, 4023.073982 Gflops (estimate)
!epoch 94/96: elapsed=157.430443, 4022.724951 Gflops (estimate)
!epoch 95/96: elapsed=157.445498, 4022.426663 Gflops (estimate)
!epoch 96/96: elapsed=157.456337, 4022.181612 Gflops (estimate)
LU factorization time: 157.463137
# iterative refinement: step=  0, residual=4.5428501927039516e-07 hpl-harness=2.751060e+08
# iterative refinement: step=  1, residual=5.4153202160252532e-12 hpl-harness=3.277360e+03
# iterative refinement: step=  2, residual=7.8198902253684660e-17 hpl-harness=4.732609e-02
IR time: 1.857114
#END__: Tue Jan 17 21:52:32 2023
159.320256226 sec. 3975.22 GFlop/s resid = 7.819890e-17 hpl-harness = 4.732609e-02

=============================================================================
matrix size (N): 98304
block size (B): 1024
epoch_size: 1024
LU alg 0
Right panel tiled
nbuf: 2
total MPIs: 1
MPI map: P*Q, P: 1, Q: 1
numa size: 1
pmap: ROWDIST
Ring type: 0, bi-direction
LU factorization time: 157.463137 s
IR time: 1.85711 s
overall time: 159.32 s
overall performance: 3975.22 GFlops
Avg performance per MPI: 3975.22 GFlops
=============================================================================

```

Running with mpi was worse.
```
mpirun -np 2 -map-by l3cache:PE=8 -bind-to core -x OMP_NUM_THREADS=8 -x OMP_PROC_BIND=spread -x OMP_PLACES=cores ./hplMxP.x -N 65535 -B 1024

...
overall performance: 3495.62 GFlops
Avg performance per MPI: 1747.81 GFlops
```

## HPCG

```
# Run the HPCG benchmark
for NUM_CORES in ${CORE_SERIES}; do
    echo "Running HPCG with ${NUM_CORES} cores ..." | tee -a hpcg-jobs.out
    mpirun --allow-run-as-root -np ${NUM_CORES} --map-by l3cache  -x OMP_NUM_THREADS=1 xhpcg --nx=104 --ny=104 --nz=104 --rt=60
    grep 'VALID' n104-*.txt | tee -a hpcg-jobs.out
    cat n104-*.txt
    rm *.txt
    sleep 4 # wait a bit for MPI processes to get cleaned up
done
```

```
Running HPCG with 2 cores ...
Final Summary::HPCG result is VALID with a GFLOP/s rating of=8.48185
Running HPCG with 4 cores ...
Final Summary::HPCG result is VALID with a GFLOP/s rating of=10.2247
Running HPCG with 6 cores ...
Final Summary::HPCG result is VALID with a GFLOP/s rating of=10.5261
Running HPCG with 8 cores ...
Final Summary::HPCG result is VALID with a GFLOP/s rating of=10.0703
Running HPCG with 10 cores ...
Final Summary::HPCG result is VALID with a GFLOP/s rating of=10.0119
Running HPCG with 12 cores ...

```


