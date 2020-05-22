#!/bin/bash

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'

# Use the new ros key, see https://answers.ros.org/question/325039/apt-update-fails-cannot-install-pkgs-key-not-working/
sudo -E apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt-get update
sudo apt-get -y install --no-install-recommends ros-kinetic-ros-base
sudo rosdep init
rosdep update
rm -rf /var/lib/apt/lists/*
