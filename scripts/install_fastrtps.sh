#!/bin/bash

sudo apt update
sudo apt install -y libasio-dev libtinyxml2-dev cmake

git clone https://github.com/eProsima/Fast-CDR.git
mkdir Fast-CDR/build && cd Fast-CDR/build
cmake ..
cmake --build . --target install
cd ../..

git clone https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build && cd build
cmake ..
cmake --build . --target install
cd ../..

git clone https://github.com/eProsima/Fast-RTPS.git
mkdir Fast-RTPS/build && cd Fast-RTPS/build
cmake ..
cmake --build . --target install
cd ../..
