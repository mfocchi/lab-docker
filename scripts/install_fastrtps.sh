#!/bin/bash

# Inlcude common functions

echo "Install fastrtps base dependencies"
echo "========================================================================="
apt-get install -y libasio-dev libtinyxml2-dev cmake

echo "Install FastCDR"
echo "========================================================================="
git clone https://github.com/eProsima/Fast-CDR.git
mkdir Fast-CDR/build && cd Fast-CDR/build
cmake ..
cmake --build . --target install
cd ../..

echo "Install foonathan memory"
echo "========================================================================="
git clone https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build && cd build
cmake ..
cmake --build . --target install
cd ../..

echo "Instal FastRTPS"
echo "========================================================================="
git clone https://github.com/eProsima/Fast-RTPS.git
mkdir Fast-RTPS/build && cd Fast-RTPS/build
cmake ..
cmake --build . --target install
cd ../..

echo "Install fastrtpsgen"
echo "========================================================================="
git clone --recursive https://github.com/eProsima/Fast-RTPS-Gen.git
cd Fast-RTPS-Gen
gradle assemble
cp -r share/* /usr/local/share
cp -r scripts/* /usr/local/bin
cd ..
