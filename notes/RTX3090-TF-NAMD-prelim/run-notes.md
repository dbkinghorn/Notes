


This is warning output from start of job run...
```
2020-09-22 11:42:01.997861: I tensorflow/stream_executor/platform/default/dso_loader.cc:48] Successfully opened dynamic library libcublas.so.11
2020-09-22 11:42:03.984823: W tensorflow/stream_executor/cuda/redzone_allocator.cc:312] Internal: ptxas exited with non-zero error code 65280, output: ptxas fatal   : Value 'sm_86' is not defined for option 'gpu-name'

Relying on driver to perform ptx compilation. This message will be only logged once.
2020-09-22 11:42:04.470952: W tensorflow/compiler/xla/service/gpu/buffer_comparator.cc:590] Internal: ptxas exited with non-zero error code 65280, output: ptxas fatal   : Value 'sm_86' is not defined for option 'gpu-name'

Relying on driver to perform ptx compilation. This message will be only logged once.
```

NAMD output on 3090
```
Info: Benchmark time: 24 CPUs 0.00230196 s/step 0.0266431 days/ns 578.215 MB memory
Info: Benchmark time: 24 CPUs 0.00227085 s/step 0.026283 days/ns 578.215 MB memory
WallClock: 2.338557  CPUTime: 2.279315  Memory: 590.078125 MB
Info: Benchmark time: 24 CPUs 0.00229046 s/step 0.02651 days/ns 571.82 MB memory
Info: Benchmark time: 24 CPUs 0.00228571 s/step 0.026455 days/ns 571.82 MB memory
WallClock: 2.334467  CPUTime: 2.283404  Memory: 584.566406 MB
/usr/bin/nvidia-modprobe: unrecognized option: "-s"

ERROR: Invalid commandline, please run `/usr/bin/nvidia-modprobe --help` for usage information.

/usr/bin/nvidia-modprobe: unrecognized option: "-s"

ERROR: Invalid commandline, please run `/usr/bin/nvidia-modprobe --help` for usage information.

Info: Benchmark time: 24 CPUs 0.0292976 s/step 0.339093 days/ns 2234.5 MB memory
Info: Benchmark time: 24 CPUs 0.0308574 s/step 0.357145 days/ns 2237.85 MB memory
WallClock: 26.087387  CPUTime: 25.950905  Memory: 2445.898438 MB
Info: Benchmark time: 24 CPUs 0.029365 s/step 0.339872 days/ns 2234.5 MB memory
Info: Benchmark time: 24 CPUs 0.0291978 s/step 0.337938 days/ns 2237.34 MB memory
WallClock: 25.841963  CPUTime: 25.723230  Memory: 2442.808594 MB
```


NAMD 2080Ti out
```
Info: Benchmark time: 24 CPUs 0.00270008 s/step 0.0312509 days/ns 552.164 MB memory
Info: Benchmark time: 24 CPUs 0.00270111 s/step 0.0312629 days/ns 552.164 MB memory
WallClock: 2.589814  CPUTime: 2.523038  Memory: 564.609375 MB
Info: Benchmark time: 24 CPUs 0.00273225 s/step 0.0316233 days/ns 552.41 MB memory
Info: Benchmark time: 24 CPUs 0.00272191 s/step 0.0315036 days/ns 552.41 MB memory
WallClock: 2.576694  CPUTime: 2.522658  Memory: 563.625000 MB
/usr/bin/nvidia-modprobe: unrecognized option: "-s"

ERROR: Invalid commandline, please run `/usr/bin/nvidia-modprobe --help` for usage information.

/usr/bin/nvidia-modprobe: unrecognized option: "-s"

ERROR: Invalid commandline, please run `/usr/bin/nvidia-modprobe --help` for usage information.

Info: Benchmark time: 24 CPUs 0.0306538 s/step 0.35479 days/ns 2217.15 MB memory
Info: Benchmark time: 24 CPUs 0.0305815 s/step 0.353953 days/ns 2219.47 MB memory
WallClock: 26.744625  CPUTime: 26.591415  Memory: 2432.675781 MB
Info: Benchmark time: 24 CPUs 0.0307184 s/step 0.355537 days/ns 2210.09 MB memory
Info: Benchmark time: 24 CPUs 0.0304867 s/step 0.352855 days/ns 2212.15 MB memory
WallClock: 26.550089  CPUTime: 26.406422  Memory: 2431.808594 MB
```

