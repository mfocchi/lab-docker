#!/usr/bin/env bash

REGISTRY_NAME=registry

if [ ! "$(docker ps -q -f name=$REGISTRY_NAME)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$REGISTRY_NAME)" ]; then
        # cleanup
        docker rm $REGISTRY_NAME
    fi
    # run the registry
    docker run -d -p 5000:5000 --restart=always --name $REGISTRY_NAME -v ./config/registry_config.yml:/etc/docker/registry/config.yml registry:2
fi


