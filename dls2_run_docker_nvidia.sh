#!/usr/bin/env bash

# Check args
if [ "$#" -gt 1 ]; then
	echo "usage: ./run.sh [IMAGE_NAME=server-gitlab-runner:5000/dls2-operator-nvidia:latest]"
	exit 1
elif [ "$#" -eq 0 ]; then
  echo "IMAGE_NAME=server-gitlab-runner:5000/dls2-operator-nvidia:latest"
  IMAGE_NAME="server-gitlab-runner:5000/dls2-operator-nvidia:latest"
else
  IMAGE_NAME=$1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# Hacky
if [ `xhost | grep -c "access control enabled"` -eq 1 ]; then
	xhost +
fi


if [ `systemctl is-active docker` = "inactive" ]; then
  echo "Docker inactive.  Starting docker..."
  sudo systemctl start docker
fi

dir=/sys/fs/cgroup/systemd
if ! mountpoint -q "$dir" ; then
	sudo mkdir -p $dir
	sudo mount -t cgroup -o none,name=systemcd cgroup $dir
fi

if [ ! "$(docker container inspect dls_container > /dev/null 2>&1)" ]; then
	docker rm -f dls_container
fi

# Run the container with shared X11
#--entrypoint "eval $(/usr/bin/ssh-agent -s) /usr/bin/ssh-add /home/`whoami`/.ssh/id_rsa"
#--user `id -u`:sudo --hostname "docker"
#-v "/etc/passwd:/etc/passwd"
#-v "$HOME/.ros:$HOME/.ros"
#-v "$HOME/.bashrc:$HOME/.bashrc"

docker run \
 	--hostname "docker" \
	--gpus all \
 	--name dls_container \
	--device=/dev/dri:/dev/dri \
	--net=host \
	--user `id -u`:users \
	-e "QT_X11_NO_MITSHM=1" \
	-e SHELL \
	-e DISPLAY \
	-e DOCKER=1 \
	-v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  \
	-v "/etc/passwd:/etc/passwd" \
	-v "$HOME/.ssh:$HOME/.ssh:rw" \
	-v "$HOME/dls_ws_home:$HOME/" \
	-dit $IMAGE_NAME

email=`git config --global user.email`
name=`git config --global user.name`
docker exec -w / -it dls_container git config --global user.email $email
docker exec -w / -it dls_container git config --global user.name $name


docker exec -w $HOME -it dls_container bash


