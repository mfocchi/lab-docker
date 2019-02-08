ARG RELEASE
FROM server-dev:5000/dls-rt:$RELEASE
ARG RELEASE
ARG INSTALL_DEPS=true
ARG INSTALL_EXTRAS=true
WORKDIR /root/installation_tools
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN apt-get install -y xserver-xorg-video-intel libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core #Needed by Gazebo
RUN apt-get install -y dls-distro/$RELEASE
RUN bash install_dependencies.sh $INSTALL_DEPS $INSTALL_EXTRAS $RELEASE

