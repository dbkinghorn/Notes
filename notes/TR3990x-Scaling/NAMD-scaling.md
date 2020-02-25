


+p14 +isomalloc_sync  stmv.namd


../../NAMD_2.12_Linux-x86_64-multicore/namd2 +p56 +setcpuaffinity +idlepoll stmv.namd


```
# run from 1 to 64 OMP threads on a numpy matrix norm                                                                                                              

for n in 1 2 4 8 16 24 32 40 48	56 64
do
     echo $n	>> test.out
     ../NAMD_2.13_Linux-x86_64-multicore/namd2 +p${n} +setcpuaffinity +idlepoll +isomalloc_sync apoa1.namd | grep 'Benchmark\|WallClock' |	tee -a test.out
done
```

openblas-np) kinghorn@Shipping:~/NAMD/apoa1$ ./run-namd-scale.sh

```
(openblas-np) kinghorn@Shipping:~/NAMD/apoa1$ cat test.out 
1
Info: Benchmark time: 1 CPUs 0.530386 s/step 6.13873 days/ns 341.672 MB memory
Info: Benchmark time: 1 CPUs 0.522291 s/step 6.04504 days/ns 342.07 MB memory
WallClock: 266.715240  CPUTime: 266.614777  Memory: 347.726562 MB
2
Info: Benchmark time: 2 CPUs 0.268424 s/step 3.10675 days/ns 431.238 MB memory
Info: Benchmark time: 2 CPUs 0.264277 s/step 3.05876 days/ns 431.375 MB memory
WallClock: 135.504166  CPUTime: 135.444260  Memory: 435.488281 MB
4
Info: Benchmark time: 4 CPUs 0.137626 s/step 1.5929 days/ns 581.227 MB memory
Info: Benchmark time: 4 CPUs 0.135544 s/step 1.5688 days/ns 581.227 MB memory
WallClock: 70.467766  CPUTime: 70.419601  Memory: 584.660156 MB
8
Info: Benchmark time: 8 CPUs 0.0704436 s/step 0.815319 days/ns 646.84 MB memory
Info: Benchmark time: 8 CPUs 0.0693926 s/step 0.803156 days/ns 646.84 MB memory
WallClock: 36.763096  CPUTime: 36.729469  Memory: 651.062500 MB
16
Info: Benchmark time: 16 CPUs 0.0362909 s/step 0.420033 days/ns 1206.8 MB memory
Info: Benchmark time: 16 CPUs 0.0358215 s/step 0.4146 days/ns 1206.8 MB memory
WallClock: 19.612825  CPUTime: 19.585838  Memory: 1210.695312 MB
24
Info: Benchmark time: 24 CPUs 0.0246845 s/step 0.2857 days/ns 1779.76 MB memory
Info: Benchmark time: 24 CPUs 0.0243946 s/step 0.282344 days/ns 1779.76 MB memory
WallClock: 13.617926  CPUTime: 13.579151  Memory: 1782.210938 MB
32
Info: Benchmark time: 32 CPUs 0.0194542 s/step 0.225164 days/ns 2356.41 MB memory
Info: Benchmark time: 32 CPUs 0.0191499 s/step 0.221642 days/ns 2356.41 MB memory
WallClock: 11.261990  CPUTime: 11.212762  Memory: 2357.136719 MB
40
Info: Benchmark time: 40 CPUs 0.0164063 s/step 0.189888 days/ns 2932.14 MB memory
Info: Benchmark time: 40 CPUs 0.0161372 s/step 0.186773 days/ns 2932.14 MB memory
WallClock: 9.670418  CPUTime: 9.622163  Memory: 2932.136719 MB
48
Info: Benchmark time: 48 CPUs 0.0142495 s/step 0.164925 days/ns 3509.04 MB memory
Info: Benchmark time: 48 CPUs 0.0140287 s/step 0.162369 days/ns 3509.04 MB memory
WallClock: 8.226562  CPUTime: 8.184606  Memory: 3509.042969 MB
56
Info: Benchmark time: 56 CPUs 0.0127184 s/step 0.147204 days/ns 4087.14 MB memory
Info: Benchmark time: 56 CPUs 0.0125233 s/step 0.144946 days/ns 4087.14 MB memory
WallClock: 7.706279  CPUTime: 7.660522  Memory: 4087.140625 MB
64
Info: Benchmark time: 64 CPUs 0.0116661 s/step 0.135025 days/ns 4663.06 MB memory
Info: Benchmark time: 64 CPUs 0.0114528 s/step 0.132556 days/ns 4663.06 MB memory
WallClock: 7.542419  CPUTime: 7.515801  Memory: 4663.062500 MB
```



```
(openblas-np) kinghorn@Shipping:~/NAMD/stmv$ cat test.out 
1
Info: Benchmark time: 1 CPUs 5.82722 s/step 67.4446 days/ns 3380.04 MB memory
Info: Benchmark time: 1 CPUs 5.71313 s/step 66.1242 days/ns 3387.73 MB memory
WallClock: 2935.128662  CPUTime: 2933.968018  Memory: 3387.730469 MB
2
Info: Benchmark time: 2 CPUs 2.94177 s/step 34.0483 days/ns 3591.71 MB memory
Info: Benchmark time: 2 CPUs 2.88127 s/step 33.348 days/ns 3591.71 MB memory
WallClock: 1491.300293  CPUTime: 1490.642700  Memory: 3621.761719 MB
4
Info: Benchmark time: 4 CPUs 1.50605 s/step 17.4311 days/ns 3747.4 MB memory
Info: Benchmark time: 4 CPUs 1.4793 s/step 17.1215 days/ns 3757.04 MB memory
WallClock: 774.622742  CPUTime: 774.181580  Memory: 3900.085938 MB
8
Info: Benchmark time: 8 CPUs 0.776542 s/step 8.98776 days/ns 4257.12 MB memory
Info: Benchmark time: 8 CPUs 0.763065 s/step 8.83177 days/ns 4257.12 MB memory
WallClock: 410.441284  CPUTime: 410.201385  Memory: 4303.421875 MB
16
Info: Benchmark time: 16 CPUs 0.406178 s/step 4.70113 days/ns 4865.01 MB memory
Info: Benchmark time: 16 CPUs 0.398914 s/step 4.61706 days/ns 4865.01 MB memory
WallClock: 237.923004  CPUTime: 237.642899  Memory: 4899.699219 MB
24
Info: Benchmark time: 24 CPUs 0.2804 s/step 3.24537 days/ns 5459.3 MB memory
Info: Benchmark time: 24 CPUs 0.275498 s/step 3.18863 days/ns 5459.3 MB memory
WallClock: 160.961014  CPUTime: 160.691269  Memory: 5476.386719 MB
32
Info: Benchmark time: 32 CPUs 0.224422 s/step 2.59747 days/ns 5055.4 MB memory
Info: Benchmark time: 32 CPUs 0.220894 s/step 2.55664 days/ns 5055.4 MB memory
WallClock: 132.596008  CPUTime: 132.291092  Memory: 5061.308594 MB
40
Info: Benchmark time: 40 CPUs 0.191043 s/step 2.21115 days/ns 6088.18 MB memory
Info: Benchmark time: 40 CPUs 0.188302 s/step 2.17942 days/ns 6088.18 MB memory
WallClock: 102.554779  CPUTime: 102.151428  Memory: 6131.832031 MB
48
Info: Benchmark time: 48 CPUs 0.170049 s/step 1.96816 days/ns 7163.54 MB memory
Info: Benchmark time: 48 CPUs 0.167856 s/step 1.94278 days/ns 7163.54 MB memory
WallClock: 105.276253  CPUTime: 104.813232  Memory: 7207.312500 MB
56
Info: Benchmark time: 56 CPUs 0.155662 s/step 1.80165 days/ns 8243.46 MB memory
Info: Benchmark time: 56 CPUs 0.153862 s/step 1.78081 days/ns 8243.46 MB memory
WallClock: 84.384171  CPUTime: 83.893265  Memory: 8286.277344 MB
64
Info: Benchmark time: 64 CPUs 0.145701 s/step 1.68636 days/ns 9361.15 MB memory
Info: Benchmark time: 64 CPUs 0.143364 s/step 1.65931 days/ns 9361.15 MB memory
WallClock: 79.232910  CPUTime: 78.722725  Memory: 9369.484375 MB
```

run 2 
```
(openblas-np) kinghorn@Shipping:~/NAMD/stmv$ ./run-namd-scale.sh
Info: Benchmark time: 1 CPUs 5.8535 s/step 67.7488 days/ns 3380.83 MB memory
Info: Benchmark time: 1 CPUs 5.7395 s/step 66.4294 days/ns 3388.21 MB memory
WallClock: 2934.438965  CPUTime: 2933.288818  Memory: 3388.210938 MB
Info: Benchmark time: 2 CPUs 2.94214 s/step 34.0525 days/ns 3610.79 MB memory
Info: Benchmark time: 2 CPUs 2.88361 s/step 33.3751 days/ns 3611.06 MB memory
WallClock: 1478.435913  CPUTime: 1477.781250  Memory: 3621.976562 MB
Info: Benchmark time: 4 CPUs 1.50955 s/step 17.4716 days/ns 3755.81 MB memory
Info: Benchmark time: 4 CPUs 1.48143 s/step 17.1462 days/ns 3757.92 MB memory
WallClock: 763.491760  CPUTime: 763.066223  Memory: 3901.554688 MB
Info: Benchmark time: 8 CPUs 0.77923 s/step 9.01887 days/ns 4255.54 MB memory
Info: Benchmark time: 8 CPUs 0.764336 s/step 8.84649 days/ns 4255.54 MB memory
WallClock: 397.896790  CPUTime: 397.659607  Memory: 4299.953125 MB
Info: Benchmark time: 16 CPUs 0.407013 s/step 4.7108 days/ns 4864.93 MB memory
Info: Benchmark time: 16 CPUs 0.400005 s/step 4.62969 days/ns 4864.93 MB memory
WallClock: 211.590607  CPUTime: 211.337845  Memory: 4900.449219 MB
Info: Benchmark time: 24 CPUs 0.281168 s/step 3.25425 days/ns 5459.53 MB memory
Info: Benchmark time: 24 CPUs 0.275983 s/step 3.19425 days/ns 5459.53 MB memory
WallClock: 147.953217  CPUTime: 147.656296  Memory: 5476.972656 MB
Info: Benchmark time: 32 CPUs 0.225172 s/step 2.60615 days/ns 5054.81 MB memory
Info: Benchmark time: 32 CPUs 0.222058 s/step 2.57012 days/ns 5054.81 MB memory
WallClock: 119.566040  CPUTime: 119.275436  Memory: 5060.042969 MB
Info: Benchmark time: 40 CPUs 0.191522 s/step 2.21669 days/ns 6088.04 MB memory
Info: Benchmark time: 40 CPUs 0.18889 s/step 2.18623 days/ns 6088.04 MB memory
WallClock: 102.790604  CPUTime: 102.393768  Memory: 6130.863281 MB
Info: Benchmark time: 48 CPUs 0.170167 s/step 1.96953 days/ns 7162.97 MB memory
Info: Benchmark time: 48 CPUs 0.168008 s/step 1.94454 days/ns 7162.97 MB memory
WallClock: 91.992775  CPUTime: 91.549980  Memory: 7206.425781 MB
Info: Benchmark time: 56 CPUs 0.1559 s/step 1.8044 days/ns 8243.34 MB memory
Info: Benchmark time: 56 CPUs 0.153856 s/step 1.78074 days/ns 8243.34 MB memory
WallClock: 84.563240  CPUTime: 84.124428  Memory: 8286.234375 MB
Info: Benchmark time: 64 CPUs 0.145546 s/step 1.68456 days/ns 9327.03 MB memory
Info: Benchmark time: 64 CPUs 0.143623 s/step 1.6623 days/ns 9327.03 MB memory
WallClock: 79.290703  CPUTime: 78.836349  Memory: 9369.839844 MB
```
