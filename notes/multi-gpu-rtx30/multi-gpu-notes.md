```
kinghorn@pslabs-ml1:~/quad-gpu/samples/1_Utilities/p2pBandwidthLatencyTest$  ./p2pBandwidthLatencyTest
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, GeForce RTX 3090, pciBusID: 19, pciDeviceID: 0, pciDomainID:0
Device: 1, GeForce RTX 3090, pciBusID: 53, pciDeviceID: 0, pciDomainID:0
Device: 2, GeForce RTX 3090, pciBusID: 8d, pciDeviceID: 0, pciDomainID:0
Device: 3, GeForce RTX 3090, pciBusID: c7, pciDeviceID: 0, pciDomainID:0
Device=0 CANNOT Access Peer Device=1
Device=0 CANNOT Access Peer Device=2
Device=0 CANNOT Access Peer Device=3
Device=1 CANNOT Access Peer Device=0
Device=1 CANNOT Access Peer Device=2
Device=1 CANNOT Access Peer Device=3
Device=2 CANNOT Access Peer Device=0
Device=2 CANNOT Access Peer Device=1
Device=2 CANNOT Access Peer Device=3
Device=3 CANNOT Access Peer Device=0
Device=3 CANNOT Access Peer Device=1
Device=3 CANNOT Access Peer Device=2

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1     2     3
     0       1     0     0     0
     1       0     1     0     0
     2       0     0     1     0
     3       0     0     0     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3
     0 831.56   5.90   5.89   5.89
     1   5.90 829.35   5.89   5.89
     2   5.89   5.90 831.70   5.89
     3   5.90   5.90   5.89 831.56
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1      2      3
     0 832.89   5.90   5.90   5.90
     1   5.90 832.00   5.90   5.89
     2   5.90   5.90 831.12   5.90
     3   5.90   5.90   5.89 832.00
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3
     0 837.10   8.76   8.75   8.75
     1   8.75 837.33   8.74   8.75
     2   8.75   8.76 836.40   8.76
     3   8.75   8.75   8.74 835.74
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3
     0 836.90   8.75   8.75   8.76
     1   8.75 831.05   8.74   8.77
     2   8.75   8.74 836.68   8.74
     3   8.75   8.74   8.73 837.35
P2P=Disabled Latency Matrix (us)
   GPU     0      1      2      3
     0   1.57  10.34  18.49  10.26
     1  18.51   1.67  10.26  10.36
     2  10.31  10.45   1.62  18.50
     3  10.33  10.26  10.26   1.64

   CPU     0      1      2      3
     0   1.85   5.92   5.80   5.83
     1   5.87   1.81   5.69   5.77
     2   5.80   6.10   2.22   5.73
     3   5.80   5.76   5.67   1.90
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1      2      3
     0   1.57  18.50  10.26  10.26
     1  10.45   1.64  10.26  18.47
     2  10.27  10.28   1.62  10.28
     3  10.33  18.50  10.31   1.64

   CPU     0      1      2      3
     0   2.00   6.01   5.76   5.84
     1   6.30   1.78   5.77   5.81
     2   5.82   5.79   1.79   5.77
     3   5.88   5.81   5.71   1.78
```

## nbody

```
kinghorn@pslabs-ml1:~/quad-gpu/samples/5_Simulations/nbody$ ./nbody -benchmark -numdevices=1

number of CUDA devices  = 1
> Windowed mode
> Simulation data stored in video memory
> Single precision floating point simulation
> 1 Devices used for simulation
GPU Device 0: "Ampere" with compute capability 8.6

> Compute 8.6 CUDA device: [GeForce RTX 3090]
83968 bodies, total time for 10 iterations: 74.681 ms
= 944.095 billion interactions per second
= 18881.891 single-precision GFLOP/s at 20 flops per interaction

kinghorn@pslabs-ml1:~/quad-gpu/samples/5_Simulations/nbody$ ./nbody -benchmark -numdevices=2

number of CUDA devices  = 2
> Windowed mode
> Simulation data stored in system memory
> Single precision floating point simulation
> 2 Devices used for simulation
GPU Device 0: "Ampere" with compute capability 8.6

> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
167936 bodies, total time for 10 iterations: 187.389 ms
= 1505.025 billion interactions per second
= 30100.497 single-precision GFLOP/s at 20 flops per interaction

kinghorn@pslabs-ml1:~/quad-gpu/samples/5_Simulations/nbody$ ./nbody -benchmark -numdevices=3

number of CUDA devices  = 3
> Windowed mode
> Simulation data stored in system memory
> Single precision floating point simulation
> 3 Devices used for simulation
GPU Device 0: "Ampere" with compute capability 8.6

> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
251904 bodies, total time for 10 iterations: 278.400 ms
= 2279.297 billion interactions per second
= 45585.939 single-precision GFLOP/s at 20 flops per interaction

kinghorn@pslabs-ml1:~/quad-gpu/samples/5_Simulations/nbody$ ./nbody -benchmark -numdevices=4

number of CUDA devices  = 4
> Windowed mode
> Simulation data stored in system memory
> Single precision floating point simulation
> 4 Devices used for simulation
GPU Device 0: "Ampere" with compute capability 8.6

> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
> Compute 8.6 CUDA device: [GeForce RTX 3090]
335872 bodies, total time for 10 iterations: 371.515 ms
= 3036.483 billion interactions per second
= 60729.653 single-precision GFLOP/s at 20 flops per interaction

```

