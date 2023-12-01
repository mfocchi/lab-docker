[Go Back Home](Home)

Docker Wiki for ROS2
================================================================================

This section of the wiki gives information on how to use the docker.

1. [Docker Install](#docker-install) 
4. [Committing a docker image (Making changes permanent)](#docker_commit)



Docker Install
--------------------------------------------------------------------------------

<a name="docker_install"></a>
Clone in the $HOME folder (usually is "home/USERNAME") the lab-docker repository:

```
$ git clone git@github.com:mfocchi/lab-docker.git
```
- Run the script install_docker.sh. This script is important because it installs the docker client on your machine and adds to your user the privileges to run the docker images.
```
$ ./install_docker.sh
```
- If everything went smooth you should read: **To start docker, reboot the system!** You can now restart the PC so that all changes made can be applied.
- Now, you need to configure the bash environment of your Ubuntu machine as follows. Open the `bashrc` file from your home folder:


```
$ gedit ~/.bashrc
```

-  and add the following lines at the bottom of the file:

```powershell
alias lab='docker rm -f docker_container || true; docker run --name docker_container   --user $(id -u):$(id -g)  --workdir="/home/$USER" --volume="/etc/group:/etc/group:ro"   --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/passwd:/etc/passwd:ro" --device=/dev/dri:/dev/dri  -e "QT_X11_NO_MITSHM=1" --network=host -it  --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume $HOME/trento_lab_home:$HOME --env=HOME --env=USER  --privileged  -e SHELL --env="DISPLAY=$DISPLAY" --shm-size 2g --rm  --entrypoint /bin/bash mfocchi/trento_lab_framework:introrob'
alias dock-other='docker exec -it docker_container /bin/bash'
alias dock-root='docker exec -it --user root docker_container /bin/bash'
```

- the **lab** script will mount the folder `~/trento_lab_home` on your **host** computer. Inside of all of the docker images this folder is mapped to `$HOME`.This means that any files you place   in your docker $HOME folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next run.

-  Download the docker image with Ubuntu 20.04 and  ros2 (foxy):

```
$ docker pull mfocchi/locosim_ros2:latest
```

- Open a terminal and run the "lab" alias:

```
$ lab
```

- You should see your terminal change from `user@hostname` to `user@docker`. You can now clone the code inside there. 



## Committing a docker image locally 

You can install new packages on your docker image by accessing with the alias dock-root run in another terminal. You will have to install the packages **without** sudo. There is not password to put. 

If you install something inside the docker (e.g. using apt), when you stop the container (e.g., `docker stop <container_name>`) these changes won't be saved. If you want to save whatever you have inside the container, you need to do`docker commit` Note if you are just changing the code (ie adding / removing files to the home folder) you do NOT need to update the docker image.

For example, let's say you loaded the lab_docker image `image_name:tag` and you installed the ros topic plotting tool `PlotJuggler` (i.e., in an attached root terminal you wrote `apt install ros-noetic-plotjuggler`). IMPORTANT! If you were to stop the container (e.g. close the terminal), the next time you run the container `PlotJuggler` will not be there. o make the changes permanent in your image you need to commit the image. 

1. When you decide to commit the image, run in a terminal not attached to the docker the following command:

```
$ docker ps
```

2. This will display the running containers as follows: 

```
CONTAINER ID   IMAGE                                   COMMAND                  CREATED        STATUS             
a9ca7fe9affb   mfocchi/locosim_ros2:latest   "/opt/entrypoint.bas…"   20 hours ago   Up 20 hours            
```

3. Copy the `CONTAINER ID` (ash) and type the following in the same terminal

```
$ docker commit a9ca7fe9affb image_name:tag
```

Note that this will replace the previous image. In case you want to create a different image, change the name and/or tag `image_name:new_tag` for a different name, eg., `image_name:new_tag`

4. the next time you will start the container you will have your packages already installed.

## Pushing a docker image to server (only for advanced users)

If you want to push your image on a server (e.g. to share with another computer or colleague), you need to create a  **docker hub** account in https://hub.docker.com/ . Once done that:

1. click on create (public) repository (for private you need to pay). 

2. To be able to push to any repository you will first need to **login** your machine (only once for each computer) on docker hub. To do so click on your avatar on docker hub account and select "AccountSettings/Security/New Access Token". Copy the generated token ans use it as a password (when requested) after calling the following command:

   ```
   $ docker login -u your_account_name   
   ```

3. Finally you can push your image

   ```
   docker push your_account_name/repo_name/:tagname
   ```

   in my case is mfocchi/locosim_ros2:latest but I am the only one allowed to push there.

   



