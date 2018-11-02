#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run.sh [IMAGE_NAME=server-dev:5000/dls-dev:latest]"
  IMAGE_NAME="server-dev:5000/dls-dev:latest"
else
  IMAGE_NAME=$1	
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

# Hacky
xhost +local:docker

# Run the container with shared X11
#--entrypoint "eval $(/usr/bin/ssh-agent -s) /usr/bin/ssh-add /home/`whoami`/.ssh/id_rsa"
docker run --user 1000 --device=/dev/dri:/dev/dri --net=host -e "QT_X11_NO_MITSHM=1" -e SHELL -e DISPLAY -e DOCKER=1 -v "$HOME:$HOME:rw" -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" -v "/etc/passwd:/etc/passwd" -it $IMAGE_NAME $SHELL -c "eval \`/usr/bin/ssh-agent -s\`; /usr/bin/ssh-add /home/`whoami`/.ssh/id_rsa; export HOME=$HOME; cd $HOME; source /opt/ros/dls-distro/setup.bash; exec /bin/bash"
