#!/usr/bin/env bash

# Check args
if [ "$#" -lt 3 ]; then
	RELEASE=latest
else
	RELEASE=$3
fi
if [ "$#" -lt 2 ]; then
	CACHE_ON=false
else
	CACHE_ON=$2
fi
if [ "$#" -lt 1 ]; then
	echo "usage: ./build_docker.sh NAME [CACHE_ON] [RELEASE]"
	exit
else
	NAME=$1
fi

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./$NAME/Dockerfile --network=host --build-arg RELEASE="$RELEASE" --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
else
	echo "CACHE OFF"
	docker build -f ./$NAME/Dockerfile --network=host --no-cache --build-arg RELEASE="$RELEASE" --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
fi
