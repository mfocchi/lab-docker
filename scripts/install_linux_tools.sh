#!/bin/bash

$FOLDER=package_lists
$LIST=linux_tools.txt

PKGS=`cat $FOLDER/$LIST | grep -v \#`

for PKG in $PKGS; do
  if apt-cache show $PKG 1>/dev/null 2>&1; then`
    sudo apt-get -y install $PKG
  else
    echo ERROR: $PKG does not exist!
done
