

```
(base) kinghorn@Shipping:~/hpl-blis-mt$ cat hpl-scale.sh
#!/bin/bash

#run xhpl over omp threads

for n in 1 2 4 8 16 24 32 40 48 56 64
do
    echo $n >> test.out
    OMP_NUM_THREADS=$n ./xhpl | grep WR |tee -a test.out
done

```

64GB mem used 52224 NB  

```
python -c 'print( int( (64 * 1024 * 0.80 // 768) * 768 ) )'
```

```
(base) kinghorn@Shipping:~/hpl-blis-mt$ cat hpl-scaling-64GB.out 
1
WR12R2R4       52224   768     1     1            1537.76             6.1752e+01
2
WR12R2R4       52224   768     1     1             825.51             1.1503e+02
4
WR12R2R4       52224   768     1     1             474.42             2.0016e+02
8
WR12R2R4       52224   768     1     1             271.87             3.4929e+02
16
WR12R2R4       52224   768     1     1             160.65             5.9108e+02
24
WR12R2R4       52224   768     1     1             126.53             7.5048e+02
32
WR12R2R4       52224   768     1     1             112.36             8.4515e+02
40
WR12R2R4       52224   768     1     1             104.54             9.0835e+02
48
WR12R2R4       52224   768     1     1             102.61             9.2541e+02
56
WR12R2R4       52224   768     1     1              98.31             9.6588e+02
64
WR12R2R4       52224   768     1     1             100.23             9.4738e+02
```

128GB mem used 

```
(base) kinghorn@Shipping:~/hpl-blis-mt$ python -c 'print( int( (128 * 1024 * 0.80 // 768) * 768 ) )'
104448
```

```
OMP_PROC_BIND=TRUE; OMP_PLACES=threads
```
(base) kinghorn@Shipping:~/hpl-blis-mt$ cat hpl-scaling-128GB.out 
1
WR12R2R4      104448   768     1     1           12064.38             6.2967e+01
2
WR12R2R4      104448   768     1     1            6334.29             1.1993e+02
4
WR12R2R4      104448   768     1     1            3651.88             2.0802e+02
8
WR12R2R4      104448   768     1     1            1980.27             3.8361e+02
16
WR12R2R4      104448   768     1     1            1138.98             6.6696e+02
24
WR12R2R4      104448   768     1     1             861.78             8.8150e+02
32
WR12R2R4      104448   768     1     1             723.85             1.0495e+03
40
WR12R2R4      104448   768     1     1             646.88             1.1743e+03
48
WR12R2R4      104448   768     1     1             619.48             1.2263e+03
56
WR12R2R4      104448   768     1     1             600.90             1.2642e+03
64
WR12R2R4      104448   768     1     1             599.24             1.2677e+03


