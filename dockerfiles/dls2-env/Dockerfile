# Docker multi-stage build to get rid of the ssh keys
# FIRST BUILD
# this is our first build stage, it will not persist in the final image
FROM ubuntu:16.04 as cloning
MAINTAINER Geoff Fink <geoff.fink@iit.it>

# Args
ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY

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
RUN git clone git@gitlab.advr.iit.it:dls-lab/installation_tools.git -b dls2
RUN git clone git@gitlab.advr.iit.it:dls-lab/dls_gitlab_ci.git -b dls2
RUN git clone git@gitlab.advr.iit.it:dls-lab/dls_docker.git -b dls2

# SECOND BUILD
FROM ubuntu:16.04

ARG RELEASE
ARG INSTALL_DEPS=true
ARG INSTALL_EXTRAS=false

# copy the repository form the previous image
COPY --from=cloning /installation_tools /root/installation_tools
COPY --from=cloning /dls_gitlab_ci /root/dls_gitlab_ci
COPY --from=cloning /dls_docker /root/dls_docker
RUN apt-get -y update && apt-get install -y --no-install-recommends apt-utils software-properties-common apt-transport-https
WORKDIR /root/dls_docker/scripts
RUN bash install_linux_tools.sh
RUN bash install_java.sh
RUN bash install_fastrtps.sh
RUN bash install_ros.sh
RUN bash install_dls2.sh
RUN bash install_dls-plugins.sh
WORKDIR /root/installation_tools
#RUN bash install_scripts/install_ros.sh
RUN bash install_scripts/install_dependencies.sh $INSTALL_DEPS $INSTALL_EXTRAS $RELEASE
