#!/bin/bash

FOLDER=/root/dls_docker/scripts/package_lists
LIST=linux_tools.txt

PKGS=`cat $FOLDER/$LIST | grep -v \#`

for PKG in $PKGS; do
  if apt-cache show $PKG 1>/dev/null 2>&1; then
    apt-get -y install $PKG
  else
    echo ERROR: $PKG does not exist!
  fi
done
