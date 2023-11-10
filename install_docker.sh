#!/bin/bash


sudo apt-get install -y curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y docker-ce nvidia-docker2 python3-pip python3-argcomplete build-essential cmake

# Add user to docker's group
sudo usermod -aG docker ${USER}
# Add the server-gitlab-runner as registry
sudo sh -c 'echo { \"insecure-registries\":[\"server-harbor:80\", \"server-harbor:443\"] } > /etc/docker/daemon.json'

pip3 install --upgrade pip
pip3 install docker dockerpty dbus-python python-networkmanager argcomplete

echo -e "${COLOR_BOLD}To start docker, reboot the system!${COLOR_RESET}"
