# NVIDIA multiGPU RTX4090 Issues vs RTX6000 Ada and RTX3090



 

|Test Jobs|2 x RTX4090 (TrPro)|2 x RTX4090 (Xeon W)|2 x RTX3090 (TrPro)|2 x RTX6000 Ada (TrPro)|2 x RTX6000 Ada (Xeon-W)|
|---------|-------------------|--------------------|-------------------|-----------------------|------------------------|
|simpleP2P| Fail | Fail | NO P2P | YES P2P | YES P2P |
|simpleMulitGPU|Pass|Pass|Pass|Pass|Pass|
|conjugateGradientMultiDeviceCG|Hang|Hang|Pass|Pass|Pass|
|p2pBandwidthLatencyTest|54 GB/s|54 GB/s|16.5 GB/s|51.1 GB/s|41.4 GB/s|
|TensorFlow 1.15|Hang|2131 img/s|2048 img/s|737 img/s|3832 img/s|
|NAMD ApoA1|0.01457 day/ns|N/A|0.01537 day/ns|0.02322 day/ns|0.01442 day/ns|
|HPL NGC|2246 GFLOPS|2225 GLOPS|1067 GFLOPS|567 GFLOPS| 2567 GFLOPS|
|PyTorch DDP|Hang|Pass|Pass|Pass|Pass|
|minGPT|Fail|Fail|123 sec|332 sec|101 sec|