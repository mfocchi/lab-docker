#!/bin/bash

# Inlcude common functions

echo "Install Fast DDS base dependencies"
echo "========================================================================="
apt-get update
apt-get install -y --no-install-recommends libasio-dev libtinyxml2-dev cmake

echo "Install Fast CDR"
echo "========================================================================="
cd /root
git clone --branch v1.0.14 https://github.com/eProsima/Fast-CDR.git
mkdir Fast-CDR/build && cd Fast-CDR/build
cmake ..
cmake --build . --target install

echo "Install Foonathan Memory"
echo "========================================================================="
cd /root
git clone --branch v1.0.0 https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build && cd build
cmake ..
cmake --build . --target install

echo "Instal Fast DDS"
echo "========================================================================="
cd /root
git clone --branch v2.0.0 https://github.com/eProsima/Fast-DDS.git
mkdir Fast-DDS/build && cd Fast-DDS/build
cmake ..
cmake --build . --target install

echo "Install Fast DDS Gen"
echo "========================================================================="
cd /root
#git clone --branch v2.0.0 --recursive https://github.com/eProsima/Fast-DDS-Gen.git
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git
cd Fast-DDS-Gen
git checkout 1895c994416ae5ce63ed7c3e5a912f36a03aeceb
gradle assemble
cp -r /root/Fast-DDS-Gen/share/* /usr/local/share
cp -r /root/Fast-DDS-Gen/scripts/* /usr/local/bin

cd /root
rm -rf Fast-CDR
rm -rf Fast-DDS
rm -rf Fast-DDS-Gen
rm -rf foonathan_memory_vendor
rm -rf /var/lib/apt/lists/*

