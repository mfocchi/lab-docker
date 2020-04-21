#!/usr/bin/env bash

# Check args
if [ "$#" -lt 4 ]; then
	LOCAL_BUILD=false
else
	LOCAL_BUILD=$4
fi
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
	echo "usage: ./build_docker.sh NAME [CACHE_ON] [RELEASE] [LOCAL_BUILD]"
	exit
else
	NAME=$1
fi

#Extract the ssh keys
if [ $LOCAL_BUILD == true ]; then
	echo "Selected a local build, exporting the SSH KEYS from the .ssh folder"
	export SSH_PRIVATE_KEY=`cat $HOME/.ssh/id_rsa`
	export SSH_PUBLIC_KEY=`cat $HOME/.ssh/id_rsa.pub`
fi

if $CACHE_ON; then
	echo "CACHE ON"
	docker build -f ./dockerfiles/$NAME/Dockerfile --network=host --build-arg RELEASE="$RELEASE" --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
else
	echo "CACHE OFF"
	docker build -f ./dockerfiles/$NAME/Dockerfile --network=host --no-cache --build-arg RELEASE="$RELEASE" --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" -t $NAME ./$NAME/
fi
