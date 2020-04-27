#!/bin/bash

add-apt-repository --yes ppa:linuxuprising/java
add-apt-repository ppa:cwchien/gradle
rm -rf /var/lib/apt/lists/*
apt-get update


mkdir -p /var/cache/oracle-jdk11-installer-local
cd /var/cache/oracle-jdk11-installer-local
wget http://server-ubuntu18/java/jdk-11.0.7_linux-x64_bin.tar.gz
echo "oracle-java11-installer-local shared/accepted-oracle-license-v1-2 select true" | debconf-set-selections
echo "oracle-java11-installer shared/accepted-oracle-license-v1-2 select true" | debconf-set-selections

apt-get -y install oracle-java11-installer-local
apt-get -y install oracle-java11-set-default-local
apt-get -y install gradle
