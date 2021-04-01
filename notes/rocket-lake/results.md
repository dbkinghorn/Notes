

## 11900KF

base) kinghorn@pslabs-ml1:~/projects/stmv$ cat stmv-11900K.out 
Info: Benchmark time: 16 CPUs 0.427733 s/step 4.95061 days/ns 4861.26 MB memory
Info: Benchmark time: 16 CPUs 0.425526 s/step 4.92507 days/ns 4861.26 MB memory
WallClock: 223.349380  CPUTime: 223.298019  Memory: 4899.152344 MB

base) kinghorn@pslabs-ml1:~/projects/apoa1$ cat apoa1-11900K.out 
Info: Benchmark time: 16 CPUs 0.0362654 s/step 0.419739 days/ns 1206.53 MB memory
Info: Benchmark time: 16 CPUs 0.0360181 s/step 0.416876 days/ns 1206.53 MB memory
WallClock: 19.691561  CPUTime: 19.676073  Memory: 1210.746094 MB


Performance Summary (GFlops)

Size   LDA    Align.  Average  Maximal
50000  50000  1       529.9715 529.9715
60000  60000  1       534.5506 534.5506
70000  70000  1       537.7402 537.7402
80000  80000  1       539.7137 539.7137

(base) kinghorn@pslabs-ml1:~/projects/benchmarks/hpcg/bin$ cat hpcg-11900K.out 
16
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=8.60873
8
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=8.63712
6
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=8.69416
4
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=8.58158
2
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=8.33263
1
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=6.81152


(np-intel) kinghorn@pslabs-ml1:~/projects$ python matnorm.py 
 took 28.515380144119263 seconds 
 norm =  2828686.6459026947

(np-openblas) kinghorn@pslabs-ml1:~/projects$ python matnorm.py 
 took 132.63532614707947 seconds 
 norm =  2828447.8829570143


## Ryzen 5800X


kinghorn@amd:~/projects/AMD-benchmark-dev/hpl-blis-mt-gcc$ cat hpl-5800x.out 
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4       60000   768     1     1             346.69             4.1537e+02
HPL_pdgesv() start time Tue Mar 23 16:21:13 2021

HPL_pdgesv() end time   Tue Mar 23 16:27:00 2021

--------------------------------------------------------------------------------


Yes Intel exe :-)

kinghorn@amd:~/intel/oneapi/mkl/latest/benchmarks/hpcg/bin$ cat test.out 
16
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=5.9761
8
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=6.06722
6
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=6.19893
4
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=6.38642
2
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=5.84834
1
 Final Summary ::HPCG result is VALID with a GFLOP/s rating of=3.35933


kinghorn@amd:~/projects/AMD-benchmark-dev/hpcg-3.1$ cat build-AOCC3_OMP/bin/test.out 
16
Final Summary::HPCG result is VALID with a GFLOP/s rating of=2.74299
8
Final Summary::HPCG result is VALID with a GFLOP/s rating of=3.15512
6
Final Summary::HPCG result is VALID with a GFLOP/s rating of=3.12777
4
Final Summary::HPCG result is VALID with a GFLOP/s rating of=3.10138
2
Final Summary::HPCG result is VALID with a GFLOP/s rating of=3.19998
1
Final Summary::HPCG result is VALID with a GFLOP/s rating of=2.78467


kinghorn@amd:~/projects/AMD-benchmark-dev/NAMD/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore/namd2 +p16 +setcpuaffinity +idlepoll +isomalloc_sync  apoa1.namd | grep 'Benchmark\|WallClock' | tee -a test.out
Info: Benchmark time: 16 CPUs 0.0528559 s/step 0.611759 days/ns 1205.88 MB memory
Info: Benchmark time: 16 CPUs 0.0527019 s/step 0.609975 days/ns 1205.88 MB memory
WallClock: 28.306038  CPUTime: 28.277956  Memory: 1209.574219 MB

kinghorn@amd:~/projects/AMD-benchmark-dev/NAMD/stmv$ cat test.out 
Info: Benchmark time: 16 CPUs 0.57187 s/step 6.61886 days/ns 4861.74 MB memory
Info: Benchmark time: 16 CPUs 0.570147 s/step 6.59892 days/ns 4861.74 MB memory
WallClock: 296.066498  CPUTime: 295.859436  Memory: 4895.542969 MB

(np-main) kinghorn@amd:~/projects/numpy-matnorm$ python matnorm.py 
 took 37.32181215286255 seconds 
 norm =  2828412.387396344

kinghorn@amd:~/projects/numpy-matnorm$ conda activate np-openblas
(np-openblas) kinghorn@amd:~/projects/numpy-matnorm$ python matnorm.py 
 took 34.35531544685364 seconds 
 norm =  2828317.471341577

| Job               | 11900K                 | 5800X                              |
|-------------------|------------------------|------------------------------------|
| HPL Linpack       | 540 GFLOPS             | 415 GFLOPS                         |
| HPCG              | 8.69 GFLOPS (@6 cores) | 6.39 GFLOPS (@4 cores 2400MHz mem) |
| NAMD ApoA1        | 0.419 day/ns           | 0.610 day/ns                       |
| NAMD STMV         | 4.925 day/ns            | 6.60 day/ns                        |
| Mat Norm MKL      | 28.5 sec               | 37.3 sec                           |
| Mat Norm openBLAS | 132.6 sec              | 34.3 sec                           |



(base) kinghorn@pslabs-ml1:~$ lscpu 
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   39 bits physical, 48 bits virtual
CPU(s):                          16
On-line CPU(s) list:             0-15
Thread(s) per core:              2
Core(s) per socket:              8
Socket(s):                       1
NUMA node(s):                    1
Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           167
Model name:                      11th Gen Intel(R) Core(TM) i9-11900KF @ 3.50GHz
Stepping:                        1
CPU MHz:                         800.735
CPU max MHz:                     5300.0000
CPU min MHz:                     800.0000
BogoMIPS:                        7008.00
Virtualization:                  VT-x
L1d cache:                       384 KiB
L1i cache:                       256 KiB
L2 cache:                        4 MiB
L3 cache:                        16 MiB
NUMA node0 CPU(s):               0-15
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl and seccomp
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Enhanced IBRS, IBPB conditional, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd
                                 pe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmul
                                 qdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsa
                                 ve avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriori
                                 ty ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512dq rdseed adx smap avx512ifma clflushopt in
                                 tel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
                                  hwp_pkg_req avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid fsrm md_cle
                                 ar flush_l1d arch_capabilities

Flags from Xeon W 2295

Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pd
                                 pe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 moni
                                 tor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx 
                                 f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb stibp ibrs_enhanced 
                                 tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm mpx rdt_a avx512f avx512dq rdse
                                 ed adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cq
                                 m_mbm_local dtherm ida arat pln pts hwp hwp_act_window hwp_epp hwp_pkg_req avx512_vnni md_clear flush_l1d arch_capabilities




