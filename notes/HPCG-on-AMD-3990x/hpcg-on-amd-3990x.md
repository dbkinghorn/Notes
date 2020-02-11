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

