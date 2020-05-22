ARG RELEASE
FROM server-gitlab-runner:5000/dls2-plugin-dev:$RELEASE
ARG RELEASE
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get update \
  && apt-get install -y --no-install-recommends dls2* \
  && rm -rf /var/lib/apt/lists/*
