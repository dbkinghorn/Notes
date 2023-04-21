## Notes on P2P with 2 4090s updated for driver 525.105.17

The issues with P2P on "2 x 4090s" is "resolved". **NVIDIA's intention is for P2P to be unavailable on GeForce.**
NVIDIA driver 525.105.17 has P2P "properly" disabled on GeForce.

I reran the tests from this post using this new driver and the results are as expected. **I have added an Appendix to the end of this post with the (brief) results from the updated testing.**

## Appendix P2P Update

#### Driver 

```
nvidia-smi
Thu Apr 13 20:26:31 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.105.17   Driver Version: 525.105.17   CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
```

#### simpleP2P
```
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : No
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : No
Two or more GPUs with Peer-to-Peer access capability are required for ./simpleP2P.
Peer to Peer access is not available amongst GPUs in the system, waiving test.
```

#### conjugateGradientMultiDeviceCG
```
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CANNOT Access Peer Device=1
Ignoring device 1 (max devices exceeded)
```


#### p2pBandwidthLatencyTest
```
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 4090, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 4090, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CANNOT Access Peer Device=1
Device=1 CANNOT Access Peer Device=0


Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 918.25  30.92
     1  30.79 922.10
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 919.12  31.06
     1  30.84 923.19
```


#### (tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ mpiexec -np 2 --allow-run-as-root python resnet.py --layers=50 --batch_size=128 --precision=fp16

This job runs fine.
```
2601.8 images/sec
```


#### ../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

NAMD was as expected. It ran fine on the 2 GPUs.
```
Info: Benchmark time: 128 CPUs 0.00125643 s/step 0.014542 days/ns 1034.08 MB memory
```

#### kinghorn@trp64:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -i 501 -b 64 --parallel

This result is very good. Uses PyTorch DDP.
```
****************************************************************
* Time = 76.54 seconds for 501 iterations, batchsize 64
****************************************************************
```

#### CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

This job segfaults and I could not resolve that with ulimit adjustments
```
        PROC COL NET_BW [MB/s ]
[trp64:09093] *** An error occurred in MPI_Sendrecv
[trp64:09093] *** reported by process [1928921089,1]
[trp64:09093] *** on communicator MPI_COMM_WORLD
[trp64:09093] *** MPI_ERR_COMM: invalid communicator
[trp64:09093] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[trp64:09093] ***    and potentially your MPI job)

```






```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ nvidia-smi
Thu Apr 13 20:26:31 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.105.17   Driver Version: 525.105.17   CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:41:00.0  On |                  Off |
|  0%   40C    P8    20W / 450W |    237MiB / 24564MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce ...  Off  | 00000000:61:00.0 Off |                  Off |
|  0%   45C    P8    17W / 450W |      6MiB / 24564MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      2814      G   /usr/lib/xorg/Xorg                235MiB |
|    1   N/A  N/A      2814      G   /usr/lib/xorg/Xorg                  4MiB |
+-----------------------------------------------------------------------------+
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : No
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : No
Two or more GPUs with Peer-to-Peer access capability are required for ./simpleP2P.
Peer to Peer access is not available amongst GPUs in the system, waiving test.
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CANNOT Access Peer Device=1
Ignoring device 1 (max devices exceeded)
Devices involved are not p2p capable.. selecting 2 of them

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel
GPU Final, residual = 7.160786e-06
  Test Summary:  Error amount = 0.000000
&&&& conjugateGradientMultiDeviceCG PASSED
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 4090, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 4090, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CANNOT Access Peer Device=1
Device=1 CANNOT Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0       1     0
     1       0     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 913.74  22.02
     1  22.05 921.88
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1
     0 912.68  22.18
     1  22.45 922.37
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 918.25  30.92
     1  30.79 922.10
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 919.12  31.06
     1  30.84 923.19
P2P=Disabled Latency Matrix (us)
   GPU     0      1
     0   1.38  10.83
     1  10.28   1.35

   CPU     0      1
     0   1.85   5.49
     1   5.48   1.79
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1
     0   1.38  10.49
     1  10.55   1.35

   CPU     0      1
     0   1.84   5.44
     1   5.49   1.78

NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.
```

```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ mpiexec -np 2 --allow-run-as-root python resnet.py --layers=50 --batch_size=128 --precision=fp16

    10  10.0   185.6  4.263  5.235 1.62000
    20  20.0  2511.4  0.106  1.083 1.24469
    30  30.0  2595.6  0.099  1.080 0.91877
    40  40.0  2585.4  0.072  1.056 0.64222
    50  50.0  2598.0  0.186  1.173 0.41506
    60  60.0  2601.8  0.141  1.129 0.23728
    70  70.0  2600.8  0.045  1.034 0.10889
    80  80.0  2523.9  0.003  0.993 0.02988
    90  90.0  1751.1  0.001  0.991 0.00025
```

```
../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

Info: Benchmark time: 128 CPUs 0.00125643 s/step 0.014542 days/ns 1034.08 MB memory
```

```
(pytorch-ngc-22.12)root@trp64:/workspace/examples/upstream/distributed/ddp#  python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
/usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py:180: FutureWarning: The module torch.distributed.launch is deprecated
and will be removed in future. Use torchrun.
Note that --use_env is set by default in torchrun.
If your script expects `--local_rank` argument to be set, please
change it to read from `os.environ['LOCAL_RANK']` instead. See
https://pytorch.org/docs/stable/distributed.html#launch-utility for
further instructions

  warnings.warn(
WARNING:torch.distributed.run:
*****************************************
Setting OMP_NUM_THREADS environment variable for each process to be 1 in default, to avoid your system being overloaded, please further tune the variable for optimal performance in your application as needed.
*****************************************
[6188] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[6189] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[6188]: world_size = 2, rank = 0, backend=nccl
[6189]: world_size = 2, rank = 1, backend=nccl
[6188] rank = 0, world_size = 2, n = 1, device_ids = [0]
[6189] rank = 1, world_size = 2, n = 1, device_ids = [1]
```

```
kinghorn@trp64:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -i 501 -b 64 --parallel

****************************************************************
* Time = 76.54 seconds for 501 iterations, batchsize 64
****************************************************************
```

```
CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

        PROC COL NET_BW [MB/s ]
[trp64:09093] *** An error occurred in MPI_Sendrecv
[trp64:09093] *** reported by process [1928921089,1]
[trp64:09093] *** on communicator MPI_COMM_WORLD
[trp64:09093] *** MPI_ERR_COMM: invalid communicator
[trp64:09093] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[trp64:09093] ***    and potentially your MPI job)
```