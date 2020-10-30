# Docker multi-stage build to get rid of the ssh keys
# FIRST BUILD
# this is our first build stage, it will not persist in the final image
FROM nvidia/opengl:1.1-glvnd-runtime-ubuntu16.04 as cloning
MAINTAINER Geoff Fink <geoff.fink@iit.it>

# Args
ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY

RUN echo 'Acquire::http { Proxy "http://server-apt:3142"; }' | tee -a /etc/apt/apt.conf.d/proxy
RUN echo 'Acquire::HTTP::Proxy::server-apt "DIRECT";' | tee -a /etc/apt/apt.conf.d/proxy
RUN echo 'Acquire::HTTPS::Proxy::developer.download.nvidia.com "DIRECT";' | tee -a /etc/apt/apt.conf.d/proxy

# install git
RUN apt-get -y update && apt-get install -y --no-install-recommends apt-utils build-essential git openssh-client apt-transport-https

# Make SSH available
EXPOSE 22:22

# add credentials on build
RUN mkdir /root/.ssh/
RUN echo "$SSH_PUBLIC_KEY" > /root/.ssh/id_rsa.pub
RUN echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub  >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa.pub

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan gitlab.advr.iit.it >> /root/.ssh/known_hosts
RUN echo "Host *\n\tStrictHostKeyChecking no\n\n" > /root/.ssh/config

# add here the git clones
RUN git clone git@gitlab.advr.iit.it:dls-lab/dls_gitlab_ci.git -b dls2
RUN git clone git@gitlab.advr.iit.it:dls-lab/dls_docker.git -b dls2

# SECOND BUILD
FROM nvidia/opengl:1.1-glvnd-runtime-ubuntu16.04


# copy the repository form the previous image
COPY --from=cloning /dls_gitlab_ci /root/dls_gitlab_ci
COPY --from=cloning /dls_docker /root/dls_docker
RUN echo 'Acquire::http { Proxy "http://server-apt:3142"; }' | tee -a /etc/apt/apt.conf.d/proxy \
  && echo 'Acquire::HTTP::Proxy::server-apt "DIRECT";' | tee -a /etc/apt/apt.conf.d/proxy \
  && echo 'Acquire::HTTPS::Proxy::developer.download.nvidia.com "DIRECT";' | tee -a /etc/apt/apt.conf.d/proxy \
  && apt-get -y update && apt-get install -y --no-install-recommends apt-utils software-properties-common apt-transport-https \
  && bash  -c " \
    /root/dls_docker/scripts/install_linux_tools.sh ; \
    /root/dls_docker/scripts/install_gcc.sh ; \
    /root/dls_docker/scripts/install_cmake.sh ; \
    /root/dls_docker/scripts/install_java.sh ; \
    /root/dls_docker/scripts/install_qt.sh ; \
    /root/dls_docker/scripts/install_eigen.sh ; \
    /root/dls_docker/scripts/install_fast_dds.sh ; \
    /root/dls_docker/scripts/install_ros.sh ; \
    /root/dls_docker/scripts/install_dls2.sh ; \
    /root/dls_docker/scripts/install_dls-plugins.sh ; \
    /root/dls_docker/scripts/install_dependencies.sh ; \
    " \
  && rm -rf /var/lib/apt/lists/*
