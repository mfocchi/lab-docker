ARG RELEASE
FROM server-dev:5000/dls-rt:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN apt-get install -y xserver-xorg-video-intel libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core #Needed by Gazebo
RUN apt-get update && apt-get install -y dls-distro/$RELEASE
