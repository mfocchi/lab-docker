# Docker multi-stage build to get rid of the ssh keys
# FIRST BUILD
# this is our first build stage, it will not persist in the final image
FROM ubuntu:16.04 as cloning
MAINTAINER Gennaro Raiola <gennaro.raiola@iit.it>

# Args
ARG SSH_PRIVATE_KEY  
ARG SSH_PUBLIC_KEY 

# install git
RUN apt-get -y update && apt-get install -y --no-install-recommends apt-utils build-essential git openssh-client

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
#RUN ssh -vT git@gitlab.advr.iit.it #Debug
RUN git clone git@gitlab.advr.iit.it:dls-lab/installation_tools.git
RUN git clone git@gitlab.advr.iit.it:dls-lab/dls_gitlab_ci.git

# SECOND BUILD
FROM ubuntu:16.04

ARG RELEASE
RUN export INSTALL_DEPS=false
RUN export INSTALL_EXTRAS=true

# copy the repository form the previous image
COPY --from=cloning /installation_tools /root/installation_tools
COPY --from=cloning /dls_gitlab_ci /root/dls_gitlab_ci
RUN apt-get -y update && apt-get install -y --no-install-recommends apt-utils build-essential software-properties-common sudo wget
WORKDIR /root/installation_tools
RUN bash install_ros.sh
RUN bash install_dependencies.sh $INSTALL_DEPS $INSTALL_EXTRAS $RELEASE

