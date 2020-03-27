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

if [ `sudo systemctl is-active docker` = "inactive" ]; then
  echo "Docker inactive.  Starting docker..."
  sudo systemctl start docker
fi

if [ ! "$(docker container inspect dls_container > /dev/null 2>&1)" ]; then
	docker rm dls_container
fi

# Run the container with shared X11
#--entrypoint "eval $(/usr/bin/ssh-agent -s) /usr/bin/ssh-add /home/`whoami`/.ssh/id_rsa"
docker run --hostname "docker" --device=/dev/dri:/dev/dri --net=host -e "QT_X11_NO_MITSHM=1" -e SHELL -e DISPLAY -e DOCKER=1 --name dls_container -v "$HOME/dls_ws:$HOME/dls_ws:rw" -v "$HOME/.ssh:$HOME/.ssh" -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" -v "/etc/passwd:/etc/passwd" -v "$HOME/.ros:$HOME/.ros" -v "$HOME/.bashrc:$HOME/.bashrc" -it $IMAGE_NAME $SHELL -c "eval \`/usr/bin/ssh-agent -s\`; /usr/bin/ssh-add /home/`whoami`/.ssh/id_rsa; export HOME=$HOME; cd $HOME; source /opt/ros/dls-distro/setup.bash; exec /bin/bash"
