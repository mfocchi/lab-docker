ARG RELEASE
FROM server-harbor:80/dls2/dls2-plugin-dev-nvidia:$RELEASE
ARG RELEASE
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get update \
  && apt-get install -y --no-install-recommends dls2-controller-trunk dls2-messaging-trunk_controller \
  && rm -rf /var/lib/apt/lists/*
