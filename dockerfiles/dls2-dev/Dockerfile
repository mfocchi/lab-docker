ARG RELEASE
FROM server-harbor:80/dls2/dls2-env:$RELEASE
ARG RELEASE
WORKDIR /root/dls_docker/scripts
RUN bash install_ides.sh \
  && rm -rf /var/lib/apt/lists/*
