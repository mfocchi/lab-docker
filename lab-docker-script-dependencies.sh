#!/bin/bash


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "install for LINUX"
	sudo apt-get install python3-pip python3-argcomplete
	pip3 install --upgrade pip
	pip3 install docker dockerpty dbus-python python-networkmanager argcomplete


elif [[ "$OSTYPE" == "darwin"* ]]; then
	brew install python3-pip python3-argcomplete
	pip3 install --upgrade pip
	pip3 install docker dockerpty dbus-python python-networkmanager argcomplete


fi
