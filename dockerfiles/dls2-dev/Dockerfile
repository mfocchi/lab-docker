ARG RELEASE
FROM server-gitlab-runner:5000/dls2-env:$RELEASE
ARG RELEASE
WORKDIR /root/dls_docker/scripts
RUN bash install_ides.sh
