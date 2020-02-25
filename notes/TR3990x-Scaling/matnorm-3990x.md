```
(base) kinghorn@U18TR:~$ conda activate numpy
(numpy) kinghorn@U18TR:~$ emacs -nw matnorm.py
(numpy) kinghorn@U18TR:~$ python --version
Python 3.8.1
(numpy) kinghorn@U18TR:~$ python matnorm.py 
 took 33.293957471847534 seconds 
 norm =  2828458.7610461838
```

```
(numpy) kinghorn@U18TR:~$ cat matnorm.py 
import numpy as np
import time

n = 20000

A = np.random.randn(n,n).astype('float64')
B = np.random.randn(n,n).astype('float64')

start_time = time.time()
nrm = np.linalg.norm(A@B)
print(" took {} seconds ".format(time.time() - start_time))
print(" norm = ",nrm)
```

```
(numpy) kinghorn@U18TR:~$ export MKL_DEBUG_CPU_TYPE=5
(numpy) kinghorn@U18TR:~$ python matnorm.py 
 took 13.672904014587402 seconds 
 norm =  2828356.8202574705
```
```
(openblas-np) kinghorn@U18TR:~$ python matnorm.py 
 took 11.623497724533081 seconds 
 norm =  2828268.66844194
```

# HPL 
```
(openblas-np) kinghorn@U18TR:~/hpl-blis-mt$ python -c 'print( int( (64 * 1024 * 0.80 // 768) * 768 ) )'
52224
```
64GB mem 80%


```
conda create --name openblas-np numpy blas=*=openblas
```


```
#!/bin/bash                                                                                                                                                        

# run from 1 to 64 OMP threads on a numpy matrix norm                                                                                                              

for n in 1 2 4 8 16 24 32 40 48	56 64
do
     echo $n	>> test.out
     OMP_NUM_THREADS=$n	python matnorm.py | grep took |	tee -a test.out
done
```
```
(openblas-np) kinghorn@Shipping:~/numpy-matnorm$ cat test.out 
1
 took 340.6755063533783 seconds 
2
 took 170.65968084335327 seconds 
4
 took 86.54126405715942 seconds 
8
 took 43.89627027511597 seconds 
16
 took 23.277246475219727 seconds 
24
 took 16.9714457988739 seconds 
32
 took 14.075294494628906 seconds 
40
 took 12.267328977584839 seconds 
48
 took 11.430225610733032 seconds 
56
 took 11.164117097854614 seconds 
64
 took 11.432536363601685 seconds 
```
