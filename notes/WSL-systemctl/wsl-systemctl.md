
## Adding systemctl functionality to WSL

There are some rough notes abotu adding some systemd functionality to WSL using 

https://github.com/gdraheim/docker-systemctl-replacement

wget https://github.com/gdraheim/docker-systemctl-replacement/archive/v1.5.4260.tar.gz

 mv /usr/bin/systemctl /usr/bin//systemctl.orig

 root@bach:/home/kinghorn/projects/docker-systemctl-replacement-1.5.4260/files/docker# cp systemctl3.py /usr/bin/systemctl

 FAILED for cockpit  ... not surprised ...

 