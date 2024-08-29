## Installation Instructions

**MAC/LINUX:** follow the procedure detailed next:

-  First, make sure you have installed Git and SSH key

   To install Git you can open a terminal and run:

   ```
   sudo apt install git
   ```

   After that, you can check the version installed and configure the credentials with:

   ```
   $ git --version
   $ git config --global user.name <"name surnace">
   $ git config --global user.email <"youremail@yourdomain.it">
   ```

   After this, if you don't have an SSH key for your Github account, you need to create a new one to use the repositories:

   * go to Settings/SSH  and GPG Keys

   * open a terminal and run these commands:

     ```
     $ ssh-keygen 
     $ cd ~/.ssh/
     $ cat id_rsa.pub
     ```

     Copy the content of your public SSH into the box at the link before and press "New SSH key". You can now clone the  repositories with SSH without having to issue the password every time (I suggest to do not set any passphrase).

-  then, make sure you have installed the docker client in your machine. 

   - Run the script **install_docker.sh.** This script is important because it installs the docker client on your machine and adds to your user the privileges to run the docker images.

   ```
   $ ./install_docker.sh
   ```

   - If everything went smooth you should read: **To start docker, reboot the system!** You can now restart the PC so that all changes made can be applied.

-  Download the docker image from here:

```
$ docker pull mfocchi/ant
```

- Now, you need to configure the bash environment of your Ubuntu machine as follows. Open the `bashrc` file from your home folder:


```
$ gedit ~/.bashrc
```
-  and add the following lines at the bottom of the file:

```bash
alias lab_mantis='docker rm -f mantis_container || true; docker run --name mantis_container --gpus all  --user $(id -u):$(id -g)  --workdir="/home/$USER" --volume="/etc/group:/etc/group:ro"   --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/passwd:/etc/passwd:ro" --device=/dev/dri:/dev/dri  -e "QT_X11_NO_MITSHM=1" --network=host --hostname=docker -it  --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume $HOME/mantis_home:$HOME --env=HOME --env=USER  --privileged  -e SHELL --env="DISPLAY=$DISPLAY" --shm-size 2g --rm  --entrypoint /bin/bash mfocchi/ant'
alias mantis-other='docker exec -it mantis_container /bin/bash'
alias mantis-root='docker exec -it --user root mantis_container /bin/bash'
```

**NOTE!** If you do not have an Nvidia card in your computer, you should skip the parts about the installation of the drivers, and you can still run the docker **without** the **--gpus all** in the **lab** alias.

- Open a terminal and run the "lab" alias:

```
$ lab_mantis
```

- You should see your terminal change from `user@hostname` to `user@docker`. 

-  the **lab_mantis** script will mount the folder `~/mantis_home` on your **host** computer. Inside of all of the docker images this folder is mapped to `$HOME`.This means that any files you place in your docker $HOME folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next run.
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
  export ROS_WS=mantis_ws
  source $HOME/$ROS_WS/src/mantis-distro/core/scripts/mantis_bashrc.sh $ROS_WS
  export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
  alias mapper='roslaunch mantis_mapper simulation.launch'
  ```

- Now you can setup the workspace in the $HOME directory **inside** docker:
```
$ source /opt/ros/noetic/setup.bash
$ mkdir -p ~/ant_ws/src
$ cd ~/mantis_ws/src
$ git clone git@github.com:mfocchi/mantis-distro.git
$ cd  ~/mantis_ws/
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

Please refer to https://github.com/mfocchi/mantis-distro/blob/master/README.md for further details



