#!/bin/bash

add-apt-repository --yes ppa:linuxuprising/java
add-apt-repository ppa:cwchien/gradle
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update

wget http://server-ubuntu18/java/jdk-11.0.7_linux-x64_bin.tar.gz
mkdir -p /var/cache/oracle-jdk11-installer-local
mv jdk-11.0.7_linux-x64_bin.tar.gz /var/cache/oracle-jdk11-installer-local/
echo "oracle-java11-installer-local shared/accepted-oracle-license-v1-2 select true" | sudo debconf-set-selections
echo "oracle-java11-installer shared/accepted-oracle-license-v1-2 select true" | sudo debconf-set-selections

apt-get -y install oracle-java11-installer-local
apt-get -y install oracle-java11-set-default-local
apt-get -y install gradle
