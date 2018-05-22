ARG RELEASE
FROM server-dev:5000/dls-rt:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y dls-distro/$RELEASE
