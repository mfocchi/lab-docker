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

apt-get -y install --no-install-recommends clang-3.9
apt-get -y install --no-install-recommends clang-4.0
apt-get -y install --no-install-recommends clang-5.0
apt-get -y install --no-install-recommends clang-6.0
apt-get -y install --no-install-recommends clang-8

update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.9 20 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-3.9
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-4.0 30 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-4.0
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-5.0 40 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-5.0
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 50 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-6.0
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8   60 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-8

update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 10
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 20

update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 10
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 20

#Defaults gcc-5, clang-8, gcc, g++
update-alternatives --set gcc /usr/bin/gcc-5
update-alternatives --set clang /usr/bin/clang-8
update-alternatives --set cc /usr/bin/gcc
update-alternatives --set c++ /usr/bin/g++

rm -rf /var/lib/apt/lists/*


