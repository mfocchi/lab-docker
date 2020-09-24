#!/bin/bash

apt-get update
#Are all of these needed?
apt-get --no-install-recommends -y install build-essential libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libgl1-mesa-dev libglu1-mesa-dev libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev  libxcb-shm0-dev  libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev   libxkbcommon-dev libatspi2.0-dev
#libxcb-image0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-sync0-dev libxcd-xinerama-dev libxkbcommon-x11-dev

cd /tmp
wget http://server-ubuntu18/qt/qt-everywhere-src-5.15.1.tar.xz
tar xvf qt-everywhere-src-5.15.1.tar.xz
cd qt-everywhere-src-5.15.1
mkdir build
cd build
../configure -opensource -confirm-license -opengl desktop -prefix /opt/qt515
make -j8
make install
rm -rf /tmp/qt-everywhere-src-5.15.1
