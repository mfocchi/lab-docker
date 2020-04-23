ARG RELEASE
FROM server-gitlab-runner:5000/dls2-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y ros-kinetic-desktop-full
