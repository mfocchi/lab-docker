FROM ros:humble

SHELL ["/bin/bash", "-c"]

# Update to latest version
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/London"
RUN apt-get update

RUN sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/'   /etc/apt/apt.conf.d/docker-clean

# install ros package
RUN apt-get update && apt-get install -y   ros-${ROS_DISTRO}-desktop 

WORKDIR /root


CMD /bin/bash

# to build
# docker build --rm  --tag ros-humble . --file Dockerfile

# to run
# sudo docker run -v /tmp/.X11-unix/:/tmp/.X11-unix/ --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --network=host --name ubuntu_bash --env="DISPLAY" --rm -i -t ros-humble bash
