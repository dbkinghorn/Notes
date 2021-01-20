

```
kinghorn@u18i7:~$ sudo sh cuda_10.2.89_440.33.01_linux.run --toolkit --samples --override
===========
= Summary =
===========

Driver:   Not Selected
Toolkit:  Installed in /usr/local/cuda-10.2/
Samples:  Installed in /home/kinghorn/

Please make sure that
 -   PATH includes /usr/local/cuda-10.2/bin
 -   LD_LIBRARY_PATH includes /usr/local/cuda-10.2/lib64, or, add /usr/local/cuda-10.2/lib64 to /etc/ld.so.conf and run ldconfig as root

To uninstall the CUDA Toolkit, run cuda-uninstaller in /usr/local/cuda-10.2/bin

Please see CUDA_Installation_Guide_Linux.pdf in /usr/local/cuda-10.2/doc/pdf for detailed information on setting up CUDA.
***WARNING: Incomplete installation! This installation did not install the CUDA Driver. A driver of version at least 440.00 is required for CUDA 10.2 functionality to work.
To install the driver using this installer, run the following command, replacing <CudaInstaller> with the name of this run file:
    sudo <CudaInstaller>.run --silent --driver

Logfile is /var/log/cuda-installer.log
```

```
kinghorn@u18i7:~/NVIDIA_CUDA-10.2_Samples/5_Simulations/nbody$ grep -r "unsupported GNU version" /usr/local/cuda-10.2/include/*
/usr/local/cuda-10.2/include/crt/host_config.h:#error -- unsupported GNU version! gcc versions later than 8 are not supported!
```

