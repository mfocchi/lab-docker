#!/bin/bash

FOLDER=/root/dls_docker/scripts/package_lists
LIST=linux_tools.txt

PKGS=`cat $FOLDER/$LIST | grep -v \#`

for PKG in $PKGS; do
  if apt-cache show $PKG 1>/dev/null 2>&1; then
    apt-get -y install --no-install-recommends $PKG
  else
    echo ERROR: $PKG does not exist!
  fi
done


# Install gtest
if [ -d "/usr/src/gtest" ]; then
	cd /usr/src/gtest
	cmake CMakeLists.txt
	make
	cp *.a /usr/lib
fi
