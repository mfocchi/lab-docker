#!/bin/bash

apt-get update
#Are all of these needed?
apt-get --no-install-recommends -y install build-essential libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libgl1-mesa-dev libglu1-mesa-dev libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev  libxcb-shm0-dev  libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev   libxkbcommon-dev libatspi2.0-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libxcb-sync0-dev libxcb-render-util0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-image0-dev

cd /tmp
wget http://server-ubuntu18/qt/qt-everywhere-src-5.15.1.tar.xz
tar xvf qt-everywhere-src-5.15.1.tar.xz
rm qt-everywhere-src-5.15.1.tar.xz
cd qt-everywhere-src-5.15.1
mkdir build
cd build
../configure -opensource -confirm-license -opengl desktop -prefix /opt/qt515
#-no-feature-webengine-system-libwebp is needed if there is a different version of libwebp installed
make -j8
make install

#Set custom qt as default
echo $'/opt/qt515/bin\n/opt/qt515/lib' > /usr/share/qtchooser/qt515.conf
ln -s /usr/share/qtchooser/qt515.conf /usr/lib/x86_64-linux-gnu/qtchooser/
rm -f /usr/lib/x86_64-linux-gnu/qtchooser/default.conf
cp /usr/lib/x86_64-linux-gnu/qtchooser/qt515.conf /usr/lib/x86_64-linux-gnu/qtchooser/default.conf

rm -rf /tmp/qt-everywhere-src-5.15.1