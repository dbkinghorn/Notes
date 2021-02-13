# Note: How To Increase Stack Size and Max Locked Memory on Ubuntu 

The default resource limits on Ubuntu are reasonable but restrictive. If you are trying to run a large Scientific application or demanding GPU accelerated program you may find yourself faced with the dreaded "segmentation fault". Or possibly an equally dreaded "Signal 9 (Killed)" when you try to run a large parallel job. How can you fix that?

In this post I'll show you a way to increase your User Limits (ulimit) when you are running troublesome scientific applications on your workstation.

The most troublesome limits is,
- Stack Size:  MPI Parallel Fortran code can sometimes eat up the stack with large automatic variables, function calls and communication. If there isn't enough stack you get a segmentation fault on a well behaved OS. 

If you are running demanding GPU accelerated or using MPI for SMP parallel process then the this one may give you trouble, 
- Max Locked Memory: Is the maximum memory that can be locked into RAM, i.e. can't be written out to swap. When using GPU accelerators you may want the locked memory to be equal to the total GPU memory for pinned memory. [This is not always a problem but performance of host to device memory can be improved.] MPI parallel process use private copies of application memory rather that sharing memory the way parallel threaded application do. This is needed for distributed (multi-node) applications but can also give very good performance on a single node multi-core system ... but it can use a lot of memory and if your OS wants to page processes out (needlessly) it can degrade performance or kill jobs.

By default on Ubuntu 20.04 these limits are set low (in my opinion). You may never encounter any trouble depending on how you use your system, but when you do it can be perplexing. 

Note: some people consider the default limits on Ubuntu to be excessively large. And I will concede that they are reasonable for most use cases, I guess it depends on what you are doing.

I have recently been looking at (compiling and running) an MPI parallel, Fortran, quantum chemistry program that was derived from research I did years ago. It places large system resource demands on my workstation. I ran into both the dreaded "segmentation fault" and "Signal 9 (killed) problems. **I've seen this sort of thing many times before so I knew what to do. However, I didn't expect it to be so painfully difficult with Ubuntu!**


There are unfortunately far too many apparent ways to change ulimits on modern Ubuntu, and many of them don't work. Following is what I eventually got to work for a more reasonable configuration on my Ubuntu workstation.

## Workstation Info
The settings I'll make are for the following system, (I'll show you how to make appropriate choices for your own system too.)

- Ubuntu 20.04
- Xeon-W 2295
- 128 GB memory
- 2 x NVIDIA TitanV 

The most important spec is the amount of memory. 

## Check what your running kernel shows for limits
You can check current kernel limits in **/proc/1/limits**  On my workstation running kernel set limits are,

```
kinghorn@i9:~$ cat /proc/1/limits 
Limit                     Soft Limit           Hard Limit           Units     
Max cpu time              unlimited            unlimited            seconds   
Max file size             unlimited            unlimited            bytes     
Max data size             unlimited            unlimited            bytes     
Max stack size            8388608              unlimited            bytes     
Max core file size        0                    unlimited            bytes     
Max resident set          unlimited            unlimited            bytes     
Max processes             513582               513582               processes 
Max open files            1048576              1048576              files     
Max locked memory         67108864             67108864             bytes     
Max address space         unlimited            unlimited            bytes     
Max file locks            unlimited            unlimited            locks     
Max pending signals       513582               513582               signals   
Max msgqueue size         819200               819200               bytes     
Max nice priority         0                    0                    
Max realtime priority     0                    0                    
Max realtime timeout      unlimited            unlimited            us       
```
Note: "Soft Limit" is generally the maximum value that can be set by a user. "Hard Limit" can only be changed/set by root.

The two values we are most concerned with are,
```
Max stack size            8388608              unlimited            bytes
Max locked memory         67108864             67108864             bytes
```

## Check your user account limits with ulimit -a 
```
kinghorn@i9:~$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 513582
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 513582
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```
The two we will change are,
```
stack size              (kbytes, -s) 8192  (8388608 bytes)
max locked memory       (kbytes, -l) 65536 (67108864 bytes) 
```
Note: "ulimit" reports and sets those values in kbytes. I added the byte values.

You can see that those user limits are the same as the soft limits reported from the running kernel. **In order to allow a user to change (raise) these limits we'll have to change the system soft limit that is set at boot time. That means changing the limits in the systemd config files.**

## Looking at Limits from Systemd
To check the limits that are set at boot time by systemd you can use "systemctl",

```
sudo systemctl show  | grep DefaultLimit
```
```
kinghorn@i9:~$ sudo systemctl show  | grep DefaultLimit
DefaultLimitCPU=infinity
DefaultLimitCPUSoft=infinity
DefaultLimitFSIZE=infinity
DefaultLimitFSIZESoft=infinity
DefaultLimitDATA=infinity
DefaultLimitDATASoft=infinity
DefaultLimitSTACK=infinity
DefaultLimitSTACKSoft=8388608
DefaultLimitCORE=infinity
DefaultLimitCORESoft=0
DefaultLimitRSS=infinity
DefaultLimitRSSSoft=infinity
DefaultLimitNOFILE=524288
DefaultLimitNOFILESoft=1024
DefaultLimitAS=infinity
DefaultLimitASSoft=infinity
DefaultLimitNPROC=513582
DefaultLimitNPROCSoft=513582
DefaultLimitMEMLOCK=65536
DefaultLimitMEMLOCKSoft=65536
DefaultLimitLOCKS=infinity
DefaultLimitLOCKSSoft=infinity
DefaultLimitSIGPENDING=513582
DefaultLimitSIGPENDINGSoft=513582
DefaultLimitMSGQUEUE=819200
DefaultLimitMSGQUEUESoft=819200
DefaultLimitNICE=0
DefaultLimitNICESoft=0
DefaultLimitRTPRIO=0
DefaultLimitRTPRIOSoft=0
DefaultLimitRTTIME=infinity
DefaultLimitRTTIMESoft=infinity
```

