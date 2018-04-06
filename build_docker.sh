#!/usr/bin/env bash

# Check args
if [ "$#" -ne 2 ]; then
  echo "usage: ./build_docker.sh NAME CACHE_ON"
  exit
fi

NAME=$1
CACHE_ON=$2

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./$NAME/Dockerfile --network=host --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
else
	echo "CACHE OFF"
	docker build -f ./$NAME/Dockerfile --network=host --no-cache --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
fi
