# Install JupyterHub on Local Server

Jupyter notebooks (and Jupyterlab) are wonderful web browser based workspaces. They are a mainstay for Machine-Learning and Data-Science development work. They can be launched from a personal workstation or laptop that has a Python setup with Jupyter installed. You will also find Jupyter notebooks installed on cloud resources for remote access.

The middle ground between local machine and cloud is to run Jupyter notebooks from a local ("on-prem") server with JupyterHub. This is allows a dedicated Linux server (or cluster) to provide a convenient easy to use computing resource for an individual or group of users. This post looks at installing JupyterHub and JupyterLab on a single "bare-metal" server.  

**This is a testing setup derived from ["Install JupyterHub and JupyterLab from the ground up"](https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html)**

## Base Server OS and software

This install testing configuration is using the following,

- Basic Ubuntu Server 18.04.4 
- NVIDIA driver 435 (from graphics-drivers ppa)
- extra packages:(apt install) build-essentials, openssh, emacs-nox, dkms, curl, python3-venv
- JupyterHub version 1.1.0

## Setup Plan

- JupyterHub installed with system Python in venv (virtual environment)
- conda installed from repo (updated along with system updates)
- System-wide shared; conda, Python3, and full base Anaconda3, for all users
- Users will be able to create their own private conda env's that will run from JupyterHub
- JupyterHub authentication from local system login (PAM)

## Install JupyterHub

Create a system python venv for JupyterHub
```
sudo python3 -m venv /opt/jupyterhub
```
pip install using the python3 from the venv (important!),
```
sudo /opt/jupyterhub/bin/python3 -m pip install wheel 
sudo /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab ipywidgets
```
Install nodejs for the http-proxy
```
sudo apt install nodejs npm
sudo npm install -g configurable-http-proxy
```
Create directory for jupyterhub config file and cd into it,
```
sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/
cd /opt/jupyterhub/etc/jupyterhub/
```
Generate config file,
```
sudo /opt/jupyterhub/bin/jupyterhub --generate-config
```
The generated jupyterhub_config.py file is nearly 1000 lines of commented configuration options. We will only change 1 line at this point, setting the default "spawner" to launch JupyterLab from the http-proxy URL. `grep -n c.Spawner.default jupyterhub_config.py` will show the line number that needs to be changed, 668 in my case.

Edit jupyterhub_config.py,
```
c.Spawner.default_url = '/lab'
```
Create a systemd "Unit" file for starting jupyterhub,
```
sudo mkdir -p /opt/jupyterhub/etc/systemd
```
edit
```
/opt/jupyterhub/etc/systemd/jupyterhub.service
```
to contain,
```
[Unit]
Description=JupyterHub
After=syslog.target network.target

[Service]
User=root
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin"
ExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py

[Install]
WantedBy=multi-user.target
```
Now link that file to the directory with the systems systemd Unit files,
```
sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service
```
Start jupyterhub, enable it as a service, and check that it is running,
sudo systemctl start jupyterhub.service 
sudo systemctl enable jupyterhub.service

sudo systemctl status jupyterhub.service
```
You should now have a jupyterhub server running on port 8000 listening on all interfaces on the system. Check the ip address for the server,
```
ip address
```
and then on your LAN from a separate system with a web browser enter that address and port 8000. In my case it was,
``` 
192.168.7.123:8000
```
You should see the JupyterHub login page. Any user with an account should be able to login with their username and password. At this point the only notebook kernel available will be the system Python3 that we installed JupyterHub with. We will remove that later. What we want, is a a couple of good notebook kernels from the Anaconda distribution for our defaults. Lets do that ...

## Install conda 

There is an officially maintained conda repository (both deb and rpm). Using that repo instead of installing miniconda3 or anaconda3 from the shell installer will allow conda to be kept up to date by normal system updates. We will use this conda to create envs that are basically miniconda3 (Python3 from anaconda) and the full anaconda3 module set. 

Note: the conda install is the same as installing miniconda3 i.e. it installs conda and a base Python3 from Anaconda Python.

Add the public key for the repo,
```
curl -L https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | sudo apt-key add -
```
Then add the repo to /etc/apt/sources.list.d
```
echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee  /etc/apt/sources.list.d/conda.list 
```
Install conda
```
sudo apt update
sudo apt install conda
```
conda installs into /opt/conda. In order to add it to users PATH we can link the provided environment script to the system profile.d directory.
```
sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
```

sudo mkdir /opt/conda/envs/

sudo /opt/conda/bin/conda create --prefix /opt/conda/envs/python python=3.7 ipykernel

sudo /opt/conda/envs/python/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (default)"


```



