#!/bin/bash

# Inlcude common functions

echo "Install fastrtps base dependencies"
echo "========================================================================="
apt-get install -y libasio-dev libtinyxml2-dev cmake

echo "Install FastCDR"
echo "========================================================================="
cd /root
git clone https://github.com/eProsima/Fast-CDR.git
mkdir Fast-CDR/build && cd Fast-CDR/build
cmake ..
cmake --build . --target install

echo "Install foonathan memory"
echo "========================================================================="
cd /root
git clone https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build && cd build
cmake ..
cmake --build . --target install

echo "Instal FastRTPS"
echo "========================================================================="
cd /root
git clone https://github.com/eProsima/Fast-RTPS.git
mkdir Fast-RTPS/build && cd Fast-RTPS/build
cmake ..
cmake --build . --target install

echo "Install fastrtpsgen"
echo "========================================================================="
cd /root
git clone --recursive https://github.com/eProsima/Fast-RTPS-Gen.git
cd Fast-RTPS-Gen
gradle assemble
cp -r /root/Fast-RTPS-Gen/share/* /usr/local/share
cp -r /root/Fast-RTPS-Gen/scripts/* /usr/local/bin
