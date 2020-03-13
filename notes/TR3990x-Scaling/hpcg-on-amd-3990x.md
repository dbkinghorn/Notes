#HPCG on AMD 3990x 64-core Threadripper

http://developer.amd.com/wp-content/resources/56420.pdf


What it does: stresses the main memory to such an extent that it has a punishing effect on the FLOPS that each core can produce. The more FLOPS each core produces then the more efficient a system is under this test.

Available from: http://www.hpcg-benchmark.org/software/index.htm   tar file

or  clone from

https://github.com/hpcg-benchmark/hpcg


Setup:
untar and cd into your hpcg source directory
cd setup
cp Make.Linux_MPI Make.EPYC
edit Make.EPYC with your favourite editor. Settings described below
mkdir /path/hpcg-3.0/mybuild-mpi
cd ../mybuild-mpi/full/path/to/hpcg-3.0/configure 7601
make -j 64  (change 64 to however many threads you have)

```
# ----------------------------------------------------------------------
# - shell --------------------------------------------------------------
# ----------------------------------------------------------------------
#
SHELL        = /bin/sh
#
CD           = cd
CP           = cp
LN_S         = ln -s -f
MKDIR        = mkdir -p
RM           = /bin/rm -f
TOUCH        = touch
#
# ----------------------------------------------------------------------
# - HPCG Directory Structure / HPCG library ------------------------------
# ----------------------------------------------------------------------
#
TOPdir       = .
SRCdir       = $(TOPdir)/src
INCdir       = $(TOPdir)/src
BINdir       = $(TOPdir)/bin
#
# ----------------------------------------------------------------------
# - Message Passing library (MPI) --------------------------------------
# ----------------------------------------------------------------------
# MPinc tells the  C  compiler where to find the Message Passing library
# header files,  MPlib  is defined  to be the name of  the library to be
# used. The variable MPdir is only used for defining MPinc and MPlib.
#
MPdir        = /usr/local/
MPinc        =
MPlib        =
#
#
# ----------------------------------------------------------------------
# - HPCG includes / libraries / specifics -------------------------------
# ----------------------------------------------------------------------
#
HPCG_INCLUDES = -I$(INCdir) -I$(INCdir)/$(arch) $(MPinc)
HPCG_LIBS     =
#
# - Compile time options -----------------------------------------------
#
# -DHPCG_NO_MPI         Define to disable MPI
# -DHPCG_NO_OPENMP      Define to disable OPENMP
# -DHPCG_CONTIGUOUS_ARRAYS Define to have sparse matrix arrays long and contiguous
# -DHPCG_DEBUG          Define to enable debugging output
# -DHPCG_DETAILED_DEBUG Define to enable very detailed debugging output
#
# By default HPCG will:
#    *) Build with MPI enabled.
#    *) Build with OpenMP enabled.
#    *) Not generate debugging output.
#
HPCG_OPTS     = -DHPCG_NO_OPENMP
#
# ----------------------------------------------------------------------
#
HPCG_DEFS     = $(HPCG_OPTS) $(HPCG_INCLUDES)
#
# ----------------------------------------------------------------------
# - Compilers / linkers - Optimization flags ---------------------------
# ----------------------------------------------------------------------
#
CXX          = mpicxx
#CXXFLAGS     = $(HPCG_DEFS) -fomit-frame-pointer -O3 -funroll-loops -W -Wall
CXXFLAGS     = $(HPCG_DEFS) -Ofast -ffast-math -ftree-vectorize -ftree-vectorizer-verbose=0 -fomit-frame-pointer -funroll-loops
#
LINKER       = $(CXX)
LINKFLAGS    = $(CXXFLAGS)
#
ARCHIVER     = ar
ARFLAGS      = r
RANLIB       = echo
#
# ----------------------------------------------------------------------
```

***Testing history
176  history 
  177  export OMP_PROC_BIND=TRUE
  178  export OMP_PLACES=cores
  179  export OMP_NUM_THREADS=64
  180  ./xhpl | tee hpl-TR3990x-noSMT.out
  181  ls
  182  export OMP_NUM_THREADS=60
  183  emacs -nw HPL.dat
  184  ./xhpl | tee hpl-TR3990x-noSMT-60core.out
  185  ls
  186  export OMP_NUM_THREADS=56
  187  ./xhpl | tee hpl-TR3990x-noSMT-56core.out
  188  export OMP_NUM_THREADS=48
  189  ./xhpl | tee hpl-TR3990x-noSMT-48core.out
  190  export OMP_NUM_THREADS=40
  191  ./xhpl | tee hpl-TR3990x-noSMT-40core.out
  192  export OMP_NUM_THREADS=32
  193  ./xhpl | tee hpl-TR3990x-noSMT-32core.out
  194  gcc --version
  195  ls
  196  git clone https://github.com/hpcg-benchmark/hpcg.git
  197  ls
  198  cd hpcg/
  199  ls
  200  cd setup/
  201  ls
  202  less Make.Linux_MPI 
  203  ls
  204  cp Make.Linux_MPI Make.TR_MPI
  205  emacs -nw Make.TR_MPI 
  206  cat Make.TR_MPI
  207  cd ..
  208  ls
  209  mkdir TR-build-mpi
  210  cd TR-build-mpi/
  211  ../configure -h
  212  ../configure --help
  213  cd ..
  214  ls
  215  less QUICKSTART 
  216  ls setup/
  217  ls
  218  mv TR-build-mpi/ build-TR_MPI
  219  cd build-TR_MPI/
  220  ../configure TR_MPI
  221  ls
  222  make -j 64
  223  ls
  224  cd bin/
  225  ls
  226  less hpcg.dat 
  227  export OMP_NUM_THREADS=64
  228  mpiexec -np 64 ./xhpcg 
  229  ls
  230  less HPCG-Benchmark_3.1_2020-02-07_08-14-28.txt 
  231  ls
  232  less hpcg20200207T080609.txt 
  233  ls
  234  cat hpcg.dat 
  235  ls
  236  emacs -nw hpcg.dat 
  237  mpiexec -np 64 ./xhpcg 
  238  ls
  239  tail HPCG-Benchmark_3.1_2020-02-07_08-30-13.txt 
  240  emacs -nw hpcg.dat 
  241  mpiexec -np 64 ./xhpcg 
  242  tail HPCG-Benchmark_3.1_2020-02-07_08-33-07.txt 
  243  emacs -nw hpcg.dat 
  244  mpiexec -np 64 ./xhpcg 
  245  tail HPCG-Benchmark_3.1_2020-02-07_08-35-43.txt 
  246  emacs -nw hpcg.dat 
  247  mpiexec -np 64 ./xhpcg 
  248  emacs -nw hpcg.dat 
  249  mpiexec -np 64 ./xhpcg 
  250  tail HPCG-Benchmark_3.1_2020-02-07_08-39-17.txt 


```
Machine Summary::Distributed Processes=1
GB/s Summary::Total with convergence and optimization phase overhead=21.1542
Final Summary::HPCG result is VALID with a GFLOP/s rating of=2.78833
Machine Summary::Distributed Processes=2
GB/s Summary::Total with convergence and optimization phase overhead=35.5141
Final Summary::HPCG result is VALID with a GFLOP/s rating of=4.68155
Machine Summary::Distributed Processes=4
GB/s Summary::Total with convergence and optimization phase overhead=60.3809
Final Summary::HPCG result is VALID with a GFLOP/s rating of=7.96031
Machine Summary::Distributed Processes=8
GB/s Summary::Total with convergence and optimization phase overhead=74.9427
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.88102
Machine Summary::Distributed Processes=16
GB/s Summary::Total with convergence and optimization phase overhead=77.4573
Final Summary::HPCG result is VALID with a GFLOP/s rating of=10.2131
Machine Summary::Distributed Processes=24
GB/s Summary::Total with convergence and optimization phase overhead=75.3837
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.93995
Machine Summary::Distributed Processes=32
GB/s Summary::Total with convergence and optimization phase overhead=74.3516
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.80401
Machine Summary::Distributed Processes=40
GB/s Summary::Total with convergence and optimization phase overhead=73.1733
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.64874
Machine Summary::Distributed Processes=48
GB/s Summary::Total with convergence and optimization phase overhead=72.3237
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.53691
Machine Summary::Distributed Processes=56
GB/s Summary::Total with convergence and optimization phase overhead=71.335
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.40644
Machine Summary::Distributed Processes=64
GB/s Summary::Total with convergence and optimization phase overhead=70.5222
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.29951

```

