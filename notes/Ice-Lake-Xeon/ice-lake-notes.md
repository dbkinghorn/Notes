Linux icedemo003-SYS-120U-TNR 5.8.0-48-generic #54~20.04.1-Ubuntu SMP Sat Mar 20 13:40:25 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux


```
icedemo003@icedemo003-SYS-120U-TNR:~$ lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   46 bits physical, 57 bits virtual
CPU(s):                          128
On-line CPU(s) list:             0-127
Thread(s) per core:              2
Core(s) per socket:              32
Socket(s):                       2
NUMA node(s):                    2
Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           106
Model name:                      Intel(R) Xeon(R) Platinum 8352Y CPU @ 2.20GHz
Stepping:                        6
Frequency boost:                 enabled
CPU MHz:                         800.199
CPU max MHz:                     3400.0000
CPU min MHz:                     800.0000
BogoMIPS:                        4400.00
Virtualization:                  VT-x
L1d cache:                       3 MiB
L1i cache:                       2 MiB
L2 cache:                        80 MiB
L3 cache:                        96 MiB
NUMA node0 CPU(s):               0-31,64-95
NUMA node1 CPU(s):               32-63,96-127
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl and seccomp
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Enhanced IBRS, IBPB conditional, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2
                                  ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology 
                                 nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr 
                                 pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3
                                 dnowprefetch cpuid_fault epb cat_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb stibp ibrs_enhanced tpr_s
                                 hadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx
                                 512f avx512dq rdseed adx smap avx512ifma clflushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl xsaveo
                                 pt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local split_lock_detect wbnoinvd dthe
                                 rm ida arat pln pts avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg 
                                 tme avx512_vpopcntdq la57 rdpid fsrm md_clear pconfig flush_l1d arch_capabilities
```


## HPL out
```
Mon 05 Apr 2021 03:20:14 PM PDT
Sample data file lininput_xeon64.

Current date/time: Mon Apr  5 15:20:14 2021

CPU frequency:    2.199 GHz
Number of CPUs: 2
Number of cores: 64
Number of threads: 64

Parameters are set to:

Number of tests: 15
Number of equations to solve (problem size) : 1000  2000  5000  10000 15000 18000 20000 22000 25000 26000 27000 30000 35000 40000 45000
Leading dimension of array                  : 1000  2000  5008  10000 15000 18008 20016 22008 25000 26000 27000 30000 35000 40000 45000
Number of trials to run                     : 4     2     2     2     2     2     2     2     2     2     1     1     1     1     1    
Data alignment value (in Kbytes)            : 4     4     4     4     4     4     4     4     4     4     4     1     1     1     1    

Maximum memory requested that can be used=16200901024, at the size=45000

=================== Timing linear equation system solver ===================

Size   LDA    Align. Time(s)    GFlops   Residual     Residual(norm) Check
1000   1000   4      0.028      23.9322  9.944684e-13 3.028736e-02   pass
1000   1000   4      0.005      145.2328 9.944684e-13 3.028736e-02   pass
1000   1000   4      0.005      147.5479 9.944684e-13 3.028736e-02   pass
1000   1000   4      0.005      145.7688 9.944684e-13 3.028736e-02   pass
2000   2000   4      0.016      325.4525 3.911205e-12 3.129711e-02   pass
2000   2000   4      0.015      352.0962 3.911205e-12 3.129711e-02   pass
5000   5008   4      0.061      1360.7362 2.358599e-11 3.114486e-02   pass
5000   5008   4      0.058      1448.4062 2.358599e-11 3.114486e-02   pass
10000  10000  4      0.277      2408.0520 1.025909e-10 3.462047e-02   pass
10000  10000  4      0.290      2297.9724 1.025909e-10 3.462047e-02   pass
15000  15000  4      0.867      2597.0800 2.212143e-10 3.355765e-02   pass
15000  15000  4      0.860      2617.0211 2.212143e-10 3.355765e-02   pass
18000  18008  4      1.419      2741.2357 3.451366e-10 3.661099e-02   pass
18000  18008  4      1.442      2697.4490 3.451366e-10 3.661099e-02   pass
20000  20016  4      2.152      2478.8697 3.544459e-10 3.005529e-02   pass
20000  20016  4      2.212      2411.9085 3.544459e-10 3.005529e-02   pass
22000  22008  4      3.047      2329.6875 4.499630e-10 3.204795e-02   pass
22000  22008  4      2.865      2477.9977 4.366944e-10 3.110291e-02   pass
25000  25000  4      3.594      2898.5612 5.913124e-10 3.263191e-02   pass
25000  25000  4      3.621      2876.8512 5.913124e-10 3.263191e-02   pass
26000  26000  4      4.058      2887.4815 5.704587e-10 2.915125e-02   pass
26000  26000  4      4.062      2884.6313 5.704587e-10 2.915125e-02   pass
27000  27000  4      4.540      2890.8187 7.587211e-10 3.606322e-02   pass
30000  30000  1      6.219      2894.5118 8.341394e-10 3.209323e-02   pass
35000  35000  1      10.173     2809.9293 1.103172e-09 3.126965e-02   pass
40000  40000  1      14.686     2905.4427 1.465520e-09 3.101843e-02   pass
45000  45000  1      21.749     2793.4506 1.791259e-09 3.078240e-02   pass

Performance Summary (GFlops)

Size   LDA    Align.  Average  Maximal
1000   1000   4       115.6204 147.5479
2000   2000   4       338.7744 352.0962
5000   5008   4       1404.5712 1448.4062
10000  10000  4       2353.0122 2408.0520
15000  15000  4       2607.0506 2617.0211
18000  18008  4       2719.3424 2741.2357
20000  20016  4       2445.3891 2478.8697
22000  22008  4       2403.8426 2477.9977
25000  25000  4       2887.7062 2898.5612
26000  26000  4       2886.0564 2887.4815
27000  27000  4       2890.8187 2890.8187
30000  30000  1       2894.5118 2894.5118
35000  35000  1       2809.9293 2809.9293
40000  40000  1       2905.4427 2905.4427
45000  45000  1       2793.4506 2793.4506

Residual checks PASSED

End of tests

Done: Mon 05 Apr 2021 03:22:10 PM PDT

```

## HPCG out

```
icedemo003@icedemo003-SYS-120U-TNR:~/testing$ cat ice-lake-hpcg.out 
64
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=45.6205
60
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=31.5821
56
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=38.6214
52
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=33.2424
48
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=32.1123
44
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=40.8542
40
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=31.378
36
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=32.5818
32
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=30.2173

```

## ApoA1

```
icedemo003@icedemo003-SYS-120U-TNR:~/testing$ cat ice-lake-apoa1.out 
128
Info: Benchmark time: 128 CPUs 0.0108172 s/step 0.125199 days/ns 9266.02 MB memory
Info: Benchmark time: 128 CPUs 0.0107927 s/step 0.124916 days/ns 9266.02 MB memory
WallClock: 7.979589  CPUTime: 7.896567  Memory: 9268.125000 MB
66
Info: Benchmark time: 66 CPUs 0.0100226 s/step 0.116002 days/ns 4807.03 MB memory
Info: Benchmark time: 66 CPUs 0.0095342 s/step 0.11035 days/ns 4807.03 MB memory
WallClock: 8.040938  CPUTime: 8.013902  Memory: 4807.027344 MB
64
Info: Benchmark time: 64 CPUs 0.00968327 s/step 0.112075 days/ns 4666.96 MB memory
Info: Benchmark time: 64 CPUs 0.00952539 s/step 0.110248 days/ns 4666.96 MB memory
WallClock: 6.673347  CPUTime: 6.647041  Memory: 4666.960938 MB
60
Info: Benchmark time: 60 CPUs 0.0101461 s/step 0.117432 days/ns 4378.63 MB memory
Info: Benchmark time: 60 CPUs 0.0100648 s/step 0.116491 days/ns 4378.63 MB memory
WallClock: 6.874970  CPUTime: 6.857780  Memory: 4378.632812 MB
32
Info: Benchmark time: 32 CPUs 0.0154327 s/step 0.178619 days/ns 2362.67 MB memory
Info: Benchmark time: 32 CPUs 0.015388 s/step 0.178102 days/ns 2362.67 MB memory
WallClock: 17.398821  CPUTime: 17.360603  Memory: 2364.609375 MB

```

## STMV

```
icedemo003@icedemo003-SYS-120U-TNR:~/testing$ cat ice-lake-stmv.out 
128
Info: Benchmark time: 128 CPUs 0.113664 s/step 1.31556 days/ns 9873.3 MB memory
Info: Benchmark time: 128 CPUs 0.113974 s/step 1.31915 days/ns 9873.3 MB memory
WallClock: 75.367378  CPUTime: 75.184334  Memory: 9916.417969 MB
66
Info: Benchmark time: 66 CPUs 0.112755 s/step 1.30503 days/ns 9319.8 MB memory
Info: Benchmark time: 66 CPUs 0.109285 s/step 1.26487 days/ns 9319.8 MB memory
WallClock: 93.604546  CPUTime: 93.476120  Memory: 9493.199219 MB
64
Info: Benchmark time: 64 CPUs 0.108483 s/step 1.25559 days/ns 9201.77 MB memory
Info: Benchmark time: 64 CPUs 0.107859 s/step 1.24837 days/ns 9201.77 MB memory
WallClock: 66.150291  CPUTime: 65.528023  Memory: 9373.550781 MB
60
Info: Benchmark time: 60 CPUs 0.114727 s/step 1.32786 days/ns 8789.02 MB memory
Info: Benchmark time: 60 CPUs 0.113694 s/step 1.31591 days/ns 8789.02 MB memory
WallClock: 71.039871  CPUTime: 70.451981  Memory: 8832.507812 MB
32
Info: Benchmark time: 32 CPUs 0.177996 s/step 2.06014 days/ns 5056.68 MB memory
Info: Benchmark time: 32 CPUs 0.177097 s/step 2.04973 days/ns 5056.68 MB memory
WallClock: 100.571388  CPUTime: 100.190048  Memory: 5066.898438 MB

```

## Numpy

```
(2021.2.0) icedemo003@icedemo003-SYS-120U-TNR:~/testing$ OMP_NUM_THREADS=64 python np-bench.py -r 3 -s large
running numpy norm test
norm: 25002415.06	 Run time: 1.00631 seconds	 GFLOPS: 1988
running numpy norm test
norm: 24998507.13	 Run time: 0.80347 seconds	 GFLOPS: 2489
running numpy norm test
norm: 25003475.85	 Run time: 0.76578 seconds	 GFLOPS: 2612
running numpy matmul test
norm: 2538.69	 Run time: 0.74980 seconds	 GFLOPS: 2668
running numpy matmul test
norm: 2504.23	 Run time: 0.75259 seconds	 GFLOPS: 2658
running numpy matmul test
norm: 2443.54	 Run time: 0.73510 seconds	 GFLOPS: 2721
running numpy cholesky test
norm: 70.67	 Run time: 1.25608 seconds	 GFLOPS: 896
running numpy cholesky test
norm: 70.83	 Run time: 1.24926 seconds	 GFLOPS: 901
running numpy cholesky test
norm: 70.57	 Run time: 1.28127 seconds	 GFLOPS: 878
running numpy eig test
norm: 6252798.23	 Run time: 22.98415 seconds	 GFLOPS: 7
running numpy eig test
norm: 6249671.63	 Run time: 23.01926 seconds	 GFLOPS: 7
running numpy eig test
norm: 6250732.12	 Run time: 23.42322 seconds	 GFLOPS: 7


```

```
(2021.2.0) icedemo003@icedemo003-SYS-120U-TNR:~/testing$ OMP_NUM_THREADS=64 python np-bench.py -r 5 -s huge
running numpy norm test
norm: 100001948.86	 Run time: 5.78653 seconds	 GFLOPS: 2765
running numpy norm test
norm: 100003706.50	 Run time: 5.29576 seconds	 GFLOPS: 3021
running numpy norm test
norm: 100003633.71	 Run time: 5.19507 seconds	 GFLOPS: 3080
running numpy norm test
norm: 99996456.09	 Run time: 5.19681 seconds	 GFLOPS: 3079
running numpy norm test
norm: 100001629.72	 Run time: 5.54650 seconds	 GFLOPS: 2885
running numpy matmul test
norm: 4968.37	 Run time: 5.50715 seconds	 GFLOPS: 2905
running numpy matmul test
norm: 5005.73	 Run time: 5.45281 seconds	 GFLOPS: 2934
running numpy matmul test
norm: 5033.95	 Run time: 5.34162 seconds	 GFLOPS: 2995
running numpy matmul test
norm: 5007.62	 Run time: 4.89732 seconds	 GFLOPS: 3267
running numpy matmul test
norm: 4995.91	 Run time: 4.90795 seconds	 GFLOPS: 3260
running numpy cholesky test
norm: 96.45	 Run time: 5.02785 seconds	 GFLOPS: 1455
running numpy cholesky test
norm: 96.26	 Run time: 4.95652 seconds	 GFLOPS: 1476
running numpy cholesky test
norm: 96.68	 Run time: 4.95942 seconds	 GFLOPS: 1475
running numpy cholesky test
norm: 96.77	 Run time: 4.90239 seconds	 GFLOPS: 1493
running numpy cholesky test
norm: 96.50	 Run time: 4.77299 seconds	 GFLOPS: 1533
running numpy eig test
norm: 25000150.81	 Run time: 190.87919 seconds	 GFLOPS: 7
running numpy eig test
norm: 25001083.59	 Run time: 191.71457 seconds	 GFLOPS: 7
running numpy eig test
norm: 24997909.81	 Run time: 190.79654 seconds	 GFLOPS: 7
running numpy eig test
norm: 24999610.22	 Run time: 192.66888 seconds	 GFLOPS: 7
running numpy eig test
norm: 25005950.18	 Run time: 198.39989 seconds	 GFLOPS: 7

```