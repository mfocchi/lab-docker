#!/usr/bin/env bash

# Check args

CACHE_ON=false

# Get this script's path
#pushd `dirname $0` > /dev/null
#SCRIPTPATH=`pwd`
#popd > /dev/null

#SSH_PRIVATE_KEY=`cat $2/id_rsa | cut -d'-' -f 2 | cut -d'-' -f 1`
#SSH_PRIVATE_KEY="aaa"
#SSH_PUBLIC_KEY="bbb"

# Prepare the context
#cp $1/id_rsa ./dev/
#cp $1/id_rsa.pub ./dev/

#SSH_PRIVATE_KEY=`cat $2/id_rsa`
#SSH_PUBLIC_KEY=`cat $2/id_rsa.pub`

# Build the docker image
#docker build --build-arg GITLAB_IP=172.31.1.50 --build-arg SSH_PUBLIC_KEY=$SSH_PUBLIC_KEY --build-arg SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY -t $1 .


docker build -f ./env/Dockerfile-env --network=host --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" --build-arg GITLAB_IP=172.31.1.50 -t "dls-env" ./env/

