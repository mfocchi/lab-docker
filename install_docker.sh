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


if [ -d "${HOME}/trento_lab_home" ]; then
  echo "Directory trento_lab_home exists."
else
    echo "Creating trento_lab_home dir."
    mkdir -p ${HOME}/trento_lab_home
fi

if [ -f "${HOME}/trento_lab_home/.bashrc" ]; then
    echo ".bashrc inside trento_lab_home exists."
else 
echo "Copying .bashrc"
    cp .bashrc ${HOME}/trento_lab_home/.bashrc 
fi

echo "Copying .ssh folder with user permissions"
sudo cp -R $HOME/.ssh/ $HOME/trento_lab_home/.ssh/
sudo chown -R $USER:$USER $HOME/trento_lab_home/.ssh 




echo -e "${COLOR_BOLD}To start docker, reboot the system!${COLOR_RESET}"
