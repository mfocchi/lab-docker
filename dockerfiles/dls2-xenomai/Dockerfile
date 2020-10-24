ARG RELEASE
FROM server-harbor:80/dls2/dls2-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get update \
  && apt-get install -y libxenomai1 libxenomai-dev xenomai-kernel-source xenomai-runtime
