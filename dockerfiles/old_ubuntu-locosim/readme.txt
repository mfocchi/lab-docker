This readme file contains the instructions to install locosim through docker in a linux based system with (recommended) and without nvidia drivers. 
In this guide the path where this file is located is refer as <this_path>. This installation has been tested in Ubuntu 18.04 and Ubuntu 20.04
0. If you have an nvidia graphics card you can check if your drivers are installed typing the following commands in a terminal

	sudo apt install mesa-utils
	glxinfo | grep NVIDIA
	
The output should be something similar to this

	server glx vendor string: NVIDIA Corporation
	client glx vendor string: NVIDIA Corporation
	OpenGL vendor string: NVIDIA Corporation
	OpenGL core profile version string: 4.6.0 NVIDIA 460.32.03
	OpenGL core profile shading language version string: 4.60 NVIDIA
	OpenGL version string: 4.6.0 NVIDIA 460.32.03
	OpenGL shading language version string: 4.60 NVIDIA
	OpenGL ES profile version string: OpenGL ES 3.2 NVIDIA 460.32.03
	
If there is no output it means that your drivers are not properly installed. 
You can follow a guide, for example, for ubuntu 20.04: https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-20-04-focal-fossa-linux

1. Install docker and nvidia-docker. You can use the provided script or follow one of the provided guides by docker and nvidia 

	1.1 Install using the provided script:
		in a terminal run the following commands:
		
		sudo ./<this_path>/scripts/install_docker.sh
		sudo reboot
	
	1.2 Install using the provided guides:
		
		a) Install docker for your linux distro following the guides provided here: 	
		   https://docs.docker.com/engine/install/
		b) Install nvidia-docker using this guide: 
               	   https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html

IMPORTANT: The following steps (including step 4) need to be done only the first time you setup the docker, then for normal usage just do step 4, 11:

2. After installing docker, you need to build the image containing all of the 
dependencies to run locosim. To do so run the following command in a terminal (this process takes a long time)
	
	2.1 If you have nvidia drivers installed(recommended)
	
		./<this_path>/dockerfiles/ubuntu-locosim-nvidia/build_locosim_image.sh
		
	2.2 If you do not have nvidia drivers installed
	
		./<this_path>/dockerfiles/ubuntu-locosim/build_locosim_image.sh
		
3. You can check if the image has been build by typing

	docker images
	
You should see an image called "locosim" listed
		
4. To run the docker (you need to do this every time you start a new working session) use the following command in a terminal:

	3.1 If you have nvidia drivers installed
	
	./<this_path>/scripts/run_docker.py -nv -f -api
		
	3.2 If you do not have nvidia drivers installed
			
	./<this_path>/scripts/run_docker.py -f -api
	

5. To check if the docker container is running you can type in a different terminal

	docker ps
	
You should see the container "locosim_container" with the "locosim" image loaded
	

6. Crate a ROS workspace. The first time you run step 4, it will be created a folder "locosim_home" in your user $HOME folder that will be linked to the HOME of your docker.
Any file that you will create in that folder will remain saved for the next session. So from the docker terminal (should look like YOURUSER@docker) type:
	
	cd ~
	mkdir -p ros_ws/src
	cd ros_ws/src	
	catkin_init_workspace

7. Add environment varibles to the file ~/.bashrc:
	source /opt/ros/kinetic/setup.bash
	source $HOME/ros_ws/install/setup.bash
	export UR5_MODEL_DIR=/opt/openrobots/share/example-robot-data/robots
	export PATH=/opt/openrobots/bin:$PATH
	export PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH
	export LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH
	export PYTHONPATH=/opt/openrobots/lib/python2.7/site-packages:$PYTHONPATH
	export LOCOSIM_DIR=$HOME/ros_ws/src/locosim
	export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/opt/openrobots/share/

8. Clone the locosim framework in src folder (to be able to clone you need to have a github account and add an SSH key into it):

	git clone git@github.com:mfocchi/locosim.git
	cd locosim
	git submodule update --init --recursive

9. Compile the C++ part of the code: 

	source ~/.bashrc 
	cd ~/ros_ws
	catkin_make install

10. Running the SW of the labs (example for L2):

	You can execute a python script directly from the terminal using the following command:

	python script_name.py

	If you want to keep interacting with the interpreter after the execution of the script use the following command:

	python -i script_name.py

	Rather than running scripts from the terminal, it is more convenient to use a customized python editor. For this class we suggest you use the software "spyder". 
	You should run spyder from the terminal by simply typing:

	spyder

	Once spyder is open, you can use "File->Open" to open a python script (e.g. ros_ws/src/locosim/robot_control/L2_joint_space_control.py), and then click on the "Run file" button (green "play" shape) to execute the script. 
	The first time that you run a script in spyder3, you must set up the configuration options. In particular, you must choose the type of console between these 3 options:
	
	1. current console
	2. dedicated console
	3. external system terminal
	
	Typically option 1 (which is the default choice) does not work, so you should use either option 2 or 3. I typically use option 2, but option 3 is fine as well. 
	If you have already run a file on spyder and you want to change the console to use, you can do it via the menu "Run -> Configuration per file".
	Check the option "Interact with the Python console after execution", which is useful to explore the value of the script variables after the execution has ended.


11. exit from docker 
	
	exit

OPTIONAL STEPS:

A) To attach another terminal to the docker (for example, if you want to run a separate ros node inside the docker) run the following command

	./<this_path>/scripts/attach_container.sh
	

B) To attach a container as root (for example, if you want to install an extra library that requires "sudo")

	./this_path/scripts/attach_root_container.sh
	
C) To stop the container run in a terminal

	docker stop locosim_container
	

	


