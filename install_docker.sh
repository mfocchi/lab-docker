#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "install for LINUX"
	sudo apt-get install -y curl

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
	   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
	   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update
	sudo apt-get install -y docker-ce nvidia-docker2  build-essential cmake

	# Add user to docker's group
	sudo usermod -aG docker ${USER}
	

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "install for MAC"

	brew install -y curl
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
	brew   update
	brew install docker-ce nvidia-docker2  build-essential cmake

	# Add user to docker's group
	sudo usermod -aG docker ${USER}
	

fi

# insert/update hosts entry
ip_address="127.0.0.1"
host_name="docker"
docker_folder="mantis_home"
# find existing instances in the host file and save the line numbers
matches_in_hosts="$(grep -n $host_name /etc/hosts | cut -f1 -d:)"
host_entry="${ip_address} ${host_name}"

echo "Please enter your password if requested."

if [ ! -z "$matches_in_hosts" ]
then
    echo "Docker entry already existing in etc/hosts."
else
    echo "Adding new hosts entry."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi


if [ -d "${HOME}/${docker_folder} " ]; then
  echo "Directory  ${docker_folder} exists."
else
    echo "Creating ${docker_folder} dir."
    mkdir -p ${HOME}/${docker_folder} 
fi

if [ -f "${HOME}/${docker_folder}/.bashrc" ]; then
    echo ".bashrc inside ${docker_folder} exists."
else 
echo "Copying .bashrc"
    cp .bashrc ${HOME}/${docker_folder}/.bashrc 
fi

echo "Copying .ssh folder with user permissions"
sudo cp -r $HOME/.ssh/ $HOME/${docker_folder}/.ssh/
sudo chown -R $USER:$USER $HOME/${docker_folder}/.ssh 




echo -e "${COLOR_BOLD}To start docker, reboot the system!${COLOR_RESET}"
