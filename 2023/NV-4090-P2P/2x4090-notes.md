# NVIDIA 4090 P2P on AMD

Testing reports of issues with dual 4090 on AMD Tr Pro

history dump so far:

```
kinghorn@trp64:~$ history
    1  ip addr
    2  cat /proc/cmdline
    3  sudo apt update
    4  sudo apt upgrade
    5  uname -a
    6  sudo apt install emacs-nox build-essential dkms
    7  sudo nano /etc/needrestart/needrestart.conf
    8  sudo apt install nvidia-driver-525-server
    9  sudo shutdown -r now
   10  nvidia-smi
   11  exit
   12  ls
   13  DIST=$(. /etc/os-release; echo $ID$VERSION_ID)
   14  curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
   15  curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/libnvidia-container.list
   16  sudo apt-get update
   17  sudo apt install libnvidia-container-tools
   18  RELEASE=3.4.0
   19  arch=$(dpkg --print-architecture)
   20  curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot_${RELEASE}-1_${arch}.deb
   21  curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v${RELEASE}/enroot+caps_${RELEASE}-1_${arch}.deb
   22  ls
   23  sudo apt install *.deb
   24  sudo apt install ./enroot_3.4.0-1_amd64.deb
   25  sudo apt install ./enroot+caps_3.4.0-1_amd64.deb
   26  enroot --version
   27  enroot version
   28  ls
   29  rm enroot*
   30  ls
   31  enroot import docker://nvcr.io#nvidia/cuda:12.0.0-devel-ubuntu20.04
   32  enroot import docker://nvcr.io#nvidia/cuda:11.8.0-devel-ubuntu22.04
   34  ls
   35  mkdir containers
   36  mv nvidia+cuda+1* containers/
   37  ls
   38  cd containers/
   39  enroot
   40  enroot create --name cuda12-20.04
   41  enroot create --name cuda12-20.04 nvidia+cuda+12.0.0-devel-ubuntu20.04.sqsh
   42  enroot create --name cuda11.8-22.04 nvidia+cuda+11.8.0-devel-ubuntu22.04.sqsh
   43  enroot list
   44  ls
   45  cd ..
   46  ls
   47  ./set-enroot-prompt cuda11.8-22.04
   48  ./set-enroot-prompt cuda12-20.04
   49  wget https://github.com/NVIDIA/cuda-samples/archive/refs/tags/v11.8.tar.gz
   50  ls
   51  wget https://github.com/NVIDIA/cuda-samples/archive/refs/tags/v12.0.tar.gz
   52  ls
   53  tar xf v11.8.tar.gz
   54  ls
   55  tar xf v12.0.tar.gz
   56  ls
   57  mkdir bin
   58  mv set-enroot-prompt bin/
   59  ls
   60  export ENROOT_MOUNT_HOME=y
   63  enroot list
   64  enroot start cuda11.9-22.04
   65  enroot start cuda11.8-22.04
   66  enroot start cuda12-22.04
   67  enroot list
   68  enroot start cuda12-20.04

```

p2pbandwidthlatencytest

```
(cuda11.8-22.04)kinghorn@trp64:~/cuda-samples-11.8/Samples/5_Domain_Specific/p2pBandwidthLatencyTest$ ./p2pBandwidthLatencyTest
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 4090, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 4090, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CAN Access Peer Device=1
Device=1 CAN Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     1
     1	     1     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 909.92  22.47
     1  22.67 918.56
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1
     0 913.03  27.07
     1  11.46 916.42
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 899.54  30.94
     1  31.10 923.19
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1
     0 918.01  54.11
     1  54.13 922.92
P2P=Disabled Latency Matrix (us)
   GPU     0      1
     0   1.37  11.64
     1  11.66   1.39

   CPU     0      1
     0   2.12   6.66
     1   6.71   2.06
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1
     0   1.37   1.14
     1   1.13   1.39

   CPU     0      1
     0   2.13   1.77
     1   1.71   2.05

NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.

```

SimpleP2P

```
(cuda11.8-22.04)kinghorn@trp64:~/cuda-samples-11.8/Samples/0_Introduction/simpleP2P$ ./simpleP2P
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 10.39GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 0: val = nan, ref = 0.000000
Verification error @ element 1: val = nan, ref = 4.000000
Verification error @ element 2: val = nan, ref = 8.000000
Verification error @ element 3: val = nan, ref = 12.000000
Verification error @ element 4: val = nan, ref = 16.000000
Verification error @ element 5: val = nan, ref = 20.000000
Verification error @ element 6: val = nan, ref = 24.000000
Verification error @ element 7: val = nan, ref = 28.000000
Verification error @ element 8: val = nan, ref = 32.000000
Verification error @ element 9: val = nan, ref = 36.000000
Verification error @ element 10: val = nan, ref = 40.000000
Verification error @ element 11: val = nan, ref = 44.000000
Disabling peer access...
Shutting down...
Test failed!

```

Here sung CUDA 12 on 20.04 container

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/Samples/0_Introduction/simpleP2P$ ./simpleP2P
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 10.26GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 0: val = nan, ref = 0.000000
Verification error @ element 1: val = nan, ref = 4.000000
Verification error @ element 2: val = nan, ref = 8.000000
Verification error @ element 3: val = nan, ref = 12.000000
Verification error @ element 4: val = nan, ref = 16.000000
Verification error @ element 5: val = nan, ref = 20.000000
Verification error @ element 6: val = nan, ref = 24.000000
Verification error @ element 7: val = nan, ref = 28.000000
Verification error @ element 8: val = nan, ref = 32.000000
Verification error @ element 9: val = nan, ref = 36.000000
Verification error @ element 10: val = nan, ref = 40.000000
Verification error @ element 11: val = nan, ref = 44.000000
Disabling peer access...
Shutting down...
Test failed!

```

Trying to use pytorch NGC with DDP example

```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$ MASTER_ADDR='localhost' MASTER_PORT=12355 RANK=0 WORLD_SIZE=1 python example.py --local_world_size 2
[16989] Initializing process group with: {'MASTER_ADDR': 'localhost', 'MASTER_PORT': '12355', 'RANK': '0', 'WORLD_SIZE': '1'}
[16989]: world_size = 1, rank = 0, backend=nccl
[16989] rank = 0, world_size = 1, n = 1, device_ids = [0]

```

Not quite what I want :-)

```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$ python -c "from os import path; import torch; print(path.join(path.dirname(torch.__file__), 'distributed', 'launch.py'))"
/usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py
```

```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=1 ./example.py --local_world_size=2
bash: /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py: Permission denied

```

Ha ha have to run as root ... ooops! forgot python at beginning of line!

Try as root anyway.

```
(pytorch-ngc-22.12)root@trp64:/workspace/examples/upstream/distributed/ddp# python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[17945] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[17944] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[17944]: world_size = 2, rank = 0, backend=nccl
[17945]: world_size = 2, rank = 1, backend=nccl
[17944] rank = 0, world_size = 2, n = 1, device_ids = [0]
[17945] rank = 1, world_size = 2, n = 1, device_ids = [1]

```

It's hung!

## NGC-HPL

```
export MELLANOX_VISIBLE_DEVICES="none"
```

```
kinghorn@trp64:/workspace/hpl-linux-x86_64$ CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

INFO: host=trp64 rank=0 lrank=0 cores=4 gpu=0 cpu=0 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl
INFO: host=trp64 rank=1 lrank=1 cores=4 gpu=1 cpu=1 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl

```

```
2023-02-01 15:44:38.186
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       48000   288     1     2              36.48              2.021e+03
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0049182 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

2023-02-01 16:00:58.579
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             110.80              2.246e+03
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0028573 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

Looks good!

## HPCG x2

```
kinghorn@trp64:/workspace/hpcg-linux-x86_64$ mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpcg.sh --dat ./hpcg.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1
```

```
2023-02-01 16:40:54.285

Number of CG sets:	744
Iterations per set:	51
scaled res mean:	2.867480e-06
scaled res variance:	0.000000e+00

Total Time: 8.979248e+01 sec
Setup        Overhead: 1.38%
Optimization Overhead: 0.67%
Convergence  Overhead: 1.96%

2x1x1 process grid
104x104x104 local domain
SpMV  =  267.4 GF (1684.9 GB/s Effective)  133.7 GF_per ( 842.4 GB/s Effective)
SymGS =  379.8 GF (2931.9 GB/s Effective)  189.9 GF_per (1466.0 GB/s Effective)
total =  350.6 GF (2659.5 GB/s Effective)  175.3 GF_per (1329.8 GB/s Effective)
final =  336.7 GF (2554.6 GB/s Effective)  168.4 GF_per (1277.3 GB/s Effective)

```

Looks good!

### NAMD

https://www.ks.uiuc.edu/Research/namd/alpha/3.0alpha/

```
Notes on NAMD 3.0 Multi-GPU Scaling Per-Replicate
NAMD 3.0 alpha builds now support multi-GPU scaling of single-replicate simulations within a single node, for sets of NVLink-connected GPUs. NAMD 3.0 will drive them in GPU-resident mode, with minimal need for CPU power. In order to scale a single simulation across multiple GPUs, all pairs of devices must be "peered" with each other, either having a direct NVLink cable connection or all plugged into an NVSwitch, as is the case with the DGX series hardware. You can verify the connectivity of your GPUs by running the command "nvidia-smi topo -m" and checking that the connectivity matrix shows an "NV" connection between each pair of GPUs.

Multiple GPU devices are specified with the +devices. flag. The original support provided in the alpha 9 release requires exactly one CPU core per GPU device, meaning that the +pN CPU core count must exactly match the GPU device count specified with +devices. That restriction has been lifted since alpha 10 and later releases. Using more than one CPU core per device helps improve the performance of parts that remain on the CPU, in particular, atom migration.

NAMD 3 currently delegates one device to perform long-range electrostatics with PME, when enabled. You can specify which GPU device PME will run on by including +pmedevice deviceid in your command-line run. One issue with multi-GPU scaling is that PME causes a bottleneck when all of the non-PME work is equally divided between devices. Since alpha 10, we provide a way to control the amount of work assigned to the PME device by scaling back the number of PEs (CPU cores) for that device using the +pmePEs command line parameter. This is best shown through the example of scaling an STMV-sized system (around 1M atoms) on DGX-A100:

./namd3 +p57 +pmePEs 1 +setcpuaffinity +devices 0,1,2,3,4,5,6,7 myconf.namd
In this example, 8 PEs are used per device, except for the PME device which is limited to 1, providing a balanced load for each device. Notice that the total number of PEs is adjusted to (7*8 + 1) = 57.
Since alpha 11, the short-range non-bonded forces kernel can be sped up by direct calculation of force interactions rather than table lookup for non-PME steps, as might happen when using multiple time stepping. You can request direct calculation by the config file setting:

The code is still evolving, and test builds will be updated frequently. Stay tuned!


```

## Important

```
kinghorn@trp64:/workspace/hpcg-linux-x86_64$ nvidia-smi topo -m
	GPU0	GPU1	CPU Affinity	NUMA Affinity
GPU0	 X 	SYS	0-127		N/A
GPU1	SYS	 X 	0-127		N/A

Legend:

  X    = Self
  SYS  = Connection traversing PCIe as well as the SMP interconnect between NUMA nodes (e.g., QPI/UPI)
  NODE = Connection traversing PCIe as well as the interconnect between PCIe Host Bridges within a NUMA node
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe bridges (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing at most a single PCIe bridge
  NV#  = Connection traversing a bonded set of # NVLinks

```

## TF 1.15

```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-01 23:12:27.452852:
```

It just hangs with GPUs at 100%

```
kinghorn@trp64:~$ nvidia-smi
Wed Feb  1 23:16:49 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.60.13    Driver Version: 525.60.13    CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:41:00.0 Off |                  Off |
| 30%   43C    P2    83W / 450W |  19854MiB / 24564MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce ...  Off  | 00000000:61:00.0 Off |                  Off |
| 30%   36C    P2    76W / 450W |  19880MiB / 24564MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A     30107      C   python                          19852MiB |
|    1   N/A  N/A     30108      C   python                          19878MiB |
+-----------------------------------------------------------------------------+

```

## NAMD 2

Well ApoA1 ran OK with a decent result on 1 GPU but took a long time to start.

Trying with 2 devices failed!

Checking dmesg had this gem,

```
[163743.056072] process 'kinghorn/NAMD/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3' started with executable stack
[172391.638255] amd_iommu_report_page_fault: 10432 callbacks suppressed
[172391.638261] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d7201180 flags=0x0020]
[172391.638997] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x0 flags=0x0000]
[172391.639356] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4da000000 flags=0x0020]
[172391.639694] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d9c00000 flags=0x0020]
[172391.640066] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d9e00000 flags=0x0020]
[172391.640399] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d9a00000 flags=0x0020]
[172391.640746] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d8133080 flags=0x0020]
[172391.641095] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d77b6000 flags=0x0020]
[172391.641438] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d77b4080 flags=0x0020]
[172391.641785] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x4d953b000 flags=0x0020]
[172391.642520] amd_iommu_int_thread: 27 callbacks suppressed
[172391.642521] AMD-Vi: IOMMU event log overflow
[174844.976879] amd_iommu_report_page_fault: 12950 callbacks suppressed
[174844.976884] amd_iommu_report_page_fault: 501 callbacks suppressed
[174844.976884] nvidia 0000:61:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000b address=0x37001000 flags=0x0020]
[174844.976888] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x1ce01000 flags=0x0020]
[174845.134139] nvidia 0000:61:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000b address=0x0 flags=0x0000]
[174845.155414] nvidia 0000:41:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0018 address=0x0 flags=0x0000]
[175212.226441] NVRM: GPU 0000:41:00.0: RmInitAdapter failed! (0x25:0x65:1461)
[175212.226479] NVRM: GPU 0000:41:00.0: rm_init_adapter failed, device minor number 1
[175216.256771] NVRM: GPU 0000:41:00.0: RmInitAdapter failed! (0x23:0x65:1417)
[175216.256815] NVRM: GPU 0000:41:00.0: rm_init_adapter failed, device minor number 1
[175296.547600] NVRM: GPU 0000:41:00.0: RmInitAdapter failed! (0x23:0x65:1417)
[175296.547647] NVRM: GPU 0000:41:00.0: rm_init_adapter failed, device minor number 1
[175300.547488] NVRM: GPU 0000:41:00.0: RmInitAdapter failed! (0x23:0x65:1417)

```

Also, the second GPU disappeared!

```
kinghorn@trp64:~/NAMD/apoa1$ nvidia-smi
Thu Feb  2 00:39:29 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.60.13    Driver Version: 525.60.13    CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:61:00.0 Off |                  Off |
| 30%   36C    P0    56W / 450W |      0MiB / 24564MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+

```

There are also dmesg entries for most of what I ran.

## From AMD

https://community.amd.com/t5/knowledge-base/iommu-advisory-for-amd-instinct/ta-p/484601

```
Background
The IOMMU virtualizes the address space for the guest environment. Therefore, the GPU and RDMA devices must have the same guest physical address space for the peer-to-peer functionality to work correctly within the guest environment.

However, without the SR-IOV virtualization, the IOMMU gives each device its own Input-Output virtual address space for security on a Bare Metal system.  In this scenario, the peer-to-peer functionality fails because each device identifies a different address space.

Known Impact
If AMD ROCm is installed, the system may report failure or errors when running workloads such as bandwidth test, clinfo, and HelloWord.cl. Note, it may also result in a system crash.

IO PAGE FAULT
IRQ remapping doesn’t support X2APIC mode
NMI error
In a correct ROCm installation, the system must not encounter the errors mentioned above.

Required Action
The Input-Output Memory Management Unit (IOMMU) option must be enabled with the iommu=pt (passthrough) setting.

When Input-Output Memory Management Unit (IOMMU) is enabled, the input-output virtual addresses match the system’s physical addresses. This enables all devices to have the same view of memory and not cause any address remapping issue or page fault.

Addressing Environment-Specific Issues
Enabling IMMOU Passthrough in Ubuntu
Follow the steps below to enable the Input-Output Memory Management Unit (IOMMU) passthrough in Ubuntu.

Add GRUB_CMDLINE_LINUX="amd_iommu=on iommu=pt” to /etc/defaults/grub
Update the boot config file using the following command:
           sudo update-grub

Reboot the system.
```

## With GRUB_CMDLINE_LINUX="amd_iommu=on iommu=pt"

NAMD2 ran OK with both GPUs on ApoA1

But TF1.15 is still hanging!

Different bad output from simple P2P

```
(cuda11.8-22.04)kinghorn@trp64:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./simpleP2P
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 25.08GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 1: val = 0.000000, ref = 4.000000
Verification error @ element 2: val = 0.000000, ref = 8.000000
Verification error @ element 3: val = 0.000000, ref = 12.000000
Verification error @ element 4: val = 0.000000, ref = 16.000000
Verification error @ element 5: val = 0.000000, ref = 20.000000
Verification error @ element 6: val = 0.000000, ref = 24.000000
Verification error @ element 7: val = 0.000000, ref = 28.000000
Verification error @ element 8: val = 0.000000, ref = 32.000000
Verification error @ element 9: val = 0.000000, ref = 36.000000
Verification error @ element 10: val = 0.000000, ref = 40.000000
Verification error @ element 11: val = 0.000000, ref = 44.000000
Verification error @ element 12: val = 0.000000, ref = 48.000000
Disabling peer access...
Shutting down...
Test failed!

```

Another hang!

```
(cuda11.8-22.04)kinghorn@trp64:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel

```

## Systematic testing

- confirm 3000 series are OK or not
- try 4080s
- Does it fail on Xeon?

Check

- simpleP2P
- TF1.15 cnn
- nvidia-smi topo -m
- HPCG
- Namd 2.14
- maybe add pci=nommconf No this did not change anything TF hangs simpleP2P fails

## 3080 + 3080ti

```
kinghorn@trp64:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./simpleP2P
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 3080 Ti (GPU0) -> NVIDIA GeForce RTX 3080 (GPU1) : No
> Peer access from NVIDIA GeForce RTX 3080 (GPU1) -> NVIDIA GeForce RTX 3080 Ti (GPU0) : No
Two or more GPUs with Peer-to-Peer access capability are required for ./simpleP2P.
Peer to Peer access is not available amongst GPUs in the system, waiving test
```

```
kinghorn@trp64:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./simpleMultiGPU
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 14.332000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033

```

### TF 1.15

```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-02 21:54:45.551609:

    10  10.0   180.4  4.163  5.136 1.62000
    20  20.0  1868.7  0.109  1.086 1.24469
    30  30.0  1863.4  0.049  1.029 0.91877
    40  40.0  1870.1  0.309  1.291 0.64222
    50  50.0  1861.5  0.068  1.052 0.41506
    60  60.0  1883.4  0.072  1.058 0.23728
    70  70.0  1893.0  0.036  1.023 0.10889
    80  80.0  1893.8  0.007  0.995 0.02988
    90  90.0  1407.0  0.001  0.988 0.00025

```

Works fine!

### NAMD

Works fine

## Xeon 3365 2 x 4090

```
kinghorn@xeon33:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 24.83GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 1: val = 0.000000, ref = 4.000000
Verification error @ element 2: val = 0.000000, ref = 8.000000
Verification error @ element 3: val = 0.000000, ref = 12.000000
Verification error @ element 4: val = 0.000000, ref = 16.000000
Verification error @ element 5: val = 0.000000, ref = 20.000000
Verification error @ element 6: val = 0.000000, ref = 24.000000
Verification error @ element 7: val = 0.000000, ref = 28.000000
Verification error @ element 8: val = 0.000000, ref = 32.000000
Verification error @ element 9: val = 0.000000, ref = 36.000000
Verification error @ element 10: val = 0.000000, ref = 40.000000
Verification error @ element 11: val = 0.000000, ref = 44.000000
Verification error @ element 12: val = 0.000000, ref = 48.000000
Disabling peer access...
Shutting down...
Test failed!

```

```
kinghorn@xeon33:~/cuda-samples-11.8/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel

```
Hung!

### NAMD 
fine

### TF1.15

```
(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-02 17:10:19.218762:

    10  10.0   144.3  4.240  5.212 1.62000
    20  20.0  2494.6  0.049  1.026 1.24469
    30  30.0  2111.5  0.019  0.997 0.91877
    40  40.0  2136.1  0.131  1.108 0.64222
    50  50.0  2149.8  0.149  1.127 0.41506
    60  60.0  2162.0  0.105  1.085 0.23728
    70  70.0  2135.1  0.032  1.013 0.10889
    80  80.0  2128.1  0.008  0.990 0.02988
    90  90.0  1273.9  0.001  0.983 0.00025

```
Works on Xeon! 

Single 4090 (much slower than on TrPro ??)
```
    10  10.0    77.3  3.199  4.172 1.62000
    20  20.0  1427.1  0.034  1.011 1.24469
    30  30.0  1419.2  0.044  1.024 0.91877
    40  40.0  1426.8  0.113  1.096 0.64222
    50  50.0  1396.6  0.250  1.235 0.41506
    60  60.0  1409.3  0.402  1.390 0.23728
    70  70.0  1409.9  0.252  1.242 0.10889
    80  80.0  1409.0  0.006  0.997 0.02988
    90  90.0   738.6  0.001  0.993 0.00025
```

### PyTorch DDP

```
(pt-ngc22.12)kinghorn@xeon33:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[7073] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[7072] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[7072]: world_size = 2, rank = 0, backend=nccl
[7073]: world_size = 2, rank = 1, backend=nccl
[7072] rank = 0, world_size = 2, n = 1, device_ids = [0]
[7073] rank = 1, world_size = 2, n = 1, device_ids = [1]

```
Works!

### minGPT

```
/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/nn/parallel/_functions.py:68: UserWarning: Was asked to gather along dimension 0, but all input tensors were scalars; will instead unsqueeze and return a vector.
warnings.warn('Was asked to gather along dimension 0, but all '
iter_dt 0.00ms; iter 0: train loss 2.11314
Traceback (most recent call last):
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py", line 144, in <module>
trainer.run()
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/trainer.py", line 109, in run
self.trigger_callbacks('on_batch_end')
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/trainer.py", line 61, in trigger_callbacks
callback(self)
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py", line 131, in batch_end_callback
y = model.generate(x, 500, temperature=1.0, do_sample=True, top_k=10)[0]
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/autograd/grad_mode.py", line 27, in decorate_context
return func(*args, **kwargs)
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/model.py", line 303, in generate
idx_next = torch.multinomial(probs, num_samples=1)
RuntimeError: probability tensor contains either `inf`, `nan` or element < 0

```

#### On my dual Titan V Runs fine
```
kinghorn@i9:~/git/PugetBench-minGPT/PyInstaller/testing$ ./pugetbench-mingpt -i 501 -b 64 --parallel 

Running mm/envs/pytorch/bin/python -u /home/kinghorn/git/PugetBench-minGPT/PyInstaller/testing/chargpt.py --trainer.max_iters=501 --model.model_type='gpt2' --trainer.batch_size=64 --trainer.data_parallel=True
command line overwriting config attribute trainer.max_iters with 501
command line overwriting config attribute model.model_type with gpt2
command line overwriting config attribute trainer.batch_size with 64
command line overwriting config attribute trainer.data_parallel with True
system:
seed: 3407
work_dir: ./out/chargpt
data:
block_size: 128
model:
model_type: gpt2
n_layer: None
n_head: None
n_embd: None
vocab_size: None
block_size: None
embd_pdrop: 0.1
resid_pdrop: 0.1
attn_pdrop: 0.1
trainer:
device: auto
num_workers: 4
max_iters: 501
batch_size: 64
learning_rate: 0.0005
betas: (0.9, 0.95)
weight_decay: 0.1
grad_norm_clip: 1.0
data_parallel: True

data has 1115394 characters, 65 unique.
number of parameters: 85.20M
running on device cuda
/home/kinghorn/git/PugetBench-minGPT/PyInstaller/testing/mm/envs/pytorch/lib/python3.10/site-packages/torch/nn/parallel/_functions.py:68: UserWarning: Was asked to gather along dimension 0, but all input tensors were scalars; will instead unsqueeze and return a vector.
warnings.warn('Was asked to gather along dimension 0, but all '
iter_dt 0.00ms; iter 0: train loss 4.22839
be still and wonder                   t      o                         r  e a   a                                 r    t          a                                                            e                                      e                   e                     o                                   o                  a    t    e                                            o               l                        a      h  h     a             s                                      a
saving model
iter_dt 368.87ms; iter 10: train loss 3.50013
iter_dt 368.38ms; iter 20: train loss 3.37611
iter_dt 366.16ms; iter 30: train loss 3.33953
iter_dt 366.67ms; iter 40: train loss 3.22233
iter_dt 379.88ms; iter 50: train loss 3.10308
iter_dt 366.45ms; iter 60: train loss 3.05539
iter_dt 367.14ms; iter 70: train loss 2.99545
iter_dt 408.59ms; iter 80: train loss 2.84831
iter_dt 401.21ms; iter 90: train loss 2.76619
iter_dt 369.27ms; iter 100: train loss 2.66417
iter_dt 368.22ms; iter 110: train loss 2.63144
iter_dt 366.11ms; iter 120: train loss 2.57963
iter_dt 368.90ms; iter 130: train loss 2.54607
iter_dt 370.10ms; iter 140: train loss 2.53407
iter_dt 386.92ms; iter 150: train loss 2.49409
iter_dt 378.54ms; iter 160: train loss 2.47825
iter_dt 367.95ms; iter 170: train loss 2.47552
iter_dt 368.56ms; iter 180: train loss 2.44171
iter_dt 367.85ms; iter 190: train loss 2.44302
iter_dt 366.58ms; iter 200: train loss 2.41485
iter_dt 367.92ms; iter 210: train loss 2.44899
iter_dt 369.99ms; iter 220: train loss 2.41701
iter_dt 368.97ms; iter 230: train loss 2.40626
iter_dt 395.35ms; iter 240: train loss 2.37477
iter_dt 381.70ms; iter 250: train loss 2.29669
iter_dt 366.50ms; iter 260: train loss 2.27065
iter_dt 366.35ms; iter 270: train loss 2.26414
iter_dt 366.09ms; iter 280: train loss 2.21365
iter_dt 366.39ms; iter 290: train loss 2.17222
iter_dt 366.53ms; iter 300: train loss 2.14192
iter_dt 366.27ms; iter 310: train loss 2.11837
iter_dt 366.29ms; iter 320: train loss 2.07027
iter_dt 366.38ms; iter 330: train loss 2.04656
iter_dt 366.41ms; iter 340: train loss 2.04836
iter_dt 367.81ms; iter 350: train loss 2.00766
iter_dt 368.83ms; iter 360: train loss 1.99114
iter_dt 368.14ms; iter 370: train loss 1.99154
iter_dt 366.15ms; iter 380: train loss 1.99128
iter_dt 397.27ms; iter 390: train loss 1.94602
iter_dt 366.54ms; iter 400: train loss 1.92903
iter_dt 371.84ms; iter 410: train loss 1.90350
iter_dt 383.16ms; iter 420: train loss 1.88398
iter_dt 371.93ms; iter 430: train loss 1.86469
iter_dt 368.20ms; iter 440: train loss 1.85438
iter_dt 366.47ms; iter 450: train loss 1.83566
iter_dt 385.64ms; iter 460: train loss 1.84064
iter_dt 368.20ms; iter 470: train loss 1.83693
iter_dt 368.51ms; iter 480: train loss 1.76333
iter_dt 366.49ms; iter 490: train loss 1.80692
iter_dt 369.80ms; iter 500: train loss 1.76513
be still and wondert it.

CLIOLONELUS:
What, I a haph! hy would but it which thee fut atchil.

LUCIO:
To houghty hourtherer hearth offire and brear:
Or, mut shard, must in my fage,
Then booth, are heers to for them on in foind me;
If they fall me them; and the are bried
And sir, shire, as besthy lives wars, minds
slave as bucked have facke my betth frems,
And thus that but thentery.
With I serve-heir as baske.
That what should thems; fat thave of that,
And foor hath ble foorish bast a a hearth,
Of to-all swork, ma
saving model
****************************************************************
* Time = 196.81 seconds for 501 iterations, batchsize 64 
****************************************************************

```

### CUDA 12.0

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel
```
Hang!

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 6.086000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 
```
Works

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 24.90GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 1: val = 0.000000, ref = 4.000000
Verification error @ element 2: val = 0.000000, ref = 8.000000
Verification error @ element 3: val = 0.000000, ref = 12.000000
Verification error @ element 4: val = 0.000000, ref = 16.000000
Verification error @ element 5: val = 0.000000, ref = 20.000000
Verification error @ element 6: val = 0.000000, ref = 24.000000
Verification error @ element 7: val = 0.000000, ref = 28.000000
Verification error @ element 8: val = 0.000000, ref = 32.000000
Verification error @ element 9: val = 0.000000, ref = 36.000000
Verification error @ element 10: val = 0.000000, ref = 40.000000
Verification error @ element 11: val = 0.000000, ref = 44.000000
Verification error @ element 12: val = 0.000000, ref = 48.000000
Disabling peer access...
Shutting down...
Test failed!
```

### HPL Xeon 2x4090
```
export MELLANOX_VISIBLE_DEVICES="none"

(hpl-ngc)kinghorn@xeon33:/workspace/hpl-linux-x86_64$ CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1
INFO: host=xeon33 rank=0 lrank=0 cores=4 gpu=0 cpu=0 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl
INFO: host=xeon33 rank=1 lrank=1 cores=4 gpu=1 cpu=1 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl

================================================================================
HPL-NVIDIA 1.0.0  -- NVIDIA accelerated HPL benchmark -- NVIDIA
================================================================================
HPLinpack 2.1  --  High-Performance Linpack benchmark  --   October 26, 2012
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

N      :   72000 
NB     :     288 
PMAP   : Row-major process mapping
P      :       1 
Q      :       2 
PFACT  :    Left 
NBMIN  :       2 
NDIV   :       2 
RFACT  :    Left 
BCAST  :  2ringM 
DEPTH  :       1 
SWAP   : Spread-roll (long)
L1     : no-transposed form
U      : transposed form
EQUIL  : no
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

trsm_cutoff from environment variable 9000000 
gpu_dgemm_split from environment variable 1.000 
monitor_gpu from environment variable 1 
gpu_temp_warning from environment variable 78 
gpu_clock_warning from environment variable 1410 
gpu_power_warning from environment variable 400 
max_h2d_ms from environment variable 200 
max_d2h_ms from environment variable 200 
gpu_pcie_gen_warning from environment variable 3 
gpu_pcie_width_warning from environment variable 2 
test_loops from environment variable 1 
test_system from environment variable 1 

	******** TESTING SYSTEM PARAMETERS ********
	PARAM 	[UNITS] 	MIN 	MAX 	AVG 
	----- 	------- 	--- 	--- 	--- 
CPU : 
	CPU_BW	[GB/s ] 	18.0 	18.3 	18.2 
	CPU_FP	[GFLPS] 
	     	NB =   32 	  35 	  37 	  36 
	     	NB =   64 	  44 	  46 	  45 
	     	NB =  128 	  71 	  73 	  72 
	     	NB =  256 	  85 	  85 	  85 
	     	NB =  512 	  90 	  90 	  90 
PCIE (NVLINK on IBM) : 
	H2D_BW	[GB/s ] 	23.6 	24.3 	24.0 
	D2H_BW	[GB/s ] 	25.5 	25.5 	25.5 
	BID_BW	[GB/s ] 	42.4 	42.4 	42.4 
CPU_BW concurrent with BID_BW : 
	CPU_BW	[GB/s ] 	11.6 	11.6 	11.6 
	BID_BW	[GB/s ] 	44.1 	44.1 	44.1 
GPU : 
	GPU_BW	[GB/s ] 	920 	920 	920 
	GPU_FP	[GFLPS] 
!!!! WARNING: RANK: 1 HOST: xeon33 GPU: 0000:c3:00.0 	GPU_FP 	[GFLPS] @NB= 128	 935 
	     	NB =  128 	 935 	1160 	1047 
	     	NB =  256 	1183 	1202 	1192 
	     	NB =  384 	1190 	1210 	1200 
	     	NB =  512 	1193 	1213 	1203 
	     	NB =  640 	1195 	1214 	1204 
	     	NB =  768 	1196 	1215 	1206 
	     	NB =  896 	1197 	1216 	1206 
	     	NB = 1024 	1197 	1217 	1207 
NET : 
	PROC COL NET_BW	[MB/s ] 
		     8 B  	 101 	 112 	 107 
		    64 B  	 935 	 937 	 936 
		   512 B  	4928 	4948 	4938 
		     4 KB 	24212 	24404 	24308 
		    32 KB 	33229 	33681 	33455 
		   256 KB 	22838 	23573 	23206 
		  2048 KB 	15057 	15576 	15316 
		 16384 KB 	12391 	12480 	12435 
	NET_LAT	[ us  ] 	0.0 	0.0 	0.0 

	PROC ROW NET_BW	[MB/s ] 
		     8 B  	  68 	  68 	  68 
		    64 B  	 475 	 475 	 475 
		   512 B  	1847 	1847 	1847 
		     4 KB 	7097 	7097 	7097 
		    32 KB 	15966 	15966 	15966 
		   256 KB 	22683 	22684 	22684 
		  2048 KB 	15684 	15685 	15684 
		 16384 KB 	12635 	12635 	12635 
	NET_LAT	[ us  ] 	0.4 	0.4 	0.4 

displaying Prog:%complete, N:columns, Time:seconds
iGF:instantaneous GF, GF:avg GF, GF_per: process GF


Per-Process Host Memory Estimate: 20.99 GB (MAX) 20.99 GB (MIN)

PCOL: 0 GPU_COLS: 36001 CPU_COLS: 0 
PCOL: 1 GPU_COLS: 36001 CPU_COLS: 0 
2023-02-03 12:08:02.125
 Prog= 2.38%	N_left= 71424	Time= 2.74	Time_left= 112.24	iGF=  2164.20	GF=  2164.20	iGF_per= 1082.10 	GF_per= 1082.10 
 Prog= 3.56%	N_left= 71136	Time= 3.98	Time_left= 108.04	iGF=  2346.58	GF=  2221.29	iGF_per= 1173.29 	GF_per= 1110.64 
 Prog= 4.72%	N_left= 70848	Time= 5.19	Time_left= 104.75	iGF=  2401.28	GF=  2263.19	iGF_per= 1200.64 	GF_per= 1131.59 
 Prog= 7.03%	N_left= 70272	Time= 7.61	Time_left= 100.71	iGF=  2370.14	GF=  2297.18	iGF_per= 1185.07 	GF_per= 1148.59 
 Prog= 8.17%	N_left= 69984	Time= 8.82	Time_left= 99.19	iGF=  2345.58	GF=  2303.81	iGF_per= 1172.79 	GF_per= 1151.90 

 Prog= 91.25%	N_left= 31968	Time= 96.20	Time_left= 9.23	iGF=  2354.89	GF=  2360.22	iGF_per= 1177.45 	GF_per= 1180.11 
 Prog= 92.38%	N_left= 30528	Time= 97.40	Time_left= 8.04	iGF=  2348.65	GF=  2360.08	iGF_per= 1174.33 	GF_per= 1180.04 
 Prog= 93.41%	N_left= 29088	Time= 98.52	Time_left= 6.95	iGF=  2278.42	GF=  2359.14	iGF_per= 1139.21 	GF_per= 1179.57 
 Prog= 94.34%	N_left= 27648	Time= 99.55	Time_left= 5.97	iGF=  2260.00	GF=  2358.12	iGF_per= 1130.00 	GF_per= 1179.06 
 Prog= 95.18%	N_left= 26208	Time= 100.54	Time_left= 5.09	iGF=  2092.93	GF=  2355.49	iGF_per= 1046.47 	GF_per= 1177.75 
 Prog= 95.93%	N_left= 24768	Time= 101.34	Time_left= 4.30	iGF=  2338.23	GF=  2355.35	iGF_per= 1169.12 	GF_per= 1177.68 
 Prog= 96.60%	N_left= 23328	Time= 102.10	Time_left= 3.59	iGF=  2217.47	GF=  2354.34	iGF_per= 1108.74 	GF_per= 1177.17 
 Prog= 97.19%	N_left= 21888	Time= 102.83	Time_left= 2.97	iGF=  1998.72	GF=  2351.79	iGF_per= 999.36 	GF_per= 1175.90 
 Prog= 99.15%	N_left= 14688	Time= 105.93	Time_left= 0.91	iGF=  1577.47	GF=  2329.19	iGF_per= 788.74 	GF_per= 1164.59 
 Prog= 99.89%	N_left= 7488	Time= 108.63	Time_left= 0.12	iGF=   677.19	GF=  2288.03	iGF_per= 338.60 	GF_per= 1144.02 
 Prog= 100.00%	N_left= 288	Time= 110.43	Time_left= 0.00	iGF=   155.56	GF=  2253.29	iGF_per= 77.78 	GF_per= 1126.64 
2023-02-03 12:09:53.335
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             111.21              2.238e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0029328 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

## dual A6000 Ada

### cuda 12
```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA RTX 6000 Ada Generation (GPU0) -> NVIDIA RTX 6000 Ada Generation (GPU1) : Yes
> Peer access from NVIDIA RTX 6000 Ada Generation (GPU1) -> NVIDIA RTX 6000 Ada Generation (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 24.47GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Disabling peer access...
Shutting down...
Test passed

```
Works!

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 5.073000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 

```
Works!

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ls
conjugateGradientMultiDeviceCG  p2pBandwidthLatencyTest  simpleMultiGPU  simpleP2P
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA RTX 6000 Ada Generation" with compute capability 8.9
GPU Device 1: "NVIDIA RTX 6000 Ada Generation" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 145408 numBlocksPerSm  = 2
Launching kernel
GPU Final, residual = 7.160786e-06 
  Test Summary:  Error amount = 0.000000 
&&&& conjugateGradientMultiDeviceCG PASSED

```
Works!
```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest 
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA RTX 6000 Ada Generation, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA RTX 6000 Ada Generation, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CAN Access Peer Device=1
Device=1 CAN Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     1
     1	     1     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 791.14  22.23 
     1  22.09 802.93 
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1 
     0 792.34  26.31 
     1  27.02 816.35 
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 796.58  30.72 
     1  30.72 802.52 
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 798.01  51.12 
     1  51.10 798.21 
P2P=Disabled Latency Matrix (us)
   GPU     0      1 
     0   2.96  10.84 
     1  11.07   2.93 

   CPU     0      1 
     0   1.83   5.45 
     1   5.44   1.79 
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1 
     0   2.97   1.29 
     1   1.28   2.94 

   CPU     0      1 
     0   1.84   1.45 
     1   1.45   1.85 

```

### TF 1.15
```
CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16

   10  10.0   155.3  4.128  5.100 1.62000
    20  20.0   664.1  0.075  1.053 1.24469
    30  30.0   684.6  0.000  0.975 0.91877
    40  40.0   711.6  0.000  0.965 0.64222
    50  50.0   718.9  0.000  0.956 0.41506
    60  60.0   720.1  0.000  0.950 0.23728
    70  70.0   731.0  0.000  0.947 0.10889
    80  80.0   737.9  0.000  0.946 0.02988
    90  90.0   656.3  0.000  0.945 0.00025

CUDA_VISIBLE_DEVICES=0 mpiexec -np 1 python resnet.py --layers=50 --batch_size=128 --precision=fp16

    10  10.0    80.8  3.341  4.313 1.62000
    20  20.0   362.8  0.062  1.038 1.24469
    30  30.0   365.0  0.044  1.024 0.91877
    40  40.0   365.5  0.065  1.048 0.64222
    50  50.0   363.6  0.718  1.704 0.41506
    60  60.0   362.2  0.206  1.195 0.23728
    70  70.0   363.5  0.193  1.184 0.10889
    80  80.0   362.2  0.119  1.111 0.02988
    90  90.0   328.8  0.001  0.994 0.00025

```

### NAMD
```
../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 128 CPUs 0.00200589 s/step 0.0232164 days/ns 1024.83 MB memory
TIMING: 500  CPU: 1.12529, 0.00197155/step  Wall: 1.13206, 0.00197171/step, 0 hours remaining, 1024.828125 MB of memory in use.
ENERGY:     500     20974.9307     19756.5679      5724.4551       179.8313        -337740.3224     23250.8212         0.0000         0.0000     45358.7933        -222494.9229       165.0028   -267853.7162   -222060.6034       163.5308          -3197.5262     -2425.3695    921491.4634     -2247.8996     -2323.0803

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.002 seconds, 1035.184 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.001 seconds, 1035.184 MB of memory in use
====================================================

1 GPU
Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 128 CPUs 0.00278843 s/step 0.0322735 days/ns 775.414 MB memory
TIMING: 500  CPU: 1.50276, 0.0029124/step  Wall: 1.51125, 0.00276961/step, 0 hours remaining, 775.414062 MB of memory in use.
ENERGY:     500     20974.9402     19756.6152      5724.4563       179.8314        -337740.4908     23251.0121         0.0000         0.0000     45358.7561        -222494.8795       165.0027   -267853.6355   -222060.5607       163.5309          -3197.4649     -2425.3127    921491.4634     -2247.8670     -2323.0477

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.002 seconds, 784.977 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.002 seconds, 784.977 MB of memory in use
====================================================

WallClock: 4.995598  CPUTime: 2.750659  Memory: 784.976562 MB

```

### HPL NGC
```
CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

!!!! WARNING: Rank: 1 : trp64 : GPU 0000:61:00.0 	Clock: 626 MHz 	Temp: 61 C 	Power: 76 W 	PCIe  gen 4 	 x16 
 Prog= 97.19%	N_left= 21888	Time= 424.11	Time_left= 12.26	iGF=   573.48	GF=   570.24	iGF_per= 286.74 	GF_per= 285.12 
!!!! WARNING: Rank: 0 : trp64 : GPU 0000:41:00.0 	Clock: 626 MHz 	Temp: 62 C 	Power: 71 W 	PCIe  gen 4 	 x16 
!!!! WARNING: Rank: 1 : trp64 : GPU 0000:61:00.0 	Clock: 626 MHz 	Temp: 61 C 	Power: 76 W 	PCIe  gen 4 	 x16 
!!!! WARNING: Rank: 0 : trp64 : GPU 0000:41:00.0 	Clock: 626 MHz 	Temp: 62 C 	Power: 71 W 	PCIe  gen 4 	 x16 
 Prog= 99.15%	N_left= 14688	Time= 432.77	Time_left= 3.71	iGF=   563.00	GF=   570.09	iGF_per= 281.50 	GF_per= 285.05 
!!!! WARNING: Rank: 1 : trp64 : GPU 0000:61:00.0 	Clock: 626 MHz 	Temp: 61 C 	Power: 76 W 	PCIe  gen 4 	 x16 
 Prog= 99.89%	N_left= 7488	Time= 436.23	Time_left= 0.49	iGF=   529.89	GF=   569.77	iGF_per= 264.94 	GF_per= 284.89 
!!!! WARNING: Rank: 0 : trp64 : GPU 0000:41:00.0 	Clock: 626 MHz 	Temp: 62 C 	Power: 63 W 	PCIe  gen 4 	 x16 
 Prog= 100.00%	N_left= 288	Time= 438.14	Time_left= 0.00	iGF=   146.49	GF=   567.93	iGF_per= 73.24 	GF_per= 283.96 
2023-02-04 00:03:23.166
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             438.75              5.672e+02 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0029996 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

### PyTorch DDP
```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[6157] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[6156] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[6156]: world_size = 2, rank = 0, backend=nccl[6157]: world_size = 2, rank = 1, backend=nccl

[6157] rank = 1, world_size = 2, n = 1, device_ids = [1]
[6156] rank = 0, world_size = 2, n = 1, device_ids = [0]

```
Works!

### minGPT
```
kinghorn@trp64:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64

saving model
****************************************************************
* Time = 332.01 seconds for 501 iterations, batchsize 64 
****************************************************************

```

## ReDo 2 x 4090 on TrPro with new driver
```
kinghorn@trp64:~$ nvidia-smi 
Mon Feb  6 16:20:20 2023       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.85.05    Driver Version: 525.85.05    CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:41:00.0 Off |                  Off |
|  0%   45C    P8    16W / 450W |      1MiB / 24564MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce ...  Off  | 00000000:61:00.0 Off |                  Off |
|  0%   45C    P8     7W / 450W |      1MiB / 24564MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

kinghorn@trp64:~$ nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: GPU-dce3c608-a465-4502-5ff9-9bdafd440a84)
GPU 1: NVIDIA GeForce RTX 4090 (UUID: GPU-9db283bb-bdb7-fd4e-d79a-4a2688240641)

```
## Tests
- simpleP2P
- simpleMulitGPU
- conjugateGradientMultiDeviceCG
- p2pBandwidthLatencyTest

- TF 1.15
- NAMD ApoA1
- HPL NGC
- PyTorch DDP
- minGPT

### CUDA 12

```
kinghorn@trp64:~$ export ENROOT_MOUNT_HOME=y
kinghorn@trp64:~$ enroot start --rw cuda12-20.04

==========
== CUDA ==
==========

CUDA Version 12.0.0
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 25.07GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 1: val = 0.000000, ref = 4.000000
Verification error @ element 2: val = 0.000000, ref = 8.000000
Verification error @ element 3: val = 0.000000, ref = 12.000000
Verification error @ element 4: val = 0.000000, ref = 16.000000
Verification error @ element 5: val = 0.000000, ref = 20.000000
Verification error @ element 6: val = 0.000000, ref = 24.000000
Verification error @ element 7: val = 0.000000, ref = 28.000000
Verification error @ element 8: val = 0.000000, ref = 32.000000
Verification error @ element 9: val = 0.000000, ref = 36.000000
Verification error @ element 10: val = 0.000000, ref = 40.000000
Verification error @ element 11: val = 0.000000, ref = 44.000000
Verification error @ element 12: val = 0.000000, ref = 48.000000
Disabling peer access...
Shutting down...
Test failed!
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 4.833000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel

Hung!
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest 
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 4090, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 4090, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CAN Access Peer Device=1
Device=1 CAN Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     1
     1	     1     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 912.14  22.08 
     1  22.09 919.12 
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1 
     0 910.55  27.07 
     1  26.91 919.66 
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 916.96  30.98 
     1  30.75 922.65 
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 918.04  54.12 
     1  54.12 923.09 
P2P=Disabled Latency Matrix (us)
   GPU     0      1 
     0   1.32  10.48 
     1  10.49   1.41 

   CPU     0      1 
     0   1.85   5.53 
     1   5.53   1.82 
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1 
     0   1.38   0.87 
     1   0.87   1.42 

   CPU     0      1 
     0   1.88   1.46 
     1   1.46   1.83 

NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.

```

### TF 1.15
```
kinghorn@trp64:~$ export MELLANOX_VISIBLE_DEVICES="none"
kinghorn@trp64:~$ enroot start --rw tf1.15-ngc

================
== TensorFlow ==
================

NVIDIA Release 23.01-tf1 (build 52295116)
TensorFlow Version 1.15.5
```

```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16

2023-02-06 16:45:53.026821: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 16:45:53.026821: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
...

```
Hung! saved output dump

### NAMD ApoA1
```
kinghorn@trp64:~/NAMD/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

...
Pe 32 physical rank 32 binding to CUDA device 0 on trp64: 'NVIDIA GeForce RTX 4090'  Mem: 24214MB  Rev: 8.9  PCI: 0:41:0
Pe 64 physical rank 64 binding to CUDA device 1 on trp64: 'NVIDIA GeForce RTX 4090'  Mem: 24217MB  Rev: 8.9  PCI: 0:61:0
...
Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 128 CPUs 0.00125899 s/step 0.0145717 days/ns 1054.31 MB memory
TIMING: 500  CPU: 0.748998, 0.0013449/step  Wall: 0.752146, 0.0012639/step, 0 hours remaining, 1054.308594 MB of memory in use.
ENERGY:     500     20974.9307     19756.5779      5724.4564       179.8311        -337740.3598     23250.9277         0.0000         0.0000     45358.7442        -222494.8918       165.0026   -267853.6360   -222060.5719       163.5308          -3197.4911     -2425.3297    921491.4634     -2247.8955     -2323.0748

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.002 seconds, 1065.066 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.001 seconds, 1065.066 MB of memory in use
====================================================

WallClock: 6.560733  CPUTime: 2.014908  Memory: 1065.066406 MB
[Partition 0][Node 0] End of program
```

### HPL NGC
```
kinghorn@trp64:~$ enroot start --rw hpl-ngc
NOTE: MOFED driver for multi-node communication was not detected.
      Multi-node communication performance may be reduced.

(hpl-ngc)kinghorn@trp64:/workspace$ ls
hpl-ai-linux-x86_64  hpl-linux-x86_64  hpl.sh  third_party.txt
(hpl-ngc)kinghorn@trp64:/workspace$ cd hpl-linux-x86_64/
(hpl-ngc)kinghorn@trp64:/workspace/hpl-linux-x86_64$ ls
COPYRIGHT-HPL-2.1  HPL.dat  README  RUNNING  TUNING  hpl.sh  sample-dat  sample-slurm  xhpl
```
```
(hpl-ngc)kinghorn@trp64:/workspace/hpl-linux-x86_64$ CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1
INFO: host=trp64 rank=0 lrank=0 cores=4 gpu=0 cpu=0 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl
INFO: host=trp64 rank=1 lrank=1 cores=4 gpu=1 cpu=1 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl

================================================================================
HPL-NVIDIA 1.0.0  -- NVIDIA accelerated HPL benchmark -- NVIDIA
================================================================================
...
PCOL: 1 GPU_COLS: 36001 CPU_COLS: 0 
PCOL: 0 GPU_COLS: 36001 CPU_COLS: 0 
2023-02-06 17:25:38.258
 Prog= 2.38%	N_left= 71424	Time= 2.77	Time_left= 113.59	iGF=  2138.54	GF=  2138.54	iGF_per= 1069.27 	GF_per= 1069.27 
 Prog= 3.56%	N_left= 71136	Time= 4.03	Time_left= 109.19	iGF=  2328.85	GF=  2197.93	iGF_per= 1164.43 	GF_per= 1098.97 
 Prog= 4.72%	N_left= 70848	Time= 5.24	Time_left= 105.79	iGF=  2383.48	GF=  2241.02	iGF_per= 1191.74 	GF_per= 1120.51 
 Prog= 7.03%	N_left= 70272	Time= 7.68	Time_left= 101.63	iGF=  2352.17	GF=  2276.29	iGF_per= 1176.09 	GF_per= 1138.15 
 Prog= 8.17%	N_left= 69984	Time= 8.90	Time_left= 100.07	iGF=  2328.63	GF=  2283.45	iGF_per= 1164.32 	GF_per= 1141.72 
 Prog= 9.30%	N_left= 69696	Time= 10.08	Time_left= 98.34	iGF=  2383.86	GF=  2295.19	iGF_per= 1191.93 	GF_per= 1147.60 
...
2023-02-06 17:27:29.065
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             110.81              2.246e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0028573 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================
```

### PyTorch DDP
```
kinghorn@trp64:~$ enroot start --rw pytorch-ngc-22.12

=============
== PyTorch ==
=============

NVIDIA Release 22.12 (build 49968248)
PyTorch Version 1.14.0a0+410ce96
```

```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$  python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[9352] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[9351] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[9351]: world_size = 2, rank = 0, backend=nccl
[9352]: world_size = 2, rank = 1, backend=nccl
[9351] rank = 0, world_size = 2, n = 1, device_ids = [0]
[9352] rank = 1, world_size = 2, n = 1, device_ids = [1]

```
Hangs!

### minGPT
```
kinghorn@trp64:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64
Running mm/envs/pytorch/bin/python -u /home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py --trainer.max_iters=501 --model.model_type='gpt2' --trainer.batch_size=64 --trainer.data_parallel=True
command line overwriting config attribute trainer.max_iters with 501
command line overwriting config attribute model.model_type with gpt2
command line overwriting config attribute trainer.batch_size with 64
command line overwriting config attribute trainer.data_parallel with True
system:
seed: 3407
work_dir: ./out/chargpt
data:
block_size: 128
model:
model_type: gpt2
n_layer: None
n_head: None
n_embd: None
vocab_size: None
block_size: None
embd_pdrop: 0.1
resid_pdrop: 0.1
attn_pdrop: 0.1
trainer:
device: auto
num_workers: 4
max_iters: 501
batch_size: 64
learning_rate: 0.0005
betas: (0.9, 0.95)
weight_decay: 0.1
grad_norm_clip: 1.0
data_parallel: True

data has 1115394 characters, 65 unique.
number of parameters: 85.20M
running on device cuda
/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/nn/parallel/_functions.py:68: UserWarning: Was asked to gather along dimension 0, but all input tensors were scalars; will instead unsqueeze and return a vector.
warnings.warn('Was asked to gather along dimension 0, but all '

```
Hangs!


## ReDo 2 x 3090 on Tr Pro with new driver
```
kinghorn@trp64:~$ nvidia-smi 
Mon Feb  6 23:12:40 2023       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.85.05    Driver Version: 525.85.05    CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:41:00.0 Off |                  N/A |
|  0%   43C    P8    19W / 350W |      1MiB / 24576MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce ...  Off  | 00000000:61:00.0 Off |                  N/A |
|  0%   40C    P8    10W / 350W |      1MiB / 24576MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
kinghorn@trp64:~$ nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 3090 (UUID: GPU-6987a197-dc45-2fc2-faff-051a86ff1081)
GPU 1: NVIDIA GeForce RTX 3090 (UUID: GPU-0ed09d2f-e9e6-3124-382b-c3eaf80ba6ee)

```
## Tests
- simpleP2P
- simpleMulitGPU
- conjugateGradientMultiDeviceCG
- p2pBandwidthLatencyTest

- TF 1.15
- NAMD ApoA1
- HPL NGC
- PyTorch DDP
- minGPT

### CUDA 12

```
kinghorn@trp64:~$ export ENROOT_MOUNT_HOME=y
kinghorn@trp64:~$ enroot start --rw cuda12-20.04

==========
== CUDA ==
==========

CUDA Version 12.0.0
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 3090 (GPU0) -> NVIDIA GeForce RTX 3090 (GPU1) : No
> Peer access from NVIDIA GeForce RTX 3090 (GPU1) -> NVIDIA GeForce RTX 3090 (GPU0) : No
Two or more GPUs with Peer-to-Peer access capability are required for ./simpleP2P.
Peer to Peer access is not available amongst GPUs in the system, waiving test.
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 14.424000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 3090" with compute capability 8.6
GPU Device 1: "NVIDIA GeForce RTX 3090" with compute capability 8.6
Device=0 CANNOT Access Peer Device=1
Ignoring device 1 (max devices exceeded)
Devices involved are not p2p capable.. selecting 2 of them

Running on GPUs = 2
Total threads per GPU = 83968 numBlocksPerSm  = 2
Launching kernel
GPU Final, residual = 7.160786e-06 
  Test Summary:  Error amount = 0.000000 
&&&& conjugateGradientMultiDeviceCG PASSED
```

```
(cuda12-20.04)kinghorn@trp64:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest 
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 3090, pciBusID: 41, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 3090, pciBusID: 61, pciDeviceID: 0, pciDomainID:0
Device=0 CANNOT Access Peer Device=1
Device=1 CANNOT Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     0
     1	     0     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 829.35  11.17 
     1  11.42 830.63 
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1 
     0 830.23  11.29 
     1  11.36 832.89 
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 838.93  16.67 
     1  16.81 838.93 
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 838.93  16.53 
     1  16.60 838.93 
P2P=Disabled Latency Matrix (us)
   GPU     0      1 
     0   1.59  11.53 
     1  10.29   1.51 

   CPU     0      1 
     0   1.83   5.46 
     1   5.47   1.77 
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1 
     0   1.58  10.36 
     1  10.67   1.52 

   CPU     0      1 
     0   1.82   5.45 
     1   5.43   1.76 

```

## TF 1.15
```
kinghorn@trp64:~$ export MELLANOX_VISIBLE_DEVICES="none"
kinghorn@trp64:~$ enroot start --rw tf1.15-ngc

================
== TensorFlow ==
================

NVIDIA Release 23.01-tf1 (build 52295116)
TensorFlow Version 1.15.5
```

```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-06 23:21:57.726284: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 23:21:57.726287: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12

    10  10.0   182.3  4.135  5.108 1.62000
    20  20.0  2043.1  0.166  1.144 1.24469
    30  30.0  2048.4  0.082  1.063 0.91877
    40  40.0  2044.0  0.102  1.084 0.64222
    50  50.0  2040.3  0.106  1.090 0.41506
    60  60.0  2044.4  0.090  1.075 0.23728
    70  70.0  2042.2  0.015  1.002 0.10889
    80  80.0  2040.1  0.006  0.993 0.02988
    90  90.0  1488.5  0.001  0.987 0.00025

```

## NAMD ApoA1
```
kinghorn@trp64:~/NAMD/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

Pe 32 physical rank 32 binding to CUDA device 0 on trp64: 'NVIDIA GeForce RTX 3090'  Mem: 24256MB  Rev: 8.6  PCI: 0:41:0
Pe 64 physical rank 64 binding to CUDA device 1 on trp64: 'NVIDIA GeForce RTX 3090'  Mem: 24259MB  Rev: 8.6  PCI: 0:61:0

Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 128 CPUs 0.00132776 s/step 0.0153676 days/ns 1030.36 MB memory
TIMING: 500  CPU: 0.776244, 0.0014684/step  Wall: 0.782063, 0.00134808/step, 0 hours remaining, 1030.359375 MB of memory in use.
ENERGY:     500     20974.9546     19756.5627      5724.4552       179.8312        -337740.4782     23250.9651         0.0000         0.0000     45358.8098        -222494.8995       165.0029   -267853.7094   -222060.5812       163.5309          -3197.5046     -2425.3348    921491.4634     -2247.8821     -2323.0623

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.002 seconds, 1041.738 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.009 seconds, 1041.738 MB of memory in use
====================================================

WallClock: 6.373582  CPUTime: 2.041474  Memory: 1041.738281 MB
```

## HPL NGC
```
export MELLANOX_VISIBLE_DEVICES="none"
kinghorn@trp64:~/NAMD/apoa1$ enroot start --rw hpl-ngc
NOTE: MOFED driver for multi-node communication was not detected.
      Multi-node communication performance may be reduced.

CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

Per-Process Host Memory Estimate: 20.99 GB (MAX) 20.99 GB (MIN)

PCOL: 1 GPU_COLS: 36001 CPU_COLS: 0 
PCOL: 0 GPU_COLS: 36001 CPU_COLS: 0 
2023-02-06 23:36:07.859
 Prog= 2.38%	N_left= 71424	Time= 5.66	Time_left= 232.22	iGF=  1046.00	GF=  1046.00	iGF_per= 523.00 	GF_per= 523.00 
 Prog= 3.56%	N_left= 71136	Time= 8.36	Time_left= 226.77	iGF=  1083.97	GF=  1058.26	iGF_per= 541.99 	GF_per= 529.13 
 Prog= 4.72%	N_left= 70848	Time= 11.00	Time_left= 221.84	iGF=  1101.74	GF=  1068.68	iGF_per= 550.87 	GF_per= 534.34 
 Prog= 7.03%	N_left= 70272	Time= 16.24	Time_left= 214.88	iGF=  1093.28	GF=  1076.62	iGF_per= 546.64 	GF_per= 538.31 

2023-02-06 23:40:01.089
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             233.23              1.067e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0028030 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================
```

## PyTorch DDP
```
kinghorn@trp64:~$ enroot start --rw pytorch-ngc-22.12

=============
== PyTorch ==
=============

NVIDIA Release 22.12 (build 49968248)
PyTorch Version 1.14.0a0+410ce96
```

```
(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$  python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2

(pytorch-ngc-22.12)kinghorn@trp64:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[5235] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[5234] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[5235]: world_size = 2, rank = 1, backend=nccl
[5234]: world_size = 2, rank = 0, backend=nccl
[5234] rank = 0, world_size = 2, n = 1, device_ids = [0]
[5235] rank = 1, world_size = 2, n = 1, device_ids = [1]
Works!
```

## minGPT
```
kinghorn@trp64:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64
Running mm/envs/pytorch/bin/python -u /home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py --trainer.max_iters=501 --model.model_type='gpt2' --trainer.batch_size=64 --trainer.data_parallel=True
command line overwriting config attribute trainer.max_iters with 501
command line overwriting config attribute model.model_type with gpt2
command line overwriting config attribute trainer.batch_size with 64
command line overwriting config attribute trainer.data_parallel with True
system:
seed: 3407
work_dir: ./out/chargpt
data:
block_size: 128
model:
model_type: gpt2
n_layer: None
n_head: None
n_embd: None
vocab_size: None
block_size: None
embd_pdrop: 0.1
resid_pdrop: 0.1
attn_pdrop: 0.1
trainer:
device: auto
num_workers: 4
max_iters: 501
batch_size: 64
learning_rate: 0.0005
betas: (0.9, 0.95)
weight_decay: 0.1
grad_norm_clip: 1.0
data_parallel: True

data has 1115394 characters, 65 unique.
number of parameters: 85.20M
running on device cuda
/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/nn/parallel/_functions.py:68: UserWarning: Was asked to gather along dimension 0, but all input tensors were scalars; will instead unsqueeze and return a vector.
warnings.warn('Was asked to gather along dimension 0, but all '
iter_dt 0.00ms; iter 0: train loss 4.23190
be still and wonder         r    t          a                                                            e                                      e                   e                     o                                   o                  a    t    e                                            o               l                        a      h  h     a             s                                      a                                           t                   a  e
saving model
iter_dt 223.28ms; iter 10: train loss 3.51478
iter_dt 223.08ms; iter 20: train loss 3.37468
iter_dt 223.03ms; iter 30: train loss 3.33854
iter_dt 224.01ms; iter 40: train loss 3.22687
iter_dt 223.72ms; iter 50: train loss 3.11156
iter_dt 223.73ms; iter 60: train loss 3.07224
iter_dt 223.59ms; iter 70: train loss 3.00170
iter_dt 223.45ms; iter 80: train loss 2.82439
iter_dt 223.56ms; iter 90: train loss 2.76661
iter_dt 224.23ms; iter 100: train loss 2.66777
iter_dt 225.20ms; iter 110: train loss 2.64665
iter_dt 224.74ms; iter 120: train loss 2.58634
iter_dt 224.51ms; iter 130: train loss 2.55316
iter_dt 224.81ms; iter 140: train loss 2.53147
iter_dt 224.76ms; iter 150: train loss 2.48964
iter_dt 224.63ms; iter 160: train loss 2.47426
iter_dt 224.67ms; iter 170: train loss 2.46599
iter_dt 224.93ms; iter 180: train loss 2.43629
iter_dt 225.11ms; iter 190: train loss 2.44918
iter_dt 225.55ms; iter 200: train loss 2.40741
iter_dt 225.47ms; iter 210: train loss 2.43791
iter_dt 225.38ms; iter 220: train loss 2.40391
iter_dt 225.50ms; iter 230: train loss 2.34891
iter_dt 225.43ms; iter 240: train loss 2.36778
iter_dt 225.41ms; iter 250: train loss 2.27826
iter_dt 225.76ms; iter 260: train loss 2.24484
iter_dt 225.86ms; iter 270: train loss 2.26495
iter_dt 225.75ms; iter 280: train loss 2.20630
iter_dt 225.84ms; iter 290: train loss 2.16121
iter_dt 226.72ms; iter 300: train loss 2.13930
iter_dt 226.18ms; iter 310: train loss 2.11451
iter_dt 226.57ms; iter 320: train loss 2.08788
iter_dt 226.93ms; iter 330: train loss 2.05386
iter_dt 227.21ms; iter 340: train loss 2.05515
iter_dt 227.34ms; iter 350: train loss 2.00436
iter_dt 227.24ms; iter 360: train loss 1.99966
iter_dt 227.01ms; iter 370: train loss 1.98920
iter_dt 227.92ms; iter 380: train loss 2.00917
iter_dt 227.46ms; iter 390: train loss 1.96225
iter_dt 226.45ms; iter 400: train loss 1.92238
iter_dt 226.92ms; iter 410: train loss 1.90071
iter_dt 228.08ms; iter 420: train loss 1.87539
iter_dt 227.59ms; iter 430: train loss 1.89187
iter_dt 227.39ms; iter 440: train loss 1.84570
iter_dt 227.00ms; iter 450: train loss 1.85728
iter_dt 227.88ms; iter 460: train loss 1.84757
iter_dt 227.54ms; iter 470: train loss 1.84610
iter_dt 227.37ms; iter 480: train loss 1.77883
iter_dt 228.11ms; iter 490: train loss 1.82311
iter_dt 228.40ms; iter 500: train loss 1.76101
be still and wonder the,
By ling the cannfeds the wrone. How at your bend
For beregh sones. Felow is thering a thears.

DUKE OF MARLINDE:
Whath is a calive semblelf hals, and shand im somelf.

LUCIO:
I have the passt a him my come, marke.

HASTENSIO:
Why, lons: and for mound man, and trestsst or am,
Inot my forther mindled in her some, at mast
thine, sakeds'd to mysecing for to shame to swoolds
Afther, ifforch had and the candert his tand
thy math our and heir sint. Bolest thus and off me:
To he forther at swid fo
saving model
****************************************************************
* Time = 122.90 seconds for 501 iterations, batchsize 64 
****************************************************************

```

## 2 x 4090 on Xeon with new nv driver

## Tests
- simpleP2P
- simpleMulitGPU
- conjugateGradientMultiDeviceCG
- p2pBandwidthLatencyTest

- TF 1.15
- NAMD ApoA1
- HPL NGC
- PyTorch DDP
- minGPT

### CUDA 12

```
kinghorn@xeon33:~$ export ENROOT_MOUNT_HOME=y
kinghorn@xeon33:~$ enroot start --rw cuda12-ngc

==========
== CUDA ==
==========

CUDA Version 12.0.0
```
```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA GeForce RTX 4090 (GPU0) -> NVIDIA GeForce RTX 4090 (GPU1) : Yes
> Peer access from NVIDIA GeForce RTX 4090 (GPU1) -> NVIDIA GeForce RTX 4090 (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 24.20GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Verification error @ element 1: val = 0.000000, ref = 4.000000
Verification error @ element 2: val = 0.000000, ref = 8.000000
Verification error @ element 3: val = 0.000000, ref = 12.000000
Verification error @ element 4: val = 0.000000, ref = 16.000000
Verification error @ element 5: val = 0.000000, ref = 20.000000
Verification error @ element 6: val = 0.000000, ref = 24.000000
Verification error @ element 7: val = 0.000000, ref = 28.000000
Verification error @ element 8: val = 0.000000, ref = 32.000000
Verification error @ element 9: val = 0.000000, ref = 36.000000
Verification error @ element 10: val = 0.000000, ref = 40.000000
Verification error @ element 11: val = 0.000000, ref = 44.000000
Verification error @ element 12: val = 0.000000, ref = 48.000000
Disabling peer access...
Shutting down...
Test failed!

```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 4.938000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 

```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA GeForce RTX 4090" with compute capability 8.9
GPU Device 1: "NVIDIA GeForce RTX 4090" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 131072 numBlocksPerSm  = 2
Launching kernel
GPU Final, residual = nan 
  Test Summary:  Error amount = 0.000000 
&&&& conjugateGradientMultiDeviceCG FAILED

```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest 
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA GeForce RTX 4090, pciBusID: 51, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA GeForce RTX 4090, pciBusID: c3, pciDeviceID: 0, pciDomainID:0
Device=0 CAN Access Peer Device=1
Device=1 CAN Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     1
     1	     1     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 907.72  22.45 
     1  22.44 920.05 
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1 
     0 908.79  27.00 
     1  27.07 891.87 
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 915.31  31.34 
     1  31.36 922.10 
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 915.30  53.99 
     1  54.07 924.25 
P2P=Disabled Latency Matrix (us)
   GPU     0      1 
     0   1.41  10.28 
     1  10.31   1.44 

   CPU     0      1 
     0   1.98   4.98 
     1   4.92   1.92 
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1 
     0   1.40   0.93 
     1   1.03   1.45 

   CPU     0      1 
     0   1.96   1.39 
     1   1.50   1.92 

```

## TF 1.15
```
kinghorn@xeon33:~$ export MELLANOX_VISIBLE_DEVICES="none"
kinghorn@xeon33:~$ enroot start --rw tf1.15-ngc

================
== TensorFlow ==
================

NVIDIA Release 23.01-tf1 (build 52295116)
TensorFlow Version 1.15.5
```

```
(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-06 15:59:18.065995: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 15:59:18.065999: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12

    10  10.0   138.8  4.253  5.225 1.62000
    20  20.0  2102.6  0.069  1.046 1.24469
    30  30.0  2122.3  0.029  1.009 0.91877
    40  40.0  2124.2  0.055  1.036 0.64222
    50  50.0  2106.6  0.039  1.022 0.41506
    60  60.0  2131.1  0.084  1.069 0.23728
    70  70.0  2117.8  0.073  1.059 0.10889
    80  80.0  2118.4  0.008  0.994 0.02988
    90  90.0  1304.2  0.001  0.988 0.00025

```

## NAMD ApoA1
```
kinghorn@xeon33:~/NAMD/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p128 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

Pe 64 physical rank 64 binding to CUDA device 1 on xeon33: 'NVIDIA GeForce RTX 4090'  Mem: 24183MB  Rev: 8.9  PCI: 0:c3:0
Pe 32 physical rank 32 binding to CUDA device 0 on xeon33: 'NVIDIA GeForce RTX 4090'  Mem: 24217MB  Rev: 8.9  PCI: 0:51:0

Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 128 CPUs 0.00581698 s/step 0.0673261 days/ns 1062.06 MB memory
TIMING: 500  CPU: 0.189914, 0.00026915/step  Wall: 3.23389, 0.00562733/step, 0 hours remaining, 1062.062500 MB of memory in use.
ENERGY:     500     20974.9642     19756.5819      5724.4571       179.8300        -337740.4915     23250.9281         0.0000         0.0000     45358.8688        -222494.8613       165.0031   -267853.7302   -222060.5421       163.5312          -3197.5362     -2425.3430    921491.4634     -2247.8976     -2323.0777

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.003 seconds, 1074.680 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.006 seconds, 1074.680 MB of memory in use
====================================================

WallClock: 12.894131  CPUTime: 2.681599  Memory: 1074.679688 MB
[Partition 0][Node 0] End of program

```

## HPL NGC
```
kinghorn@xeon33:~$ export MELLANOX_VISIBLE_DEVICES="none"
kinghorn@xeon33:~$ enroot start --rw hpl-ngc
NOTE: MOFED driver for multi-node communication was not detected.
      Multi-node communication performance may be reduced.

(hpl-ngc)kinghorn@xeon33:/workspace/hpl-linux-x86_64$ CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1
INFO: host=xeon33 rank=0 lrank=0 cores=4 gpu=0 cpu=0 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl
INFO: host=xeon33 rank=1 lrank=1 cores=4 gpu=1 cpu=1 mem= net= bin=/workspace/hpl-linux-x86_64/xhpl

Per-Process Host Memory Estimate: 20.99 GB (MAX) 20.99 GB (MIN)

PCOL: 0 GPU_COLS: 36001 CPU_COLS: 0 
PCOL: 1 GPU_COLS: 36001 CPU_COLS: 0 
2023-02-06 16:10:20.835
 Prog= 2.38%	N_left= 71424	Time= 2.72	Time_left= 111.39	iGF=  2180.76	GF=  2180.76	iGF_per= 1090.38 	GF_per= 1090.38 
 Prog= 3.56%	N_left= 71136	Time= 3.94	Time_left= 106.89	iGF=  2387.81	GF=  2245.13	iGF_per= 1193.90 	GF_per= 1122.56 
 Prog= 4.72%	N_left= 70848	Time= 5.13	Time_left= 103.48	iGF=  2443.79	GF=  2291.13	iGF_per= 1221.90 	GF_per= 1145.56 
 Prog= 7.03%	N_left= 70272	Time= 7.51	Time_left= 99.33	iGF=  2410.83	GF=  2329.05	iGF_per= 1205.42 	GF_per= 1164.53 
 Prog= 8.17%	N_left= 69984	Time= 8.70	Time_left= 97.78	iGF=  2386.75	GF=  2336.93	iGF_per= 1193.37 	GF_per= 1168.46 
 Prog= 9.30%	N_left= 69696	Time= 9.85	Time_left= 96.07	iGF=  2443.28	GF=  2349.35	iGF_per= 1221.64 	GF_per= 1174.67 
 Prog= 10.42%	N_left= 69408	Time= 11.35	Time_left= 97.65	iGF=  1848.66	GF=  2282.88	iGF_per= 924.33 	GF_per= 1141.44 

2023-02-06 16:12:12.663
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             111.83              2.225e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0029328 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

```

## PyTorch DDP
```
kinghorn@xeon33:~$ enroot start --rw pt-ngc22.12

=============
== PyTorch ==
=============

NVIDIA Release 22.12 (build 49968248)
PyTorch Version 1.14.0a0+410ce96

(pt-ngc22.12)kinghorn@xeon33:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[4327] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[4326] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[4326]: world_size = 2, rank = 0, backend=nccl
[4327]: world_size = 2, rank = 1, backend=nccl
[4327] rank = 1, world_size = 2, n = 1, device_ids = [1]
[4326] rank = 0, world_size = 2, n = 1, device_ids = [0]
Worked!
```

## minGPT
```
kinghorn@xeon33:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64
Running mm/envs/pytorch/bin/python -u /home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py --trainer.max_iters=501 --model.model_type='gpt2' --trainer.batch_size=64 --trainer.data_parallel=True
command line overwriting config attribute trainer.max_iters with 501
command line overwriting config attribute model.model_type with gpt2
command line overwriting config attribute trainer.batch_size with 64
command line overwriting config attribute trainer.data_parallel with True
system:
seed: 3407
work_dir: ./out/chargpt
data:
block_size: 128
model:
model_type: gpt2
n_layer: None
n_head: None
n_embd: None
vocab_size: None
block_size: None
embd_pdrop: 0.1
resid_pdrop: 0.1
attn_pdrop: 0.1
trainer:
device: auto
num_workers: 4
max_iters: 501
batch_size: 64
learning_rate: 0.0005
betas: (0.9, 0.95)
weight_decay: 0.1
grad_norm_clip: 1.0
data_parallel: True

data has 1115394 characters, 65 unique.
number of parameters: 85.20M
running on device cuda
/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/nn/parallel/_functions.py:68: UserWarning: Was asked to gather along dimension 0, but all input tensors were scalars; will instead unsqueeze and return a vector.
warnings.warn('Was asked to gather along dimension 0, but all '
iter_dt 0.00ms; iter 0: train loss 2.11314
Traceback (most recent call last):
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py", line 144, in <module>
trainer.run()
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/trainer.py", line 109, in run
self.trigger_callbacks('on_batch_end')
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/trainer.py", line 61, in trigger_callbacks
callback(self)
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py", line 131, in batch_end_callback
y = model.generate(x, 500, temperature=1.0, do_sample=True, top_k=10)[0]
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mm/envs/pytorch/lib/python3.10/site-packages/torch/autograd/grad_mode.py", line 27, in decorate_context
return func(*args, **kwargs)
File "/home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/mingpt/model.py", line 303, in generate
idx_next = torch.multinomial(probs, num_samples=1)
RuntimeError: probability tensor contains either `inf`, `nan` or element < 0

```


## Topo

nvidia-smi topo -m

```
kinghorn@xeon33:~$ nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: GPU-9db283bb-bdb7-fd4e-d79a-4a2688240641)
GPU 1: NVIDIA GeForce RTX 4090 (UUID: GPU-dce3c608-a465-4502-5ff9-9bdafd440a84)
kinghorn@xeon33:~$ nvidia-smi topo -m
	GPU0	GPU1	CPU Affinity	NUMA Affinity
GPU0	 X 	SYS	0-63		N/A
GPU1	SYS	 X 	0-63		N/A

```

```
kinghorn@trp64:~$ nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 3090 (UUID: GPU-6987a197-dc45-2fc2-faff-051a86ff1081)
GPU 1: NVIDIA GeForce RTX 3090 (UUID: GPU-0ed09d2f-e9e6-3124-382b-c3eaf80ba6ee)
kinghorn@trp64:~$ nvidia-smi topo -m
	GPU0	GPU1	CPU Affinity	NUMA Affinity
GPU0	 X 	SYS	0-127		N/A
GPU1	SYS	 X 	0-127		N/A

```

```
kinghorn@trp64:~$ nvidia-smi -L
GPU 0: NVIDIA RTX 6000 Ada Generation (UUID: GPU-e0047e31-0343-d4d9-f3b9-e68faa13e0e7)
GPU 1: NVIDIA RTX 6000 Ada Generation (UUID: GPU-2f9389c4-c377-977b-80a5-0043179839f0)
kinghorn@trp64:~$ nvidia-smi topo -m
	GPU0	GPU1	CPU Affinity	NUMA Affinity
GPU0	 X 	SYS	0-127		N/A
GPU1	SYS	 X 	0-127		N/A

Legend:

  X    = Self
  SYS  = Connection traversing PCIe as well as the SMP interconnect between NUMA nodes (e.g., QPI/UPI)
  NODE = Connection traversing PCIe as well as the interconnect between PCIe Host Bridges within a NUMA node
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe bridges (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing at most a single PCIe bridge
  NV#  = Connection traversing a bonded set of # NVLinks

```

## 2 x 6000 Ada on Xeon-W

### CUDA 12
```
kinghorn@xeon33:~$ nvidia-smi 
Wed Feb  8 14:18:28 2023       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.85.05    Driver Version: 525.85.05    CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA RTX 6000...  Off  | 00000000:51:00.0 Off |                  Off |
| 30%   56C    P0    66W / 300W |      0MiB / 49140MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA RTX 6000...  Off  | 00000000:C3:00.0 Off |                  Off |
| 30%   57C    P0    67W / 300W |      0MiB / 49140MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

kinghorn@xeon33:~$ nvidia-smi -L
GPU 0: NVIDIA RTX 6000 Ada Generation (UUID: GPU-e0047e31-0343-d4d9-f3b9-e68faa13e0e7)
GPU 1: NVIDIA RTX 6000 Ada Generation (UUID: GPU-2f9389c4-c377-977b-80a5-0043179839f0)

kinghorn@xeon33:~$ uname -a
Linux xeon33 5.15.0-58-generic #64-Ubuntu SMP Thu Jan 5 11:43:13 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleP2P 
[./simpleP2P] - Starting...
Checking for multiple GPUs...
CUDA-capable device count: 2

Checking GPU(s) for support of peer to peer memory access...
> Peer access from NVIDIA RTX 6000 Ada Generation (GPU0) -> NVIDIA RTX 6000 Ada Generation (GPU1) : Yes
> Peer access from NVIDIA RTX 6000 Ada Generation (GPU1) -> NVIDIA RTX 6000 Ada Generation (GPU0) : Yes
Enabling peer access between GPU0 and GPU1...
Allocating buffers (64MB on GPU0, GPU1 and CPU Host)...
Creating event handles...
cudaMemcpyPeer / cudaMemcpy between GPU0 and GPU1: 19.34GB/s
Preparing host buffer and memcpy to GPU0...
Run kernel on GPU1, taking source data from GPU0 and writing to GPU1...
Run kernel on GPU0, taking source data from GPU1 and writing to GPU0...
Copy data back to host from GPU0 and verify results...
Disabling peer access...
Shutting down...
Test passed
```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./simpleMultiGPU 
Starting simpleMultiGPU
CUDA-capable device count: 2
Generating input data...

Computing with 2 GPUs...
  GPU Processing time: 4.867000 (ms)

Computing with Host CPU...

Comparing GPU and Host CPU results...
  GPU sum: 16777280.000000
  CPU sum: 16777294.395033
  Relative difference: 8.580068E-07 
```

```
conjugateGradientMultiDeviceCG  p2pBandwidthLatencyTest  simpleMultiGPU  simpleP2P
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./conjugateGradientMultiDeviceCG 
Starting [conjugateGradientMultiDeviceCG]...
GPU Device 0: "NVIDIA RTX 6000 Ada Generation" with compute capability 8.9
GPU Device 1: "NVIDIA RTX 6000 Ada Generation" with compute capability 8.9
Device=0 CAN Access Peer Device=1
Selected p2p capable devices - deviceId = 0  deviceId = 1  

Running on GPUs = 2
Total threads per GPU = 145408 numBlocksPerSm  = 2
Launching kernel
GPU Final, residual = 7.160786e-06 
  Test Summary:  Error amount = 0.000000 
&&&& conjugateGradientMultiDeviceCG PASSED
```

```
(cuda12-ngc)kinghorn@xeon33:~/cuda-samples-12.0/bin/x86_64/linux/release$ ./p2pBandwidthLatencyTest 
[P2P (Peer-to-Peer) GPU Bandwidth Latency Test]
Device: 0, NVIDIA RTX 6000 Ada Generation, pciBusID: 51, pciDeviceID: 0, pciDomainID:0
Device: 1, NVIDIA RTX 6000 Ada Generation, pciBusID: c3, pciDeviceID: 0, pciDomainID:0
Device=0 CAN Access Peer Device=1
Device=1 CAN Access Peer Device=0

***NOTE: In case a device doesn't have P2P access to other one, it falls back to normal memcopy procedure.
So you can see lesser Bandwidth (GB/s) and unstable Latency (us) in those cases.

P2P Connectivity Matrix
     D\D     0     1
     0	     1     1
     1	     1     1
Unidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 794.74  22.48 
     1  22.47 806.24 
Unidirectional P2P=Enabled Bandwidth (P2P Writes) Matrix (GB/s)
   D\D     0      1 
     0 790.34  21.31 
     1  21.26 821.52 
Bidirectional P2P=Disabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 796.55  31.35 
     1  31.36 803.14 
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1 
     0 794.51  41.44 
     1  41.46 797.80 
P2P=Disabled Latency Matrix (us)
   GPU     0      1 
     0   1.37  10.60 
     1  10.27   1.32 

   CPU     0      1 
     0   1.99   4.91 
     1   4.87   1.93 
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1 
     0   1.37   1.13 
     1   1.17   1.31 

   CPU     0      1 
     0   1.98   1.51 
     1   1.56   1.98 
```


### TF 1.15
```
kinghorn@xeon33:~$ enroot start --rw tf1.15-ngc

================
== TensorFlow ==
================

NVIDIA Release 23.01-tf1 (build 52295116)
TensorFlow Version 1.15.5

(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16

    10  10.0   140.1  4.104  5.076 1.62000
    20  20.0  2110.3  0.049  1.026 1.24469
    30  30.0  2107.6  0.203  1.178 0.91877
    40  40.0  2129.2  0.116  1.088 0.64222
    50  50.0  2129.8  0.046  1.020 0.41506
    60  60.0  2105.8  0.150  1.124 0.23728
    70  70.0  2130.6  0.023  0.998 0.10889
    80  80.0  2129.8  0.017  0.992 0.02988
    90  90.0  1276.9  0.002  0.976 0.00025

(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=256 --precision=fp16

    10  10.0   270.2  4.800  5.772 1.62000
    20  20.0  3470.3  0.259  1.236 1.24469
    30  30.0  3476.4  0.001  0.978 0.91877
    40  40.0  3494.6  0.000  0.969 0.64222
    50  50.0  3499.7  0.000  0.960 0.41506
    60  60.0  3514.9  0.000  0.954 0.23728
    70  70.0  3508.9  0.000  0.951 0.10889
    80  80.0  3518.4  0.000  0.949 0.02988
    90  90.0  2277.8  0.000  0.949 0.00025

(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=384 --precision=fp16

    10  10.0   408.5  5.180  6.152 1.62000
    20  20.0  3759.9  0.736  1.712 1.24469
    30  30.0  3776.1  0.034  1.015 0.91877
    40  40.0  3770.8  0.026  1.005 0.64222
    50  50.0  3757.3  0.064  1.041 0.41506
    60  60.0  3743.4  0.017  0.993 0.23728
    70  70.0  3752.2  0.003  0.977 0.10889
    80  80.0  3778.3  0.000  0.974 0.02988
    90  90.0  2700.4  0.000  0.973 0.00025

(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=512 --precision=fp16

    10  10.0   527.8  5.583  6.555 1.62000
    20  20.0  3807.6  1.423  2.399 1.24469
    30  30.0  3824.4  0.158  1.139 0.91877
    40  40.0  3813.1  0.025  1.004 0.64222
    50  50.0  3806.0  0.045  1.023 0.41506
    60  60.0  3807.1  0.009  0.984 0.23728
    70  70.0  3817.0  0.001  0.973 0.10889
    80  80.0  3832.1  0.000  0.972 0.02988
    90  90.0  2989.3  0.000  0.972 0.00025
```

### NAMD ApoA1
```
kinghorn@xeon33:~/NAMD/apoa1$ ../NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p64 +setcpuaffinity +idlepoll  +devices 0,1 apoa1.namd

Warning: Energy evaluation is expensive, increase outputEnergies to improve performance.
Info: Benchmark time: 64 CPUs 0.00124635 s/step 0.0144254 days/ns 979.844 MB memory
TIMING: 500  CPU: 0.720324, 0.0012668/step  Wall: 0.726789, 0.0012413/step, 0 hours remaining, 979.843750 MB of memory in use.
ENERGY:     500     20974.9322     19756.6257      5724.4544       179.8315        -337740.5046     23250.9763         0.0000         0.0000     45358.8336        -222494.8508       165.0030   -267853.6844   -222060.5330       163.5310          -3197.4851     -2425.3292    921491.4634     -2247.8628     -2323.0418

WRITING EXTENDED SYSTEM TO OUTPUT FILE AT STEP 500
WRITING COORDINATES TO OUTPUT FILE AT STEP 500
The last position output (seq=-2) takes 0.002 seconds, 989.500 MB of memory in use
WRITING VELOCITIES TO OUTPUT FILE AT STEP 500
The last velocity output (seq=-2) takes 0.001 seconds, 989.500 MB of memory in use
====================================================

WallClock: 8.719171  CPUTime: 2.193297  Memory: 989.500000 MB

```

### HPL NGC
```
kinghorn@xeon33:~$ enroot start --rw hpl-ngc

(hpl-ngc)kinghorn@xeon33:/workspace/hpl-linux-x86_64$ CUDA_VISIBLE_DEVICES=0,1 mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc -np 2 hpl.sh --dat ./HPL.dat --cpu-affinity 0:1 --cpu-cores-per-rank 4 --gpu-affinity 0:1

2023-02-08 14:51:33.069
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2       72000   288     1     2             100.09              2.486e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0027449 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================

2023-02-08 15:00:46.448
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR03L2L2      102400   288     1     2             278.86              2.567e+03 
--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0026776 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================


```

### PyTorch DDP
```
kinghorn@xeon33:~$ enroot start --rw pt-ngc22.12

=============
== PyTorch ==
=============

NVIDIA Release 22.12 (build 49968248)
PyTorch Version 1.14.0a0+410ce96

(pt-ngc22.12)kinghorn@xeon33:/workspace/examples/upstream/distributed/ddp$ python /usr/local/lib/python3.8/dist-packages/torch/distributed/launch.py --nnode=1 --node_rank=0 --nproc_per_node=2 ./example.py --local_world_size=2
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
[5418] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '1', 'WORLD_SIZE': '2'}
[5417] Initializing process group with: {'MASTER_ADDR': '127.0.0.1', 'MASTER_PORT': '29500', 'RANK': '0', 'WORLD_SIZE': '2'}
[5418]: world_size = 2, rank = 1, backend=nccl[5417]: world_size = 2, rank = 0, backend=nccl

[5417] rank = 0, world_size = 2, n = 1, device_ids = [0]
[5418] rank = 1, world_size = 2, n = 1, device_ids = [1]

```

### minGPT
```
kinghorn@xeon33:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64

kinghorn@xeon33:~/pugetbench-mingpt-linux-v0.1.1a$ ./pugetbench-mingpt -y --parallel -i 501 -b 64
Running mm/envs/pytorch/bin/python -u /home/kinghorn/pugetbench-mingpt-linux-v0.1.1a/chargpt.py --trainer.max_iters=501 --model.model_type='gpt2' --trainer.batch_size=64 --trainer.data_parallel=True
command line overwriting config attribute trainer.max_iters with 501
command line overwriting config attribute model.model_type with gpt2
command line overwriting config attribute trainer.batch_size with 64
command line overwriting config attribute trainer.data_parallel with True
system:
seed: 3407
work_dir: ./out/chargpt
data:
block_size: 128
model:
model_type: gpt2
n_layer: None
n_head: None
n_embd: None
vocab_size: None
block_size: None
embd_pdrop: 0.1
resid_pdrop: 0.1
attn_pdrop: 0.1
trainer:
device: auto
num_workers: 4
max_iters: 501
batch_size: 64
learning_rate: 0.0005
betas: (0.9, 0.95)
weight_decay: 0.1
grad_norm_clip: 1.0
data_parallel: True

data has 1115394 characters, 65 unique.
number of parameters: 85.20M
running on device cuda

...

saving model
****************************************************************
* Time = 100.75 seconds for 501 iterations, batchsize 64 
****************************************************************

```