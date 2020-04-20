ARG RELEASE
FROM server-gitlab-runner:5000/dls2-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libxenomai1 libxenomai-dev xenomai-kernel-source xenomai-runtime
