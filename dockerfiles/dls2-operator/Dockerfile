ARG RELEASE
FROM server-gitlab-runner:5000/dls2-plugin-dev:$RELEASE
ARG RELEASE
RUN apt-get update \
  && apt-get install -y dls2*
