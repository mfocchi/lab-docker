#!/bin/bash

add-apt-repository --yes ppa:ubuntu-toolchain-r/test
rm -rf /var/lib/apt/lists/*
apt-get update
apt-get -y install --no-install-recommends gcc-9 g++-9
#update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
rm -rf /var/lib/apt/lists/*


