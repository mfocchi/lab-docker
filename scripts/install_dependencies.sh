#!/bin/bash

RELEASE="latest"
PKGS_FOLDER="/root/dls_docker/pkgs_list"


add-apt-repository --yes "deb [trusted=yes] http://server-ubuntu18/repo/ stable/"
add-apt-repository --yes "deb [trusted=yes] http://server-ubuntu18/repo/ latest/"

add-apt-repository --yes ppa:danielrichter2007/grub-customizer

AMAZON_DEB_SERVER="deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main"
if grep -Fwq "$AMAZON_DEB_SERVER" /etc/apt/sources.list
then
	echo -e "${COLOR_INFO}$AMAZON_DEB_SERVER is already in the sources list! ${COLOR_RESET}"
else
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
	add-apt-repository "$AMAZON_DEB_SERVER"
fi

#Add Eigen backport PPA
export LANG=C.UTF-8
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ECD154D280FEB8AC
add-apt-repository --yes ppa:nschloe/eigen-backports

# Add CMake PPA
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

# Remove apt cache and update the sources
rm -rf /var/lib/apt/lists/*
apt-get update

apt-get install -y cmake-data=3.17.1-0kitware1 cmake=3.17.1-0kitware1 cmake-curses-gui=3.17.1-0kitware1 cmake-qt-gui=3.17.1-0kitware1

# Install external deps
# cat $PKGS_FOLDER/ext_dependencies_list.txt | grep -v \# | xargs sudo apt-get install -y --allow-downgrades
cat $PKGS_FOLDER/dls2_ext_dependencies_list.txt | grep -v \# | xargs apt-cache show >> versions.txt

PKGS=`cat $PKGS_FOLDER/dls2_ext_dependencies_list.txt | grep -v \#`

for PKG in $PKGS
do
	check_for_package_and_install $PKG
done
