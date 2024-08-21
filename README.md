## Installation Instructions

**MAC/LINUX:** follow the procedure detailed next:

-  First, make sure you have installed the docker client in your machine. The procedure is described  [here](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md).
-  Download the docker image from here. It will be slow (more than 12 Gbytes): 

```
$ docker pull mfocchi/ant
```

- Now, you need to configure the bash environment of your Ubuntu machine as follows. Open the `bashrc` file from your home folder:


```
$ gedit ~/.bashrc
```
-  and add the following lines at the bottom of the file:

```bash
alias lab_mantis='docker rm -f docker_container || true; docker run --name docker_container --gpus all  --user $(id -u):$(id -g)  --workdir="/home/$USER" --volume="/etc/group:/etc/group:ro"   --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/passwd:/etc/passwd:ro" --device=/dev/dri:/dev/dri  -e "QT_X11_NO_MITSHM=1" --network=host --hostname=docker -it  --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume $HOME/mantis_home:$HOME --env=HOME --env=USER  --privileged  -e SHELL --env="DISPLAY=$DISPLAY" --shm-size 2g --rm  --entrypoint /bin/bash mfocchi/ant'
alias dock-other='docker exec -it docker_container /bin/bash'
alias dock-root='docker exec -it --user root docker_container /bin/bash'
```

**NOTE!** If you do not have an Nvidia card in your computer, you should skip the parts about the installation of the drivers, and you can still run the docker **without** the **--gpus all** in the **lab** alias.

- Open a terminal and run the "lab" alias:

```
$ lab_mantis
```

- You should see your terminal change from `user@hostname` to `user@docker`. 

-  the **lab_mantis** script will mount the folder `~/trento_lab_home` on your **host** computer. Inside of all of the docker images this folder is mapped to `$HOME`.This means that any files you place in your docker $HOME folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next run.
- The alias **lab_mantis** needs to be called only ONCE and opens the image. To link other terminals to the same image you should run **dock-other**, this second command will "**attach**" to the image opened previously by calling the **lab** alias.  You can call **lab** only once and **dock-other** as many times you need to open multiple terminals.



### Configure CODE

- Open a terminal and run the "lab" alias:
```
$ lab_mantis
```
- You should see your terminal change from `user@hostname` to `user@docker`. 

- Now you need to edit the .bashrc script (that was create by the install script) **inside** the docker

  ```
  $ gedit ~/.bashrc
  ```

  and add the following lines at the bottom of the file:

  ```bash
  source /opt/ros/noetic/setup.bash
  source /opt/ros_utils/setup.bash
  export ANT_PATH=ant_ws
  source $HOME/$ANT_PATH/src/dls-distro/dls_core/scripts/dls_bashrc.sh $ANT_PATH
  export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
  alias mapper='roslaunch dls_mapper simulation.launch'
  ```

- Now you can setup the workspace in the $HOME directory **inside** docker:
```
$ source /opt/ros/noetic/setup.bash
$ mkdir -p ~/ant_ws/src
$ cd ~/ant_ws/src
$ git clone git@github.com:mfocchi/dls-distro.git
$ cd  ~/ant_ws/
$ catkin_make install
$ source .bashrc
```

**NOTE:**  when you clone the code, be sure to have a stable and fast connection. Before continuing, be sure you properly checked out **all** the submodules without any error.

**NOTE:**  when you run the code, if an error pops-up that tells you a recently compiled package cannot be found you need to run:

```
$ rospack profile
```

This function crawls through the packages in ROS_ROOT  and ROS_PACKAGE_PATH, reads and parses  the package.xml for each package, and  assemble a complete dependency tree  for all packages.

When you have finished exit from the container typing:  

```
$ exit
```

# Run the software

In one terminal start the simulation

```
$ launch_aliengo_gazebo
```

open another terminal with **dock-other** and start the framework:

```
$ launch_aliengo_supervisor_gazebo
```

in the same terminal:

```
ANTController> startController
```

starts the controller. 

```
ANTController> stt	
```

toggle the gravity compensation / whole body controller

```
ANTController> goHome
```

stand-up from belly down posture

```
ANTController> startMotion		
```

starts the crawl

Please refer to https://github.com/mfocchi/dls-distro/blob/master/README.md for further details



