# JupyterHub with JupyterLab Install using Conda

## Introduction

This is a quick note about setting up a JupyterHub server and JupyterLab using conda with Anaconda Python.

A few weeks ago I posted [Note: How To Install JupyterHub on a Local Server](https://www.pugetsystems.com/labs/hpc/Note-How-To-Install-JupyterHub-on-a-Local-Server-1673/) In that post I used the system Python3 and a virtenv with pip to install JupyterHub. That is a perfectly fine way to do the install but I think I prefer what is presented in this new post using conda. 

If you want to do this install yourself I recommend that you read through the post linked above since it contains more detail and discussion.

>This JupyterLab setup could be useful for sharing a server or workstation with a few other users. It could be used as a remote resource from a browser running on a laptop or workstation. It is not configured for public network access but would be useful over a VPN connection to "the office".

---

## Install extra packages

I needed to add curl on my Ubuntu 20.04 server test system, you may need other packages.
```
sudo apt-get install curl 
```

---

## Install conda (globally)

---

## Add apt repo for conda
```
curl -L https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | sudo apt-key add -
sudo echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee  /etc/apt/sources.list.d/conda.list 
```
## Install

This installs conda (miniconda Python environment) to /opt/conda
```
sudo apt-get update
sudo apt-get install conda
```

## Setup PATH and Environment for conda when users login
```
ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
```

---

## Install JupyterHub with conda

---

## Sudo to a root shell for the install and setup
```
sudo -s
```

## source the conda env for root
Using the "dot" command,
```
. /etc/profile.d/conda.sh
```

## Create a conda "env" for JupyterHub with JupyterLab and install
We will want ipywidgets installed here too.
```
conda create --name jupyterhub   jupyterhub jupyterlab ipywidgets
```

## create JupyterHub config file
Note: you will need to use full path to jupyterhub executable in the env.
```
mkdir -p /opt/conda/envs/jupyterhub/etc/jupyterhub
cd /opt/conda/envs/jupyterhub/etc/jupyterhub
/opt/conda/envs/jupyterhub/bin/jupyterhub --generate-config
```

## set default config to use JupyterLab
sed -i "s/#c\.Spawner\.default_url = ''/c\.Spawner\.default_url = '\/lab'/" jupyterhub_config.py


## Use systemd to start jupyterhub on boot

## Create a systemd "Unit" file for starting JupyterHub,

```
mkdir -p /opt/conda/envs/jupyterhub/etc/systemd
```
```
cat << EOF > /opt/conda/envs/jupyterhub/etc/systemd/jupyterhub.service
```
```
[Unit]
Description=JupyterHub
After=syslog.target network.target

[Service]
User=root
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/conda/envs/jupyterhub/bin"
ExecStart=/opt/conda/envs/jupyterhub/bin/jupyterhub -f /opt/conda/envs/jupyterhub/etc/jupyterhub/jupyterhub_config.py

[Install]
WantedBy=multi-user.target

EOF
```

## Link to OS systemd directory
ln -s /opt/conda/envs/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service

## Start JupyterHub, and enable it as a service,
```
systemctl start jupyterhub.service 
systemctl enable jupyterhub.service
```

---

That's it! You now have JupyterHub installed and running. It will be running on the ip address for the system you installed onto **using port 8000**.  Any user with a login account on the server will be able to access JupyterLab and use the machine.

There will be a default Python3 env available but will likely want to add some other "env's"  for users. You can add env's for all users as in the examples below. 

System-wide kernels are located in,
```
/usr/local/share/jupyter/kernels/
```

Individual users can create their own custom env's using conda in their home directory. Users env's will be located in 

```
$HOME/.local/share/jupyter/kernels/
```

## Add some extra (system-wide) kernels for JupyterLab

## Anaconda3 (full package)
```
sudo /opt/conda/bin/conda create --yes --name anaconda3 anaconda ipykernel
sudo /opt/conda/envs/anaconda3/bin/python -m ipykernel install --name 'anaconda3' --display-name "Anaconda3"
```

## TensorFlow 2.1 GPU

If your server has NVIDIA CUDA capable GPU's and the NVIDIA driver installed then you can add GPU accelerated env's.

```
sudo /opt/conda/bin/conda create --yes --name tensorflow2.1-gpu tensorflow-gpu ipykernel
sudo /opt/conda/envs/tensorflow2.1-gpu/bin/python -m ipykernel install --name 'tensorflow2.1-gpu' --display-name "ThensoFlow 2.1 GPU"
```

## PyTorch 1.4 GPU
```
sudo /opt/conda/bin/conda create --yes --name pytorch1.4-gpu ipykernel pytorch torchvision  cudatoolkit=10.1  -c pytorch 
sudo /opt/conda/envs/pytorch1.4-cpu/bin/python -m ipykernel install --name 'pytorch1.4' --display-name "PyTorch 1.4 CPU"
```

Enjoy! 