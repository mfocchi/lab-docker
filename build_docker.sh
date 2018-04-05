#!/usr/bin/env bash

# Check args
if [ "$#" -ne 2 ]; then
  echo "usage: ./build_docker.sh ID CACHE_ON"
  exit
fi

ID=$1
CACHE_ON=$2

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./$ID/Dockerfile-$ID --network=host --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t dls-$ID ./$ID/
else
	echo "CACHE OFF"
	docker build -f ./$ID/Dockerfile-$ID --network=host --no-cache --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t dls-$ID ./$ID/
fi
