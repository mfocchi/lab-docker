#!/bin/bash

# This script installs all of the IDE's used
# QT, meld, sublime, and atom
# GUI Tools - meld, gitg, gitk, git-cola, gedit

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
rm -rf /var/lib/apt/lists/*
apt-get update

apt-get install -y qt5-default qtcreator build-essential qt5-doc qt5-doc-html qtbase5-doc-html qtbase5-examples libfontconfig1 mesa-common-dev libglu1-mesa-dev

apt-get install -y sublime-text

apt-get install -y libgconf-2-4 libnss3 gvfs-bin xdg-utils libxss1 libxkbfile1 libcurl3
cd /root
wget https://atom.io/download/deb
dpkg -i deb
rm deb

apt-get install -y meld gitg gitk gedit
