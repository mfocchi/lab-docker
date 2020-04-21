ARG RELEASE
FROM server-dev:5000/dls-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libxenomai1 libxenomai-dev xenomai-kernel-source xenomai-runtime dls-distro-xeno/$RELEASE
