#!/usr/bin/env bash

# Check args
if [ "$#" -lt 5 ]; then
	REGISTRY=server-harbor:80
else
	REGISTRY=$5
fi
if [ "$#" -lt 4 ]; then
	LOCAL_BUILD=true
else
	LOCAL_BUILD=$4
fi
if [ "$#" -lt 3 ]; then
	CACHE_ON=false
else
	CACHE_ON=$3
fi
if [ "$#" -lt 2 ]; then
	NAMES="dls2/dls2-env dls2/dls2-dev"
else
	NAMES=$2
fi
if [ "$#" -lt 1 ]; then
	echo "usage: ./preamble.sh RELEASE [NAMES] [CACHE_ON] [LOCAL_BUILD] [REGISTRY]"
	exit
else
	RELEASE=$1
fi

for NAME in $NAMES

do
	./build_docker.sh $NAME $CACHE_ON $RELEASE $LOCAL_BUILD
	./push_docker.sh $NAME $REGISTRY $RELEASE
done
