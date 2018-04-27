#!/usr/bin/env bash

# Check args
if [ "$#" -ne 3 ]; then
  echo "usage: ./push_docker.sh NAME REGISTRY TAG"
  exit
fi

NAME=$1
REGISTRY=$2
TAG=$3

docker tag $NAME $REGISTRY/$NAME:$TAG
docker push $REGISTRY/$NAME:$TAG
