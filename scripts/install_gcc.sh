#!/bin/bash

add-apt-repository --yes ppa:ubuntu-toolchain-r/test
rm -rf /var/lib/apt/lists/*
apt-get update
apt-get -y install --no-install-recommends gcc-5 g++-5
apt-get -y install --no-install-recommends gcc-6 g++-6
apt-get -y install --no-install-recommends gcc-7 g++-7
apt-get -y install --no-install-recommends gcc-8 g++-8
apt-get -y install --no-install-recommends gcc-9 g++-9
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9
update-alternatives --set gcc /usr/bin/gcc-5
rm -rf /var/lib/apt/lists/*


