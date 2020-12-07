#!/bin/bash


# Add CMake PPA
echo 'Acquire::HTTPS::Proxy::apt.kitware.com "DIRECT";' | tee -a /etc/apt/apt.conf.d/proxy \
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main'
rm -rf /var/lib/apt/lists/*
apt-get update
apt-get install --no-install-recommends -y cmake-data=3.19.1-0kitware1 cmake=3.19.1-0kitware1 cmake-curses-gui=3.19.1-0kitware1 cmake-qt-gui=3.19.1-0kitware1
rm -rf /var/lib/apt/lists/*
