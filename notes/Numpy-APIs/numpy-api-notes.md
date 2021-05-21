## Numpy APIs

Numpy is a Python module package for numerical computing with n-dimensional arrays. The internal data format is the ndarray. The ndarray representation is used by many other python packages for scientific computing and data science. The numpy operation syntax is also adopted to some extent in several ML frameworks. (TensorFlow 2, PyTorch, JAX) There is a movement to make it a standard API interface for numerical computing focused application that include a python API.

Here are some examples of "flavors" of numpy itself and applications that have some direct or at least similar syntax.

- Numpy (conda default with Intel MKL)
- Numpy (conda-forge with OpenBLAS )
- Numpy (from Intel optimized Python build )
- PyTorch ( similar syntax for many numpy operations and interoperable with it)
- TensorFlow 2.x ( TF has added an API for a subset of numpy )
- PAX (a newer Google project creating an accelerator capable numpy )
- CuPy (NVIDIA's SciPy implementation with a numpy implementation for GPU )
- MXNet
- Dask
- Xarray
- xtensor

        Array Library	Capabilities & Application areas
Dask	Dask	Distributed arrays and advanced parallelism for analytics, enabling performance at scale.
CuPy	CuPy	NumPy-compatible array library for GPU-accelerated computing with Python.
JAX	JAX	Composable transformations of NumPy programs: differentiate, vectorize, just-in-time compilation to GPU/TPU.
xarray	Xarray	Labeled, indexed multi-dimensional arrays for advanced analytics and visualization
sparse	Sparse	NumPy-compatible sparse array library that integrates with Dask and SciPy's sparse linear algebra.
PyTorch	PyTorch	Deep learning framework that accelerates the path from research prototyping to production deployment.
TensorFlow	TensorFlow	An end-to-end platform for machine learning to easily build and deploy ML powered applications.
MXNet	MXNet	Deep learning framework suited for flexible research prototyping and production.
arrow	Arrow	A cross-language development platform for columnar in-memory data and analytics.
xtensor	xtensor	Multi-dimensional arrays with broadcasting and lazy computing for numerical analysis.
xnd	XND	Develop libraries for array computing, recreating NumPy's foundational concepts.
uarray	uarray	Python backend system that decouples API from implementation; unumpy provides a NumPy API.
tensorly	TensorLy	Tensor learning, algebra and backends to seamlessly use NumPy, MXNet, PyTorch, TensorFlow or CuPy.



```
conda update conda
conda create --name np-anaconda  numpy 
conda create --name np-openblas -c conda-forge  numpy 
conda create --name np-intel -c intel numpy

This is linked with cuda 10.1 it hangs after libcudart.so loads on the A100 system
conda create --name tfgpu -c anaconda tensorflow-gpu   ... will use NGC container
```