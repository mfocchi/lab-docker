#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run.sh IMAGE_NAME"
  exit
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

# Hacky
xhost +local:docker

# Run the container with shared X11
docker run --device=/dev/dri:/dev/dri --net=host -e "QT_X11_NO_MITSHM=1" -e SHELL -e DISPLAY -e DOCKER=1 -v "$HOME:$HOME:rw" -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" -it $1 $SHELL
