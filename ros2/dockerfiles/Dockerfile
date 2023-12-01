FROM ubuntu:focal
ARG ROS_VERSION=foxy
ARG USERNAME=mfocchi
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV TZ=Etc/UTC

RUN apt-get update &&  apt-get install -y gnupg

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections


RUN apt-get install  -y --no-install-recommends apt-utils build-essential software-properties-common sudo wget git curl
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Europe/Rome apt-get -y install software-properties-common 
RUN add-apt-repository universe
RUN apt-get install curl -y

# ROS2 source list
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null


# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8




RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN apt-get install -y xserver-xorg-video-intel libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core #Needed by Gazebo
RUN apt-get install -y mesa-utils


# install other utils
RUN apt-get install -y gedit
RUN apt-get install -y git-cola
RUN apt-get install -y gitg

# install ROS2

RUN apt-get update && apt install -y ros-$ROS_VERSION-desktop python3-argcomplete ros-dev-tools

RUN apt-get install -y ros-$ROS_VERSION-urdfdom-py
RUN apt-get install -y ros-$ROS_VERSION-srdfdom
RUN apt-get install -y ros-$ROS_VERSION-joint-state-publisher
RUN apt-get install -y ros-$ROS_VERSION-joint-state-publisher-gui
RUN apt-get install -y ros-$ROS_VERSION-joint-state-controller 
RUN apt-get install -y ros-$ROS_VERSION-gazebo-msgs
RUN apt-get install -y ros-$ROS_VERSION-control-toolbox
RUN apt-get install -y ros-$ROS_VERSION-controller-manager


ENV SHELL /bin/bash


