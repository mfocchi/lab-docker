#!/usr/bin/env bash

# loop on them
NAMES="dls-env dls-rt dls-dev"

# This has to be scheduled
RELEASE=$1
CACHE_ON=false
REGISTRY=server-dev:5000

for NAME in $NAMES

do
	./build_docker.sh $NAME $CACHE_ON $RELEASE
	./push_docker.sh $NAME $REGISTRY $RELEASE
done
