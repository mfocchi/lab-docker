#!/usr/bin/env bash


REGISTRY_NAME=registry

if [ "$(docker ps -q -f name=$REGISTRY_NAME)" ]; then
    # stop the registry
    docker stop $REGISTRY_NAME
    # cleanup
    docker rm $REGISTRY_NAME
fi
# run the registry
docker run -d -p 5000:5000 --restart=always --name $REGISTRY_NAME -v $(pwd)/config/registry_config.yml:/etc/docker/registry/config.yml registry:2
