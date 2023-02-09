## TF 1.15 start dump with 2 x 4090
```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-06 16:45:53.026821: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 16:45:53.026821: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

2023-02-06 16:45:53.874232: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 16:45:53.874234: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
2023-02-06 16:45:54.375360: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 16:45:54.375567: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
Script arguments:
  --layers 50
  --batch_size 128
  --num_iter 90
  --iter_unit epoch
  --display_every 10
  --precision fp16
  --dali_threads 4
  --use_xla True
  --predict False
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmpeyzbvqjd
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

Training
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmp8g1bfvrc
Training
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

2023-02-06 16:45:57.772435: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2695080000 Hz
2023-02-06 16:45:57.772565: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x5f8a0c0 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 16:45:57.772590: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 16:45:57.773896: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 16:45:57.789188: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2695080000 Hz
2023-02-06 16:45:57.789350: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6a88530 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 16:45:57.789383: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 16:45:57.790353: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 16:45:57.871048: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.871317: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x5f88130 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 16:45:57.871332: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 4090, Compute Capability 8.9
2023-02-06 16:45:57.871666: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.871865: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 4090 major: 8 minor: 9 memoryClockRate(GHz): 2.52
pciBusID: 0000:61:00.0
2023-02-06 16:45:57.871882: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 16:45:57.899038: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.899286: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6a865a0 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 16:45:57.899302: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 4090, Compute Capability 8.9
2023-02-06 16:45:57.899523: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.899734: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 4090 major: 8 minor: 9 memoryClockRate(GHz): 2.52
pciBusID: 0000:41:00.0
2023-02-06 16:45:57.899752: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 16:45:57.915621: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 16:45:57.915635: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 16:45:57.920940: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 16:45:57.920953: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 16:45:57.921808: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 16:45:57.921813: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 16:45:57.938093: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 16:45:57.938107: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 16:45:57.940117: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 16:45:57.940229: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 16:45:57.940132: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 16:45:57.940235: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 16:45:57.940333: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.940345: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.940649: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.940658: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.940886: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 0
2023-02-06 16:45:57.940895: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 1
2023-02-06 16:45:57.944300: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 16:45:57.944309: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      1 
2023-02-06 16:45:57.944312: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 1:   N 
2023-02-06 16:45:57.944392: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 16:45:57.944401: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      0 
2023-02-06 16:45:57.944405: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 0:   N 
2023-02-06 16:45:57.944528: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.944530: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.944819: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.944834: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 16:45:57.945049: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19371 MB memory) -> physical GPU (device: 0, name: NVIDIA GeForce RTX 4090, pci bus id: 0000:41:00.0, compute capability: 8.9)
2023-02-06 16:45:57.945069: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19373 MB memory) -> physical GPU (device: 1, name: NVIDIA GeForce RTX 4090, pci bus id: 0000:61:00.0, compute capability: 8.9)
2023-02-06 16:45:58.880815: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 16:45:58.880842: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 16:45:59.725416: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
2023-02-06 16:45:59.725973: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
```
Then hangs!


## 2 x 3090 on Tr Pro
```
(tf1.15-ngc)kinghorn@trp64:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-06 23:21:57.726284: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 23:21:57.726287: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

2023-02-06 23:21:58.578557: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 23:21:58.578557: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
2023-02-06 23:21:59.075342: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 23:21:59.077592: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
Script arguments:
  --layers 50
  --batch_size 128
  --num_iter 90
  --iter_unit epoch
  --display_every 10
  --precision fp16
  --dali_threads 4
  --use_xla True
  --predict False
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmplg66fa28
WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmp7app3vno
Training
Training
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

2023-02-06 23:22:02.478283: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2694955000 Hz
2023-02-06 23:22:02.478435: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x64db3b0 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 23:22:02.478470: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 23:22:02.480142: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 23:22:02.486239: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2694955000 Hz
2023-02-06 23:22:02.486364: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6d796b0 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 23:22:02.486392: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 23:22:02.487362: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 23:22:02.611689: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.615635: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.615981: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6d77720 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 23:22:02.615999: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 3090, Compute Capability 8.6
2023-02-06 23:22:02.616080: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x64d9420 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 23:22:02.616101: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 3090, Compute Capability 8.6
2023-02-06 23:22:02.616354: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.616374: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.616750: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 3090 major: 8 minor: 6 memoryClockRate(GHz): 1.695
pciBusID: 0000:41:00.0
2023-02-06 23:22:02.616769: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 23:22:02.616769: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 3090 major: 8 minor: 6 memoryClockRate(GHz): 1.695
pciBusID: 0000:61:00.0
2023-02-06 23:22:02.616791: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 23:22:02.667075: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 23:22:02.667087: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 23:22:02.672171: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 23:22:02.672189: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 23:22:02.673070: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 23:22:02.673073: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 23:22:02.690137: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 23:22:02.690143: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 23:22:02.692278: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 23:22:02.692284: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 23:22:02.692384: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 23:22:02.692388: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 23:22:02.692492: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.692501: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.692832: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.692839: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.693057: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 1
2023-02-06 23:22:02.693066: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 0
2023-02-06 23:22:02.696903: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 23:22:02.696912: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      0 
2023-02-06 23:22:02.696917: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 0:   N 
2023-02-06 23:22:02.697033: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 23:22:02.697042: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      1 
2023-02-06 23:22:02.697046: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 1:   N 
2023-02-06 23:22:02.697119: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.697147: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.697396: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.697405: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1082] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2023-02-06 23:22:02.697650: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19405 MB memory) -> physical GPU (device: 0, name: NVIDIA GeForce RTX 3090, pci bus id: 0000:41:00.0, compute capability: 8.6)
2023-02-06 23:22:02.697656: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19407 MB memory) -> physical GPU (device: 1, name: NVIDIA GeForce RTX 3090, pci bus id: 0000:61:00.0, compute capability: 8.6)
2023-02-06 23:22:03.630551: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 23:22:03.653321: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 23:22:04.482903: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
2023-02-06 23:22:04.490662: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
  Step Epoch Img/sec   Loss  LR
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:67: The name tf.train.SessionRunArgs is deprecated. Please use tf.estimator.SessionRunArgs instead.

2023-02-06 23:22:09.559051: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 23:22:09.582708: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 23:22:10.288384: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 23:22:10.314683: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 23:22:10.812718: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 23:22:10.816267: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
     1   1.0    13.4  7.683  8.655 2.00000
2023-02-06 23:22:28.675089: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 23:22:28.731539: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
    10  10.0   182.3  4.135  5.108 1.62000
    20  20.0  2043.1  0.166  1.144 1.24469
    30  30.0  2048.4  0.082  1.063 0.91877
    40  40.0  2044.0  0.102  1.084 0.64222
    50  50.0  2040.3  0.106  1.090 0.41506
    60  60.0  2044.4  0.090  1.075 0.23728
    70  70.0  2042.2  0.015  1.002 0.10889
    80  80.0  2040.1  0.006  0.993 0.02988
    90  90.0  1488.5  0.001  0.987 0.00025
```

## Xeon with 2 x 4090 runs fine
```
(tf1.15-ngc)kinghorn@xeon33:/workspace/nvidia-examples/cnn$ CUDA_VISIBLE_DEVICES=0,1 mpiexec -np 2 python resnet.py --layers=50 --batch_size=128 --precision=fp16
2023-02-06 15:59:18.065995: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 15:59:18.065999: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:Deprecation warnings have been disabled. Set TF_ENABLE_DEPRECATION_WARNINGS=1 to re-enable them.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/optimizers.py:22: The name tf.train.Optimizer is deprecated. Please use tf.compat.v1.train.Optimizer instead.

2023-02-06 15:59:19.025590: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 15:59:19.025830: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use sklearn by default. This improves performance in some cases. To enable sklearn export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Dask by default. This improves performance in some cases. To enable Dask export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:TensorFlow will not use Pandas by default. This improves performance in some cases. To enable Pandas export the environment variable  TF_ALLOW_IOLIBS=1.
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:49: The name tf.train.SessionRunHook is deprecated. Please use tf.estimator.SessionRunHook instead.

PY 3.8.10 (default, Nov 14 2022, 12:59:47) 
[GCC 9.4.0]
TF 1.15.5
2023-02-06 15:59:21.171119: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 15:59:21.171154: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmppx5rj2tv
Script arguments:
  --layers 50
  --batch_size 128
  --num_iter 90
  --iter_unit epoch
  --display_every 10
  --precision fp16
  --dali_threads 4
  --use_xla True
  --predict False
Training
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:247: The name tf.GPUOptions is deprecated. Please use tf.compat.v1.GPUOptions instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:248: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:252: The name tf.OptimizerOptions is deprecated. Please use tf.compat.v1.OptimizerOptions instead.

WARNING:tensorflow:Using temporary folder as model directory: /tmp/tmp28oo3n4a
Training
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:135: The name tf.truncated_normal is deprecated. Please use tf.random.truncated_normal instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/image_processing.py:140: The name tf.random_uniform is deprecated. Please use tf.random.uniform instead.

WARNING:tensorflow:
The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
  * https://github.com/tensorflow/io (for I/O related ops)
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:41: The name tf.add_to_collection is deprecated. Please use tf.compat.v1.add_to_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:30: The name tf.variable_scope is deprecated. Please use tf.compat.v1.variable_scope instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/var_storage.py:16: The name tf.get_default_graph is deprecated. Please use tf.compat.v1.get_default_graph instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:135: The name tf.losses.sparse_softmax_cross_entropy is deprecated. Please use tf.compat.v1.losses.sparse_softmax_cross_entropy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.get_collection is deprecated. Please use tf.compat.v1.get_collection instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:138: The name tf.GraphKeys is deprecated. Please use tf.compat.v1.GraphKeys instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:141: The name tf.metrics.accuracy is deprecated. Please use tf.compat.v1.metrics.accuracy instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:143: The name tf.metrics.mean is deprecated. Please use tf.compat.v1.metrics.mean instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:145: The name tf.summary.scalar is deprecated. Please use tf.compat.v1.summary.scalar instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:155: The name tf.train.polynomial_decay is deprecated. Please use tf.compat.v1.train.polynomial_decay instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:156: The name tf.train.get_global_step is deprecated. Please use tf.compat.v1.train.get_global_step instead.

WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:159: The name tf.train.MomentumOptimizer is deprecated. Please use tf.compat.v1.train.MomentumOptimizer instead.

2023-02-06 15:59:25.276724: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2700000000 Hz
2023-02-06 15:59:25.276917: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6089900 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 15:59:25.276937: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 15:59:25.278528: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 15:59:25.393206: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x6087970 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 15:59:25.393225: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 4090, Compute Capability 8.9
2023-02-06 15:59:25.401246: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 4090 major: 8 minor: 9 memoryClockRate(GHz): 2.52
pciBusID: 0000:c3:00.0
2023-02-06 15:59:25.401264: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 15:59:25.448153: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 15:59:25.452065: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 15:59:25.453031: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 15:59:25.469610: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 15:59:25.471812: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 15:59:25.471933: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 15:59:25.472213: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 1
2023-02-06 15:59:25.477092: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 15:59:25.477106: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      1 
2023-02-06 15:59:25.477110: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 1:   N 
2023-02-06 15:59:25.477570: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19347 MB memory) -> physical GPU (device: 1, name: NVIDIA GeForce RTX 4090, pci bus id: 0000:c3:00.0, compute capability: 8.9)
2023-02-06 15:59:25.576724: I tensorflow/core/platform/profile_utils/cpu_utils.cc:109] CPU Frequency: 2700000000 Hz
2023-02-06 15:59:25.576942: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x509def0 initialized for platform Host (this does not guarantee that XLA will be used). Devices:
2023-02-06 15:59:25.576965: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): Host, Default Version
2023-02-06 15:59:25.577945: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcuda.so.1
2023-02-06 15:59:25.657332: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x509bf60 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
2023-02-06 15:59:25.657356: I tensorflow/compiler/xla/service/service.cc:176]   StreamExecutor device (0): NVIDIA GeForce RTX 4090, Compute Capability 8.9
2023-02-06 15:59:25.657625: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1674] Found device 0 with properties: 
name: NVIDIA GeForce RTX 4090 major: 8 minor: 9 memoryClockRate(GHz): 2.52
pciBusID: 0000:51:00.0
2023-02-06 15:59:25.657645: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudart.so.12
2023-02-06 15:59:25.674852: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 15:59:25.676003: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcufft.so.11
2023-02-06 15:59:25.676219: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcurand.so.10
2023-02-06 15:59:25.677922: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusolver.so.11
2023-02-06 15:59:25.678432: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcusparse.so.12
2023-02-06 15:59:25.678541: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 15:59:25.678816: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1802] Adding visible gpu devices: 0
2023-02-06 15:59:25.682205: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1214] Device interconnect StreamExecutor with strength 1 edge matrix:
2023-02-06 15:59:25.682216: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1220]      0 
2023-02-06 15:59:25.682221: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1233] 0:   N 
2023-02-06 15:59:25.682519: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1359] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 19373 MB memory) -> physical GPU (device: 0, name: NVIDIA GeForce RTX 4090, pci bus id: 0000:51:00.0, compute capability: 8.9)
2023-02-06 15:59:26.884336: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 15:59:26.982430: I tensorflow/compiler/jit/xla_compilation_cache.cc:241] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
2023-02-06 15:59:28.100600: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
2023-02-06 15:59:28.209320: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1820] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
  Step Epoch Img/sec   Loss  LR
WARNING:tensorflow:From /opt/tensorflow/nvidia-examples/cnn/nvutils/runner.py:67: The name tf.train.SessionRunArgs is deprecated. Please use tf.estimator.SessionRunArgs instead.

2023-02-06 15:59:35.022000: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 15:59:35.023535: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 15:59:36.205205: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 15:59:36.205710: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcudnn.so.8
2023-02-06 15:59:37.046436: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
2023-02-06 15:59:37.052016: I tensorflow/stream_executor/platform/default/dso_loader.cc:50] Successfully opened dynamic library libcublas.so.12
     1   1.0    12.4  7.839  8.810 2.00000
2023-02-06 15:59:55.628860: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
2023-02-06 15:59:55.768853: I tensorflow/core/grappler/optimizers/generic_layout_optimizer.cc:353] Cancel Transpose nodes around Pad: transpose_before=transpose pad=fp32_vars/Pad transpose_after=fp32_vars/conv2d/Conv2D-0-TransposeNCHWToNHWC-LayoutOptimizer,gradients/fp32_vars/conv2d/Conv2D_grad/Conv2DBackpropFilter-0-TransposeNCHWToNHWC-LayoutOptimizer
    10  10.0   138.8  4.253  5.225 1.62000
    20  20.0  2102.6  0.069  1.046 1.24469
    30  30.0  2122.3  0.029  1.009 0.91877
    40  40.0  2124.2  0.055  1.036 0.64222
    50  50.0  2106.6  0.039  1.022 0.41506
    60  60.0  2131.1  0.084  1.069 0.23728
    70  70.0  2117.8  0.073  1.059 0.10889
    80  80.0  2118.4  0.008  0.994 0.02988
    90  90.0  1304.2  0.001  0.988 0.00025

```