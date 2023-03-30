# Testing the new Xeon

Running oneapi base container 2023.0.0

reference this for comparison

https://www.pugetsystems.com/labs/hpc/intel-ice-lake-xeon-w-vs-amd-tr-pro-compute-performance-hpl-hpcg-namd-numpy-2198/

```
******************************************************************************************************
**        Welcome to hwlist script which fetches basic hardware details from your system            **
******************************************************************************************************
Hostname 				 : puget
Operating System 			 : Ubuntu 22.04.2 LTS
Kernel Version 				 : 5.19.0-35-generic
OS Architecture				 : 64 Bit OS
System Uptime 				 : up 2:46 hours
Current System Date & Time 		 : Fri 17 Mar 2023 02:21:49 PM PDT


		 System Hardware Details
	 ----------------------------------
Product Name 				 : System Product Name
Manufacturer 				 : Puget Systems
System Serial Number 			 : Puget-240638
System Version 				 : System Version


		 System Motherboard Details
	 ----------------------------------
Manufacturer 				 : ASUSTeK
Product Name 				 : Pro WS W790E-SAGE SE
Version 				 : Rev
Serial Number 				 : MB-1234567890


		 System BIOS Details
	 ----------------------------------
BIOS Vendor 				 : American Megatrends Inc.
BIOS Version 				 : 9901
BIOS Release Date 			 : 02/24/2023


		 System Processor Details
	 ----------------------------------
Manufacturer 				 : GenuineIntel
Model Name 				 : Intel(R) Xeon(R) w9-3495X
CPU Family 				 : 6
CPU Stepping 				 : 6
No. Of Processors 			 : 1
No. of Cores/Processor 			 : 56

 Details Of Each Processor (Based On dmidecode) 	 	
	 ----------------------------------


	 System Memory Details (RAM)
	 ----------------------------------
Total (Based On Free Command) 	 : 257227 MB 251 GB

```

## HPL  3205 GFLOPS!
```
Maximum memory requested that can be used=39201401024, at the size=70000

=================== Timing linear equation system solver ===================

Size   LDA    Align. Time(s)    GFlops   Residual     Residual(norm) Check
30000  30000  1      5.716      3149.2874 7.831045e-10 3.012061e-02   pass
35000  35000  1      8.981      3183.0719 1.025907e-09 2.911994e-02   pass
40000  40000  1      13.445     3173.7372 1.292461e-09 2.754247e-02   pass
45000  45000  1      19.105     3180.0172 1.744328e-09 2.996757e-02   pass
50000  50000  1      26.623     3130.3014 2.123467e-09 2.964337e-02   pass
60000  60000  1      44.927     3205.3301 3.434495e-09 3.315543e-02   pass
70000  70000  1      73.042     3130.7664 4.853736e-09 3.467301e-02   pass

Performance Summary (GFlops)

Size   LDA    Align.  Average  Maximal
30000  30000  1       3149.2874 3149.2874
35000  35000  1       3183.0719 3183.0719
40000  40000  1       3173.7372 3173.7372
45000  45000  1       3180.0172 3180.0172
50000  50000  1       3130.3014 3130.3014
60000  60000  1       3205.3301 3205.3301
70000  70000  1       3130.7664 3130.7664

Residual checks PASSED

```

## HPCG

```
for n in 56 52 48 44 40 36 32 28 24 20 16 12 8 
do
#    echo $n >> test.out
     mpiexec.hydra -genvall -n $n -ppn 1 ./xhpcg_skx  -n104 -t60 | tee -a  hpcp-scale.out  
done


root@puget:/opt/intel/oneapi/mkl/latest/benchmarks/hpcg/bin# cat hpcp-scale.out 
HPCG result is VALID with a GFLOP/s rating of 43.903148
HPCG result is VALID with a GFLOP/s rating of 44.109349
HPCG result is VALID with a GFLOP/s rating of 44.016689
HPCG result is VALID with a GFLOP/s rating of 44.068551
HPCG result is VALID with a GFLOP/s rating of 43.722309
HPCG result is VALID with a GFLOP/s rating of 43.158199
HPCG result is VALID with a GFLOP/s rating of 42.490200
HPCG result is VALID with a GFLOP/s rating of 41.739231
HPCG result is VALID with a GFLOP/s rating of 40.050530
HPCG result is VALID with a GFLOP/s rating of 36.798958
HPCG result is VALID with a GFLOP/s rating of 31.962157
HPCG result is VALID with a GFLOP/s rating of 25.436888
HPCG result is VALID with a GFLOP/s rating of 18.780892

```

## NAMD 2.14

### ApoA1
```
kinghorn@puget:~/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore/namd2 +p112 +setcpuaffinity +idlepoll apoa1.namd



Info: Benchmark time: 112 CPUs 0.00915893 s/step 0.106006 days/ns 8118.7 MB memory
ETITLE:      TS           BOND          ANGLE          DIHED          IMPRP               ELECT            VDW       BOUNDARY           MISC        KINETIC               TOTAL           TEMP      POTENTIAL         TOTAL3        TEMPAVG            PRESSURE      GPRESSURE         VOLUME       PRESSAVG      GPRESSAVG

ENERGY:     500     20974.8938     19756.6577      5724.4523       179.8271        -337741.4183     23251.1005         0.0000         0.0000     45359.0786        -222495.4082       165.0039   -267854.4868   -222061.0901       165.0039          -3197.5165     -2425.4139    921491.4634     -3197.5165     -2425.4139

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.003 seconds, 8118.695 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.002 seconds, 8118.695 MB of memory in use
====================================================

WallClock: 7.535737  CPUTime: 7.315373  Memory: 8118.695312 MB

9.4 ns/day   0.106006 day/ns

```

### STMV
```
112 threads

Info: Initial time: 112 CPUs 0.101429 s/step 1.17395 days/ns 8715.45 MB memory

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.020 seconds, 8764.273 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.019 seconds, 8764.273 MB of memory in use
====================================================

WallClock: 70.769905  CPUTime: 70.212631  Memory: 8764.273438 MB

1.17395 days/ns    0.8518 ns/day


Info: Initial time: 56 CPUs 0.101102 s/step 1.17016 days/ns 8249.11 MB memory


```