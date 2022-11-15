## Installation Instructions

This guide allows you to configure the lab docker images and to download the Gazebo models for properly running the robots simulations.

**COMPATIBILITY ISSUES:** This procedure works only for users that have a Linux operating systems or old x86-64 based MACs, for the new MAC M1/M2 that employ ARM processors, docker does not work anymore! The only solution is to install a  [parallel/multipass](https://github.com/mfocchi/lab-docker/blob/master/multipass.md) virtual machine and install natively all the [dependencies](https://github.com/mfocchi/locosim)  inside there. Remember that on MAC you need to replace "sudo apt install package_name" with "brew install package_name". In this case you can follow a detailed wiki [here](https://github.com/NatFederico/roboticsVM), made by Federico Natali. For windows based systems instead the following [procedure](https://github.com/mfocchi/lab-docker/blob/master/install_docker_windows.md) should work.

 First, make sure you have installed Docker, and the  SSH keys in your Github account and the Nvidia drivers. The procedures are described  [here](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md).

- **NOTE!** If you do not have an Nvidia card in your computer, you should skip the parts about the installation of the drivers, and you can still run the docker **without** the **-nv** flag in the **lab** alias.  

- Download the docker image from here: 

```
$ docker pull mfocchi/trento_lab_framework:introrob
```
In newer versions of Ubuntu the installation of the following dependencies is required

- Open a terminal and run the following command

```
$ sudo apt-get install python3-argcomplete libglib2.0-dev libdbus-1-dev build-essential cmake
```
- Using pip to install the required package
```
$ pip3 install -r requirements.txt
```
Once the dependencies are satisfied, the bash environment can be configured

- Open the `bashrc` file from your home folder:
```
$ gedit ~/.bashrc
```
and add the following lines at the bottom of the file:
```bash
LAB_DOCKER_PATH="/home/USER/PATH/lab-docker"
eval "$(register-python-argcomplete3 lab-docker.py)"
export PATH=$LAB_DOCKER_PATH:$PATH
alias lab='lab-docker.py --api run   -f -nv  mfocchi/trento_lab_framework:introrob'
alias dock-other='lab-docker.py attach'
alias dock-root='lab-docker.py attach --root'
```
where "/home/USER/PATH" is the folder you cloned the lab-docker repository.

Make sure to edit the `LAB_DOCKER_PATH` variable with the path to where you cloned the `lab_docker` repository.

- `lab-docker.py` is a wrapper around docker to make it easier to use the trentolab environment.
- the `lab-docker.py` script will create the folder `~/trento_lab_home` on your host computer. Inside of all of the docker images this folder is mapped to `$HOME`.\
  This means that any files you place in your home folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next run.
- **IMPORTANT!** If you are running in issues ([see docker issues](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md)) with your Nvidia card or your computer **does not** have an Nvidia card,  you can run **without** the Nvidia drivers removing the tag **-nv** from the lab alias. 
- The alias **lab** needs to be called only ONCE and opens the image. To link other terminals to the same image you should run **dock-other**, this second command will "attach" to the image opened by calling the lab alias.  



### Configure CODE

- Open a terminal and run the alias for "lab":
```
$ lab
```
- You should see your terminal change from `user@hostname` to `user@docker`. Now that you are inside the docker, you can setup the workspace:
```
$ source /opt/ros/noetic/setup.bash
$ mkdir -p ~/ros_ws/src
$ cd ~/ros_ws/src
$ git clone https://github.com/mfocchi/locosim  -b develop --recursive
$ cd  ~/ros_ws/
$ catkin_make install
```

**NOTE:**  when you run the code, if an error pops-up that tells you a recently compiled package cannot be found you need to run:

```
$ rospack profile
```

This function crawls through the packages in ROS_ROOT  and ROS_PACKAGE_PATH, read and parse  the package.xml for each package, and  assemble a complete dependency tree  for all packages.

**NOTE:** when you run the code, this error might pop-up:

```
Warning: TF_REPEATED_DATA ignoring data with redundant timestamp for frame...
```

a quick fix is to clone in the `~/ros_ws/src` folder the following package:

```
git clone --branch throttle-tf-repeated-data-error git@github.com:BadgerTechnologies/geometry2.git
```



### Configure Docker `bashrc`

You can edit your `~/trento_lab_home/.bashrc` file so that is easier to use the lab. Remember that the `~/trento_lab_home/.bashrc` file (from outside Docker) is equal to the `~/.bashrc` file (from inside Docker).\
So, from your home folder outside Docker, you can open:

```
$ gedit ~/trento_lab_home/.bashrc
```
and add the following lines at the bottom of the file:
```bash
source /opt/ros/noetic/setup.bash
source $HOME/ros_ws/install/setup.bash
export PATH=/opt/openrobots/bin:$PATH
export LOCOSIM_DIR=$HOME/ros_ws/src/locosim
export PYTHONPATH=/opt/openrobots/lib/python3.8/site-packages:$LOCOSIM_DIR/robot_control:$PYTHONPATH
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/opt/openrobots/share/
```



### Download Gazebo models

To have all Gazebo models available in simulation, you need to complete a last step, that is downloading the Gazebo models. To do this, you can:

* create the Gazebo `models` folder and a script in `trento_lab_home` folder. From your home directory (outside Docker) run:
```
$ cd trento_lab_home/.gazebo
$ mkdir models
$ cd ..
$ touch download_gazebo_models.sh
$ chmod +x download_gazebo_models.sh
```
* copy these lines below in your new script:
```bash
#!/bin/sh

# Download all model archive files
wget -l 2 -nc -r "http://models.gazebosim.org/" --accept gz

# This is the folder into which wget downloads the model archives
cd "models.gazebosim.org"

# Extract all model archives
for i in *
do
  tar -zvxf "$i/model.tar.gz"
done

# Copy extracted files to the local model folder
cp -vfR * "$HOME/trento_lab_home/.gazebo/models/"

# Remove the folder downloaded with wget
cd ..
rm -rf "models.gazebosim.org"
```
* now you can run the script from `trento_lab_home`:
```
$ ./download_gazebo_models
```

Once the download is complete, you can go inside `models` folder and verify that it now contains the Gazebo models. 



### **Running the software** from Python IDE: Pycharm  

We recommend to use an IDE to run and edit the python files, like Pycharm community. To install it,  you just need to download and unzip the program:

https://download.jetbrains.com/python/pycharm-community-2021.1.1.tar.gz

 and unzip it  *inside* the docker (e.g. copy it inside the `~/trento_lab_home` folder. 

**IMPORTANT**!** I ask you to download this specific version (2021.1.1) that I am sure it works, because the newer ones seem to be failing to load environment variables! 

1) To run Pycharm community type (if you are lazy you can create an alias...): 

```
$ pycharm_folder/bin/pycharm.sh
```

2) remember to run **pycharm-community** from the terminal otherwise it does not load the environment variables loaded inside the .bashrc.

3) click "Open File or Project" and open the folder robot_control. Then launch one of the labs in locosim/robot_control/lab_exercises or in locosim/robot_control/base_controllers  (e.g. base_controller_fixed.py)  right click on the code and selecting "Run File in Pyhton Console"

4) the first time you run the code you will be suggested to select the appropriate interpreter (/usr/binpython3.8). Following this procedure you will be sure that the run setting will be stored, next time that you start Pycharm.

**IMPORTANT!** To be able to keep the plots **alive** at the end of the program and to have access to variables,  you need to "Edit Configurations..." and tick "Run with Python Console". Otherwise the plot will immediately close. 

### Running the Software from terminal

To run from a terminal we  use the interactive option that allows  when you close the program have access to variables:

```
$ python3 -i $LOCOSIM_DIR/robot_control/base_controllers/base_controller.py
```

to exit from python3 console type CTRL+Z



### Committing your software changes in a repository

To keep memory of changes to your newly developed code (i.e. track code changes) you can employ a popular version control system called **git** (www.w3schools.com/git/git_intro.asp?remote=github). The first time (only) you use git you need to configure your name an email address as follows: 

```csharp
git config --global user.name "your name"
```

```csharp
git config --global user.email "youremail@yourdomain.com"
```

To efficiently deal with git repositories I suggest to use **git-cola** (to make commits) and **gitg** (to inspect the branches'tree). You should run these commands in the folder you want to manage version control **outside** the docker terminal.

Since Locosim is working with git submodules (i.e. locosim repository points like an octopus to all the commits in the submodules that are compatible) when you do "git submodule update" the submodule repository go in "detached head" state. This means that when you check the branch you are with:

```
$ git branch
```

you will get something like this:

```
$ (HEAD detached at d413b08)
```

This means you are not in any specific branch. Then you have two options: 1) create a local branch or checkout to another branch (typically master). In the first case  type:

```
$ git checkout -b new_branch_name
```

in the second case:

```
$ git checkout existing_branch_name
```

you can check existing branches with "gitg" GUI. Remember that, in this case,  you might need to update your local copy of the branch with the changes that might be occurred on the server (typically called "origin").

```
$ git pull origin existing_branch_name
```

To push the changes (e.g. done in step 2.) on the  server origin jump to step 5. 

Now, let's assume we want to create a new repository for our developed code called "my_planner" (i.e. you created a ros package for planning). 

1. You go in the folder you have the code and initialize  an empty repository;

```
$ git init
```

2. You can do you first commit staging the required files you want to add, by running:

```
$ git cola
```

**NOTE:** by default the commit is created in master to it in another branch you can create a new branch with

```
$ git checkout -b new_branch_name
```

3. Now you have created your repository locally, if you want to share with people or other computers you want to push it to a server. To do so create a Github (https://github.com ) account and a new repository my_planner in there: ![image-20221007134835753](figs/new_repo.png)




4. Now, get the remote link with SSH (you should have your ssh-key added) and add it to your local repository to make it "point" to that server:

```
$ git remote add git@github.com:mfocchi/ros_impedance_controller.git
```

5. finally you can push your local commit onto the only repository, where I chose **origin** to name the server but could be whatever name:

```
$ git push origin master
```

**NOTE!** If you any issue with git do all git operations outside the docker.



## Committing a docker image locally (only for advanced users)

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
a9ca7fe9affb   mfocchi/trento_lab_framework:introrob   "/opt/entrypoint.bas…"   20 hours ago   Up 20 hours            
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

   in my case is mfocchi/trento_lab_framework:introrob but I am the only one allowed to push there.

   