ARG RELEASE
FROM server-dev:5000/dls-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install ros-kinetic-desktop-full
