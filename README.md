## Installation Instructions

This guide allows you to configure the lab docker images and to download the Gazebo models for properly running the robots simulations.
- Make sure you have [installed Docker](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md), SSH keys and nvidia drivers.

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
LAB_DOCKER_PATH="/home/USER/PATH/lab_docker"
eval "$(register-python-argcomplete3 lab-docker.py)"
export PATH=$LAB_DOCKER_PATH:$PATH
alias lab='lab-docker.py --api run   -f -nv --dns mfocchi/trento_lab_framework:introrob'
alias dock-other='lab-docker.py attach'
alias dock-root='lab-docker.py attach --root'
```
**Important!** If you are running in issues ([see docker issues](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md)), with your Nvidia card you can run without the Nvidia drivers removing the tag -nv from the lab alias. 

Make sure to edit the `LAB_DOCKER_PATH` variable with the path to where you cloned the `lab_docker` repository.

- `lab-docker.py` is a wrapper around docker to make it easier to use the trentolab environment.
- the `lab-docker.py` script will create the folder `~/trento_lab_home` on your host computer. Inside of all of the docker images this folder is mapped to `$HOME`.\
This means that any files you place in your home folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next
run.

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
$ git clone git@github.com:mfocchi/locosim.git
$ cd locosim
$ git submodule update --init --recursive
$ cd  ~/ros_ws/
$ catkin_make install
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

To properly run the robots simulations with Gazebo, you need to complete a last step, that is downloading the Gazebo models. To do this, you can:

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

### Launch the framework

1) Install [pycharm-community](https://www.jetbrains.com/pycharm/download/#section=linux)  *inside* the docker (e.g. copy it inside the `~/trento_lab_home` folder)

2) remenber to run pycharm-community from the terminal otherwise it does not load the environment variables loaded inside the .bashrc.

3) launch one of the labs in locosim/robot_control

### Important Notes

- If you install something inside the docker (e.g. using apt), when you stop the container these changes won't be saved. If you want to save whatever you have inside the container, you need to do `docker commit`. https://docs.docker.com/engine/reference/commandline/commit/
