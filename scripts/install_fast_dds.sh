#!/bin/bash

# Inlcude common functions

echo "Install Fast DDS base dependencies"
echo "========================================================================="
apt-get update
apt-get install -y --no-install-recommends libasio-dev libtinyxml2-dev cmake python3-pip libyaml-cpp-dev python3-setuptools python3-colcon-common-extensions

echo "Install Fast CDR"
echo "========================================================================="
cd /root
git clone --branch v1.0.17 https://github.com/eProsima/Fast-CDR.git
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
git clone --branch v2.1.0 https://github.com/eProsima/Fast-DDS.git
mkdir Fast-DDS/build && cd Fast-DDS/build
cmake -DSHM_TRANSPORT_DEFAULT=OFF .. # IMPORTANT TODO fix shm
cmake --build . --target install

echo "Install Fast DDS Gen"
echo "========================================================================="
cd /root
#git clone --branch v2.0.0 --recursive https://github.com/eProsima/Fast-DDS-Gen.git
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git
cd Fast-DDS-Gen
git checkout c020ffdb593bb53483e3e95cc79b9c506c3c5144
gradle assemble
cp -r /root/Fast-DDS-Gen/share/* /usr/local/share
cp -r /root/Fast-DDS-Gen/scripts/* /usr/local/bin

echo "Install SOSS"
echo "========================================================================="
mkdir /opt/is-workspace
cd /opt/is-workspace
git clone https://git@github.com/eProsima/soss_v2 src/soss --recursive -b feature/xtypes-dds
git clone https://git@github.com/eProsima/SOSS-DDS src/soss-dds --recursive -b feature/xtypes-dds
cd src/soss-dds
git checkout origin/doc/examples -- examples/common
git checkout origin/doc/examples -- examples/ros1
sed -i '/find_package(soss-rosidl REQUIRED)/d' ./examples/common/ros1_std_msgs/CMakeLists.txt
cd ../..
git clone https://github.com/eProsima/soss-ros1.git src/soss-ros1 --recursive -b feature/xtypes-support

touch src/soss/packages/rosidl/COLCON_IGNORE
touch src/soss/packages/ros2/COLCON_IGNORE
touch src/soss/packages/ros2-test/COLCON_IGNORE
touch src/soss/packages/ros2-test-msg/COLCON_IGNORE
touch src/soss/packages/websocket/COLCON_IGNORE
touch src/soss/packages/websocket-test/COLCON_IGNORE
touch src/soss-dds/examples/common/ros2_std_msgs/COLCON_IGNORE

source /opt/ros/kinetic/setup.bash
export PREVIOUS=$(update-alternatives --query gcc | grep "Best:" | cut -d ":" -f2)
update-alternatives --set gcc /usr/bin/gcc-9
colcon build  --cmake-args -DCMAKE_BUILD_TYPE=RELEASE
echo $PREVIOUS
update-alternatives --set gcc /usr/bin/gcc-5

cd /root
rm -rf Fast-CDR
rm -rf Fast-DDS
rm -rf Fast-DDS-Gen
rm -rf foonathan_memory_vendor
rm -rf /var/lib/apt/lists/*

