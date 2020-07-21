#!/bin/bash

RELEASE="latest"
PKGS_FOLDER=/root/dls_docker/scripts/package_lists


echo "deb [trusted=yes] http://server-ubuntu18/repo/ stable/" > /etc/apt/sources.list.d/dls-stable.list
echo "deb [trusted=yes] http://server-ubuntu18/repo/ latest/" > /etc/apt/sources.list.d/dls-latest.list


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
wget -O - http://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
apt-add-repository 'deb http://apt.kitware.com/ubuntu/ bionic main'

# Remove apt cache and update the sources
rm -rf /var/lib/apt/lists/*
apt-get update

apt-get install --no-install-recommends -y cmake-data=3.18.0-0kitware1 cmake=3.18.0-0kitware1 cmake-curses-gui=3.18.0-0kitware1 cmake-qt-gui=3.18.0-0kitware1

# Install external deps
# cat $PKGS_FOLDER/ext_dependencies_list.txt | grep -v \# | xargs sudo apt-get install -y --allow-downgrades
cat $PKGS_FOLDER/dls2_ext_dependencies_list.txt | grep -v \# | xargs apt-cache show >> versions.txt

PKGS=`cat $PKGS_FOLDER/dls2_ext_dependencies_list.txt | grep -v \#`

for PKG in $PKGS
do
	if apt-cache show $PKG 1>/dev/null 2>&1; then
    apt-get -y install --no-install-recommends $PKG
  else
    echo ERROR: $PKG does not exist!
  fi
done

rm -rf /var/lib/apt/lists/*
