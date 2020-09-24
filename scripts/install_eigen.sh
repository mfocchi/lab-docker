#!/bin/bash

#Add Eigen backport PPA
export LANG=C.UTF-8 #why is this needed?
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ECD154D280FEB8AC
add-apt-repository --yes ppa:nschloe/eigen-backports
rm -rf /var/lib/apt/lists/*
apt-get update
apt-get install --no-install-recommends -y libeigen3-dev=3.3.2-1~ubuntu16.04.1~ppa1
rm -rf /var/lib/apt/lists/*
