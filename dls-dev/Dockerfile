ARG RELEASE
FROM server-dev:5000/dls-env:$RELEASE
WORKDIR /root
RUN apt-get update && apt-get install -y dls-distro/$RELEASE
