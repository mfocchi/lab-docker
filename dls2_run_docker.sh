#!/usr/bin/env bash

# Check args
if [ "$#" -gt 2 ]; then
	echo "usage: $0 [--nivida] [IMAGE_NAME] "
	echo ""
	echo "  IMAGE_NAME=dls2-operator"
	echo "  --nvidia : Use the nvidia image instead of intel/mesa"
	exit 1
elif [ $# -eq 2 ]; then
	if [ "$1" = "--nvidia" ]; then
		NVIDIA=true
		IMAGE_NAME="server-gitlab-runner:5000/$2-nvidia:latest"
	elif [ "$2" = "--nvidia" ]; then
		NVIDIA=true
		IMAGE_NAME="server-gitlab-runner:5000/$1-nvidia:latest"
	else
		echo "usage: $0 [--nivida] [IMAGE_NAME] "
		echo ""
		echo "  IMAGE_NAME=dls2-operator"
		echo "  --nvidia : Use the nvidia image instead of intel/mesa"
		exit 1
	fi
elif [ $# -eq 1 ]; then
	if [ "$1" = "--nvidia" ]; then
		NVIDIA=true
		IMAGE_NAME="server-gitlab-runner:5000/dls2-operator-nvidia:latest"
	else
		NVIDIA=false
		IMAGE_NAME="server-gitlab-runner:5000/$1:latest"
	fi
else
	NVIDIA=false
	IMAGE_NAME="server-gitlab-runner:5000/dls2-operator:latest"
fi

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

if [ -d "$HOME/dls_ws_home" ]; then
	echo "dls_ws_home exists"
else
	echo "dls_ws_home doesn't exist"
	mkdir $HOME/dls_ws_home
fi


if [ -f "$HOME/dls_ws_home/.bashrc" ]; then
	echo "bashrc exists"
else
	echo "bashrc doesn't exsist."
	cp /etc/skel/.bashrc $HOME/dls_ws_home/.bashrc
fi

docker rm -f dls_container > /dev/null 2>&1

OPTIONS="--hostname docker"
OPTIONS="--name dls_container $OPTIONS"
OPTIONS="--device=/dev/dri:/dev/dri $OPTIONS"
OPTIONS="--net=host $OPTIONS"
OPTIONS="--user `id -u`:users $OPTIONS"
OPTIONS="-e QT_X11_NO_MITSHM=1 $OPTIONS"
OPTIONS="-e SHELL $OPTIONS"
OPTIONS="-e DISPLAY $OPTIONS"
OPTIONS="-e DOCKER=1 $OPTIONS"
OPTIONS="-v /tmp/.X11-unix:/tmp/.X11-unix:rw $OPTIONS"
OPTIONS="-v /etc/passwd:/etc/passwd $OPTIONS"
OPTIONS="-v $HOME/.ssh:$HOME/.ssh:rw $OPTIONS"
OPTIONS="-v $HOME/dls_ws_home:$HOME/ $OPTIONS"

if [ $NVIDIA ]; then
	OPTIONS="--gpus all $OPTIONS"
fi


docker run $OPTIONS -dit $IMAGE_NAME

email=`git config --global user.email`
name=`git config --global user.name`
docker exec -w / -it dls_container git config --global user.email $email
docker exec -w / -it dls_container git config --global user.name $name

docker exec -w /root -u root -it dls_container /root/dls_docker/scripts/timeout.sh 0.1 0.1


docker exec -w $HOME -it dls_container bash

