#!/usr/bin/env bash

# Check args
if [ "$#" -eq 1 ]; then
  PATH_TO_SSH_FOLDER=$1
else
  if [ "$#" -eq 2 ]; then
    PUB_KEY=$1
    PRIV_KEY=$2
  else
    echo "usage: ./build_docker.sh PATH_TO_SSH_FOLDER or ./build_docker.sh PUB_KEY PRIV_KEY"
    exit
  fi
fi

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
cp $PATH_TO_SSH_FOLDER/id_rsa ./env/
cp $PATH_TO_SSH_FOLDER/id_rsa.pub ./env/

#SSH_PRIVATE_KEY=`cat $2/id_rsa`
#SSH_PUBLIC_KEY=`cat $2/id_rsa.pub`

# Build the docker image
#docker build --build-arg GITLAB_IP=172.31.1.50 --build-arg SSH_PUBLIC_KEY=$SSH_PUBLIC_KEY --build-arg SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY -t $1 .

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./env/Dockerfile-env --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-env" ./env/
else
	echo "CACHE OFF"
	docker build -f ./env/Dockerfile-env --no-cache --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-env" ./env/
fi
docker tag dls-env server-dev:5000/dls-env
docker push server-dev:5000/dls-env

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./rt/Dockerfile-rt --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-rt" ./rt/
else
	echo "CACHE OFF"
	docker build -f ./rt/Dockerfile-rt --no-cache --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-rt" ./rt/
fi
docker tag dls-rt server-dev:5000/dls-rt
docker push server-dev:5000/dls-rt

#if $CACHE_ON; then
#	echo "CACHE ON"
#	docker build -f ./dev/Dockerfile-dev --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-dev" ./dev/
#else
#	echo "CACHE OFF"
#	docker build -f ./dev/Dockerfile-dev --no-cache --network=host --build-arg GITLAB_IP=172.31.1.50 -t "dls-dev" ./dev/
#fi
#docker tag dls-dev server-dev:5000/dls-dev
#docker push server-dev:5000/dls-dev

#rm ./dev/id_rsa ./dev/id_rsa.pub
rm ./env/id_rsa ./env/id_rsa.pub
