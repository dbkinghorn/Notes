
3315  conda deactivate
 3316  ls
 3317  cd
 3318  ls
 3319  ls -a
 3320  cat .condarc
 3321  rm -rf miniconda3/
 3322  rm -rf .conda*
 3323  ls
 3324  cd Downloads/
 3325  ls
 3326  chmod 755 Miniforge3-Linux-x86_64.sh 
 3327  ls
 3328  ./Miniforge3-Linux-x86_64.sh 
 3329  conda config --set auto_activate_base false
 3330  conda create --name pytorch python=3.8 
 3331  conda activate pytorch
 3332  conda install -c pytorch pytorch torchvision torchaudio cudatoolkit=11.0
 3333  conda env list
 3334  conda create --name tf-oneapi -c intel intel-aikit-tensorflow
 3335  conda deactivate
 3336  conda env list
 3337  conda activate th-oneapi
 3338  conda install jupyterlab ipykernel
 3339  python -m ipykernel install --user --name th-oneapi --display-name "oneAPI PyTorch"
 3340  conda deactivate
 3341  conda create --name modin-oneapi intel-aikit-modin -c intel -c conda-forge
 3342  conda activate modin-oneapi
 3343  conda install jupyterlab ipykernel
 3344  python -m ipykernel install --user --name modin-oneapi --display-name "oneAPI Modin"
 3345  exit
 3346  conda create --name th-oneapi -c intel intel-aikit-pytorch
 3347  conda create --name tf-oneapi -c intel intel-aikit-tensorflow
 3348  conda activate tf-oneapi
 3349  conda install jupyterlab ipykernel
 3350  python -m ipykernel install --user --name tf-oneapi --display-name "oneAPI TensorFlow"
 