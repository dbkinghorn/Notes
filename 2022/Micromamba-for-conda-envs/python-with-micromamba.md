# Standalone Python Conda envs without installing Conda

In this post I'll show you how to setup isolated conda envs for Python without having a base conda install! I'll cover Linux and Windows (with fixes for missing Windows paths). Read on to learn about the wonderful micromamba project.

The Python package manager, conda, is widely used in the Machine Learning and Scientific computing community. It is commonly distributed as as the package manager with Anaconda Python (and R). It's a a general package manager but primarily used for Python. Part of the reason for the popularity of Anaconda and conda is that the managed packages are optimized for performance with a focus on numerical computing. And, conda allows the bundling of libraries that are outside of the Python ecosystem. An important example of that is NVIDIA CUDA runtime packages included with conda bundles for important GPU accelerate ML/AI libraries. For example TensorFlow or PyTorch with GPU support without having to do a separate CUDA install.

There certainly are arguments for working with with a "normal" Python.org setup using pip and one of several virtual env tools. However, Anaconda and conda are well established for numerical computing and widely used.

Hopefully I've established the importance of conda in case you were not already aware of that. I'm assuming that you are a conda user or would like to be. But, maybe, you have a use case where you don't really want to do an Anaconda or Miniconda setup.

What if you want to take advantage of conda bundle packaging but really don't want a full setup? Here's some examples of where that might be the case;

- Container deployments
- Application distribution that requires a complex Python environment
- Cloud machine-instance deployments
- Scripted application installs
- Temporary environments
- Cluster application resource scheduling
- Embedded Python for Continuous Integration projects
- ...

If you are reading this you may be dealing with one of the above or something completely different. The point is, it can be a system administration nuisance to get a needed environment setup or deployed.

The case that prompted me to look for a solution is "Application distribution that requires a complex Python environment". I found a wonderful way to deal with this kind of problem.

So what is this magic of which I speak?

## Use Micromamba instead of Conda!

... what? ...

So, what is "micromamba"? What is "mamba"? I'll start with mamba.

## Mamba

I'll quote from the [GitHub page for Mamba](https://github.com/mamba-org/mamba) in the [mamba-org repository organization on GitHub](https://github.com/mamba-org)

---

Mamba is a reimplementation of the conda package manager in C++.

- parallel downloading of repository data and package files using multi-threading
- libsolv for much faster dependency solving, a state of the art library used in the RPM package manager of Red Hat, Fedora and OpenSUSE
- core parts of mamba are implemented in C++ for maximum efficiency

At the same time, mamba utilize the same command line parser, package installation and deinstallation code and transaction verification routines as conda to stay as compatible as possible.

Mamba is part of a bigger ecosystem to make scientific packaging more sustainable. You can read our announcement blog post. The ecosystem also consists of quetz, an open source conda package server and boa, a fast conda package builder.

---

Mamba is a very nice replacement for conda with much better performance. **However, to install mamba you need to have conda installed either from [Anaconda](https://www.anaconda.com/products/individual) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html). That's not what we want!**

```
conda install mamba -n base -c conda-forge
```

Installing conda with Miniconda and adding mamba as a conda replacement is a very nice way to setup a compact base Python for numerical computing. I do that when I want a conda based Python installed on a system. **However, we can avoid that install so that you have a portable conda based Python in an isolated directory without any system dependencies or configuration changes.**

## Micromamba

Micromamba is a tiny (13MB!) **standalone** mamba implemented as a pure C++ executable that provides enough capability to setup conda Python environments. It's not a complete implementation of conda/mamba but it has what you need to setup and manage envs.

Here are links for some documentation;

- [A section with info on the mamba GitHub README](https://github.com/mamba-org/mamba)

- [A section on the mamba "readthedocs" site](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html#micromamba)
- [A very useful GitHub gist that has info on seting up micromamba on Windows, OS X as well as Linux.](https://gist.github.com/wolfv/fe1ea521979973ab1d016d95a589dcde)

Of course, once you have micromamba downloaded, micromamba --help is very useful.

**You can use micromamba in much the same way as a miniconda+mamba install, creating envs, installing packages, activating/deactivating envs, integrating it into your bash shell, etc.. But, that's not where it's most uniquely useful in my opinion.**

The documentation notes "...it's advised to use micromamba in containers & CI only". That was probably the original motivation for the project but I feel that is unduly restrictive. The project seems quite robust and usable/useful to me.

In the next sections I'll go through how I have been using micromamba.

## My micromamba use case

I have been working on a benchmark suite for ML/Sci numerical computing. The individual benchmarks need Python environments for PyTorch, TensorFlow, numpy and various other frameworks that have numpy like APIs. This will run on Linux, Windows and MacOS. I was faced with a problem of how to make a small portable cross-platform executable that could be easily downloaded that would do the setup needed for the more complex envs required by the benchmarks. I settled on a layered approach,

- A small "main" python application that is bundled into an exe with [PyInstaller](https://pyinstaller.readthedocs.io/en/stable/). It's generally best to keep these bundles simple, especially when working with conda.
- A platform specific micromamba is included with the exe above. (only adds 13MB to the bundle)
- The main script then solicits user input for selecting benchmarks and then runs micromamba using python subprocess.run. That creates conda envs that are needed for the benchmarks. This part can involve a substantial download to setup envs, but the initial application download is small.
- The main application then uses subprocess.run to run the benchmarks using the python executable and frameworks that were configured as envs with micromamba.
- **The whole application runs in a single directory with no external dependencies! Nothing is installed on the users system outside of that one directory.**

It is Python running other "Python's" in their own (possibly large and complex) isolated envs.

## Example using micromamba

I'm not going to go through my complete application described above, but will provide instructions from the command-line that will illustrate the methodology.

I will assume that you are using Linux or Windows with some variety of python installed (I haven't done the MacOS testing yet although it should be similar Linux).

**We will make an isolated directory to run a simple numpy benchmark with an env created with micromamba.**

**Create a directory using a Linux shell or Windows PowerShell**

```
mkdir npbench
cd npbench
```

**Get micromamba and put it in a subdir named mm**

Linux

```
wget https://micromamba.snakepit.net/api/micromamba/linux-64/latest -O micromamba.tar.bz
tar -xf micromamba.tar.bz2

mkdir mm
mv bin/micromamba mm/

rmdir bin
rm micromamba.tar.bz2
rm -rf info
```

Windows

On windows you will need something to expand a bzip2 file the popular 7z will work.

```
Invoke-Webrequest -URI https://micromamba.snakepit.net/api/micromamba/win-64/latest -OutFile micromamba.tar.bz2

& 'C:\Program Files\7-Zip\7z.exe' x .\micromamba.tar.bz2
tar -xf micromamba.tar

mkdir mm
mv Library/bin/micromamba mm/

rm Library
rm info
rm micromamba.tar.bz2
rm micromamba.tar
```

Note: We "cleaned up" unneeded parts of the download.

**Create a simple numpy matmul benchmark in matmul.py and place it in the npbench directory**

```
"""
Matrix multiplication of 2 n x n matrices
"""

import numpy as np
import time

n = 8000
A = np.array(np.random.rand(n, n))
B = np.array(np.random.rand(n, n))
C = np.empty_like(A)

start_time = time.time()
C = np.matmul(A, B)
run_time = time.time() - start_time
print( f'{(2e-9 * (n ** 3 + n ** 2)) / run_time :.2f} GFLOPS' )

```

**Use micromamba to create an "env" named "np-main" that includes numpy from the anaconda package repository**
(...assuming you are still in the npbench directory)

We will create the env with the micromamba "root-prefix" mm

```
mm/micromamba create --prefix mm/envs/np-main --root-prefix mm numpy --channel anaconda
```

That should create the env quickly but it will be downloading the Intel MKL libraries and that takes a few seconds. (MKL BLAS libraries are default with the Anaconda build of numpy. That gives good performance with AMD CPU's too!)

I used long "flag" names in the command above for clarity but you can use short flags too,

```
mm/micromamba create -p mm/envs/np-main -r mm numpy -c anaconda
```

**Fix Windows incomplete PATH assignment!!**
Unfortunately Windows does not set conda based Python paths correctly so you will have to add to the path in the PowerShell instance you are using. (This is not needed on Linux)

```
$syspath = $env:path

$extrap = Join-Path $pwd mm\envs\np-main\Library\bin
$env:Path = $extrap + ";" + $syspath
```

**Run the matmul.py benchmark using the env that was created with micromamba**

We are going to "directly" use the python exe in the env i.e. no "activation" step.

Linux

```
mm/envs/np-main/bin/python matmul.py
```

Windows

```
mm/envs/np-main/python matmul.py
```

**That's it! You should have just gotten a benchmark result for matrix multiplication with MKL accelerated numpy from a standalone conda based Python without needing any changes on your system.**

## Conclusion

I hope this post gives you ideas on how to use, the wonderful, micromamba. I often have use cases where I don't want a full system python installation. Having an isolated conda based python setup of nearly any complexity without having to do any kind of global/permanent install has been really useful for me.

**Happy Computing! --dbk @dbkinghorn**
