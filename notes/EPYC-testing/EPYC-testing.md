## EPYC testing on Azure

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                       
 75894 kinghorn  20   0  0.105t 0.096t   8740 R 12000 21.8 900:47.18 xhpl      

```
 kinghorn@EPYC-testing:~/hpl-blis-mt$ OMP_NUM_THREADS=120 ./xhpl 
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
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

N      :  114000 
NB     :     768 
PMAP   : Row-major process mapping
P      :       1 
Q      :       1 
PFACT  :   Right 
NBMIN  :       4 
NDIV   :       2 
RFACT  :   Right 
BCAST  :   2ring 
DEPTH  :       1 
SWAP   : Spread-roll (long)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4      114000   768     1     1             885.42             1.1155e+03
HPL_pdgesv() start time Fri Mar 13 23:18:09 2020

HPL_pdgesv() end time   Fri Mar 13 23:32:55 2020


--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   4.04947690e-03 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================
```

```
kinghorn@EPYC-testing:~/hpl-blis-st$ mpirun -np 120 --map-by l3cache --mca btl self,vader xhpl
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
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

N      :   90000 
NB     :     768 
PMAP   : Row-major process mapping
P      :      12 
Q      :      10 
PFACT  :   Right 
NBMIN  :       4 
NDIV   :       2 
RFACT  :   Right 
BCAST  :   2ring 
DEPTH  :       1 
SWAP   : Spread-roll (long)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR12R2R4       90000   768    12    10             230.90             2.1049e+03
HPL_pdgesv() start time Fri Mar 13 23:50:27 2020

HPL_pdgesv() end time   Fri Mar 13 23:54:18 2020

--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   1.97456630e-03 ...... PASSED
================================================================================
```
WR12R2R4      180000   768    12    10            1574.24             2.4698e+03


