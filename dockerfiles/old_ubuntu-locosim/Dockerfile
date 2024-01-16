# This dockerfile creates an ubuntu 16.04 image with ros-kinetic 
# and all the required dependencies to run locosim
ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO

LABEL maintainer="michele.focchi@unitn.it"

ARG USERNAME=mfocchi
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN echo "USER IS: " $USERNAME


RUN rm -rf /var/lib/apt/lists/*

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip
ENV SHELL /bin/bash



RUN apt-get install -y --no-install-recommends apt-utils build-essential software-properties-common sudo wget git curl


# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN apt-get install -y xserver-xorg-video-intel libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core #Needed by Gazebo
RUN apt install -y mesa-utils



# install other utils
RUN apt-get install -y gedit
RUN apt-get install -y git-all
RUN apt-get install -y gitg
RUN apt-get install -y curl
RUN apt-get install -y ros-kinetic-desktop-full


RUN sh -c "echo 'deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub $(lsb_release -sc) robotpkg' >> /etc/apt/sources.list.d/robotpkg.list"
RUN sh -c "echo 'deb [arch=amd64] http://robotpkg.openrobots.org/wip/packages/debian/pub $(lsb_release -sc) robotpkg' >> /etc/apt/sources.list.d/robotpkg.list"
RUN curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add -
RUN apt update


RUN apt install -y ros-$ROS_DISTRO-urdfdom-py
RUN apt install -y ros-$ROS_DISTRO-joint-state-publisher
RUN apt install -y ros-$ROS_DISTRO-joint-state-publisher-gui
RUN apt install -y ros-$ROS_DISTRO-joint-state-controller 
RUN apt install -y ros-$ROS_DISTRO-rviz-visual-tools
RUN apt install -y ros-$ROS_DISTRO-gazebo-msgs
RUN apt install -y ros-$ROS_DISTRO-control-toolbox
RUN apt install -y ros-$ROS_DISTRO-gazebo-ros
RUN apt install -y ros-$ROS_DISTRO-controller-manager
RUN apt install -y ros-$ROS_DISTRO-libqt-opengl-dev



RUN apt install -y python-scipy
RUN apt install -y python-matplotlib
RUN apt install -y python-termcolor


RUN rm -rf /var/lib/apt/lists/*
