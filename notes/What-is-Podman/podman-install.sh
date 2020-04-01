#!/usr/bin/env bash

## Installing Podman
# repo source
# https://build.opensuse.org/project/show/devel:kubic:libcontainers:stable

VERSION_ID="19.10"   # this is repo xUbuntu_19.10 which is most up to date at this time

echo "Installing Podman with version ID = ${VERSION_ID}"

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -

sudo apt-get update

sudo apt install -y podman
