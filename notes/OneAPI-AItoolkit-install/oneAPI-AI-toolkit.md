# How to Install Intel oneAPI AI Analytics Toolkit with conda

## Introduction

I recently wrote a post introducing Intel oneAPI that included a simple installation guide of the Base Toolkit.

[Intel oneAPI Developer Tools -- Introduction and Install](https://www.pugetsystems.com/labs/hpc/Intel-oneAPI-Developer-Tools----Introduction-and-Install-2054/)

In that post I had deliberately excluded the "Intel Distribution for Python" from the Base Toolkit install for two reasons.

- Intel Python in the Base Toolkit includes "conda" on its path when you source "setvars.sh for the oneAPI environment. This would interfere with any Anaconda or Miniconda install that you may have already done (recommended!).  
- The second reason was that I was going to write this post! Installing Intel Python along with the packages from the oneAPI AI Toolkit in conda envs lets you use them along with your Anaconda/Miniconda install. This is much cleaner and a better workflow in my opinion. (You may have other preferences.)

Note:the Data Analytics, and Deep Neural Network libraries found in the oneAPI Base Toolkit are also used to accelerate the AI Analytics toolkit along with Intel Python.

**What about GPUs?**
This is really about Intel hardware. At this point oneAPI is primarily for (Intel) CPUs. There is some support Intel GPUs, but unsurprisingly, no support for NVIDIA hardware. I look at oneAPI as the future ecosystem for Intel's inevitable accelerator components. There are many hours of a data-scientists or machine learning practitioners time that are spent with tasks like data prep, big memory requirements/problems etc.. Good CPU performance and optimized software could be a big plus.  

## What is the oneAPI AI Analytics Toolkit

Here are the components of the [oneAPI AI Analytics Toolkit](https://software.intel.com/content/www/us/en/develop/tools/oneapi/ai-analytics-toolkit.html), 

- [Intel Distribution for Python](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/distribution-for-python.html): Intel's Python build. This contains a lot of standard numerical python packages. Including things like numpy, scipy, etc.. It's a very good/useful base python distribution. 
- [Intel Optimization for TensorFlow](https://software.intel.com/content/www/us/en/develop/articles/intel-optimization-for-tensorflow-installation-guide.html): Intel's optimized build of TensorFlow
- [Intel Optimization for PyTorch](https://software.intel.com/content/www/us/en/develop/articles/getting-started-with-intel-optimization-of-pytorch.html): Intel's optimized build of PyTorch
- [Intel Distribution of Modin](https://modin.readthedocs.io/en/latest/using_modin.html): Intel's optimized build of Modin (a fast parallel alternative to Pandas and Dask)
- [Model Zoo for Intel Architecture](https://github.com/IntelAI/models): GitHub repository of pretrained models optimized for running on Intel architecture.
- [Intel Low Precision Optimization Tool](https://www.intel.com/content/www/us/en/artificial-intelligence/posts/intel-low-precision-optimization-tool.html): This is a python library to to assist with deploying fast low-precision models for inference. It takes advantage of Intel **DL Boost and Vector Neural Network Instructions (VNNI)** that are part of second generation Xeon Scalable using AVX512. (These features are even included in the upcoming ["Rocket Lake" desktop processor](https://newsroom.intel.com/news/intels-11th-gen-processor-rocket-lake-s-architecture-detailed/).)  

**The Python conda package bundles for the components listed above are,**

- [intel-aikit-tensorflow](https://anaconda.org/intel/intel-aikit-tensorflow)
- [intel-aikit-pytorch](https://anaconda.org/intel/intel-aikit-pytorch)
- [intel-aikit-modin](https://anaconda.org/intel/intel-aikit-modin)

There are over 300 packages in the **[Intel channel on Anaconda Cloud](https://anaconda.org/intel/repo)**. Many of those packages are supplying python bindings for components of oneAPI. I expect there to be good python support for future Intel hardware accelerators. 

## Setting up the Intel oneAPI AI Toolkits with conda

**Prerequisites:**
- Well, these toolkits are optimized for Intel hardware, so yes, that's pretty much a requirement. I would also say "recent" Intel hardware with AVX512, DL Boost and VNNI, will likely perform the best. That means 2nd generation Xeon Scalable and Xeon W (maybe "Rocket Lake" too?).
- I am also, assuming that you have either a [full Anaconda Python](https://www.anaconda.com/products/individual) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html) install on your systems and that you are familiar with conda usage.


