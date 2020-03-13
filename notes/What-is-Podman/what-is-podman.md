#Podman

```
bob@jhub:~/project-bob$ cat /etc/subuid
lxd:100000:65536
root:100000:65536
kinghorn:165536:65536
bob:231072:65536
```

```
  IDMappings:
    gidmap:
    - container_id: 0
      host_id: 1001
      size: 1
    - container_id: 1
      host_id: 231072
      size: 65536
    uidmap:
    - container_id: 0
      host_id: 1001
      size: 1
    - container_id: 1
      host_id: 231072
      size: 65536
```

```
  IDMappings:
    gidmap:
    - container_id: 0
      host_id: 1000
      size: 1
    - container_id: 1
      host_id: 165536
      size: 65536
    uidmap:
    - container_id: 0
      host_id: 1000
      size: 1
    - container_id: 1
      host_id: 165536
      size: 65536
```

```
kinghorn@jhub:~/projects$ podman run  --rm -it --hooks-dir /usr/share/containers/oci/hooks.d nvcr.io/nvidia/tensorflow:19.02-py3
```

## Installing Podman

https://build.opensuse.org/project/show/devel:kubic:libcontainers:stable

for VERSION_ID use 19.10   i.e. xUbuntu_19.10

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -

sudo apt-get update

sudo apt install podman 



