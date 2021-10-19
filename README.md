## Installation Instructions

This guide allows you to configure the DLS1 and DLS2 docker images and to download the Gazebo models for properly running the robots simulations.
- Make sure you have [installed Docker](https://gitlab.advr.iit.it/dls-lab/new-wiki/-/wikis/software/docker/docker#docker-install) from the Wiki.
- Open the `bashrc` file from your home folder:
```
$ gedit ~/.bashrc
```
and add the following lines at the bottom of the file:
```
DLS_DOCKER_PATH="/home/USER/PATH/dls_docker"
eval "$(register-python-argcomplete3 dls-docker.py)"
export PATH=$DLS_DOCKER_PATH:$PATH
alias dls1="dls-docker.py --api run2 -f -nv -e DLS=1 -j dls -i dls-dev"
alias dls2="dls-docker.py --api run2 -f -nv -e DLS=2 -j dls2 -i dls2-operator"
```
Make sure to edit the `DLS_DOCKER_PATH` variable with the path to where you cloned the `dls_docker` repository.
- `dls-docker.py` is a wrapper around docker to make it easier to use the DLS environment.
- After successfully running DLS1 or DLS2 once, the `dls-docker.py` script will create the folder `~/dls_ws_home` on your host computer. Inside of all of the docker images this folder is mapped to `$HOME`.\
This means that any files you place in your home folder will survive the stop/starting of a new docker container. All other files and installed programs will disappear on the next
run.

### Configure DLS1

- Open a terminal and run the alias for `DLS1`:
```
$ dls1
```
- You should see your terminal change from `user@hostname` to `user@docker`. Now that you are inside the docker, you can setup the workspace:
```
$ source /opt/ros/kinetic/setup.bash
$ mkdir -p ~/dls_ws/src
$ cd ~/dls_ws/
$ catkin_make
$ cd src
$ git clone git@gitlab.advr.iit.it:dls-lab/dls-distro.git
$ cd dls-distro
$ git submodule update --init --recursive
$ export ROS_WORKSPACE_NAME=dls_ws
$ source ~/dls_ws/src/dls-distro/dls_core/scripts/dls_bashrc.sh $ROS_WORKSPACE_NAME
$ hyqmake
```

- Launch the framework:

```
$ hyqgreen_launch_sim
```

### DLS1 - User

- Configure your Docker `bashrc` DLS1 and DLS2 following the steps in [Configure Docker `bashrc`](https://gitlab.advr.iit.it/-/ide/project/dls-lab/dls_docker/edit/user/-/README.md#configure-docker-bashrc) section. Then you can run:

```
$ dls1
$ hyqgreen_launch_sim
```

- If you don't want to configure the `bashrc`, you can use the DLS1 running these commands in a terminal:

```
$ dls1
$ source /opt/ros/kinetic/setup.bash
$ source /opt/ros/dls-distro/setup.bash
$ hyqgreen_launch_sim
```

It can happen that you see this annoying message in the terminal when you use DLS1:
```
bash: __git_ps1: command not found
```
This happens because when you clone the [dls_distro](https://gitlab.advr.iit.it/dls-lab/dls-distro) repository, the `dls_bashrc.sh` file on the `master` branch contains a line that is responsible for this. Look at the [Docker issues](https://gitlab.advr.iit.it/dls-lab/new-wiki/-/wikis/software/docker/docker#docker-issues) section for solving this issue.


### Configure DLS2

- Open a terminal and run the alias for `DLS2`:
```
$ dls2
```

- Now that you are inside the docker, you can setup the workspace:

```
$ source /opt/ros/kinetic/setup.bash
$ git clone git@gitlab.advr.iit.it:dls-lab/dls2.git
$ cd dls2
$ git submodule update --init --recursive
$ mkdir build
$ cd build
$ cmake ..
$ make -j8
```

- Build the new debians with:

```
$ make package
```

- Install the new debians.  Open a new terminal, go to `dls_docker` and run `dls-docker.py attach --root`.\
  The command:
    - `dls-docker.py attach` allows you to open another session of the same docker image without closing the original one
    - the one with `--root` gives you root permissions to install something in the docker image.

  From the terminal with root permissions, run:

```
$ cd dls2/build
$ dpkg -i *.deb
```

Now you can close the terminal with root permissions and you can launch the framework from the first one:

```
$ dls -c -r hyq
```

### DLS2 - User

- Configure your Docker `bashrc` DLS1 and DLS2 following the steps in [Configure Docker `bashrc`](https://gitlab.advr.iit.it/-/ide/project/dls-lab/dls_docker/edit/user/-/README.md#configure-docker-bashrc) section. Then you can run:

```
$ dls2
$ dls -c -r hyq
```

- If you don't want to configure the `bashrc`, you can use the DLS1 running these commands in a terminal:

```
$ source /opt/ros/kinetic/setup.bash
$ source /opt/ros/dls2/setup.bash
$ source /opt/is-workspace/install/setup.bash
$ export LD_LIBRARY_PATH=/usr/lib/dls2:$LD_LIBRARY_PATH
$ export LD_LIBRARY_PATH=/usr/lib/dls2/gait_generators:$LD_LIBRARY_PATH
$ export LD_LIBRARY_PATH=/usr/lib/dls2/controllers:$LD_LIBRARY_PATH
$ export LD_LIBRARY_PATH=/usr/lib/dls2/estimators:$LD_LIBRARY_PATH
$ export LD_LIBRARY_PATH=/usr/lib/dls2/messages:$LD_LIBRARY_PATH
$ dls -c -r hyq
```

### Configure Docker `bashrc`

You can edit your `~/dls_ws_home/.bashrc` file so that is easier to use DLS1 and DLS2. Remember that the `~/dls_ws_home/.bashrc` file (from outside Docker) is equal to the `~/.bashrc` file (from inside Docker).\
So, from your home folder outside Docker, you can open:
```
$ gedit ~/dls_ws_home/.bashrc
```
and add the following lines at the bottom of the file:
```
if [[ $DLS -eq 1 ]]; then
  source /opt/ros/kinetic/setup.bash
  export ROS_WORKSPACE_NAME=dls_ws
  source ~/dls_ws/src/dls-distro/dls_core/scripts/dls_bashrc.sh $ROS_WORKSPACE_NAME
elif [[ $DLS -eq 2 ]]; then
  source /opt/ros/kinetic/setup.bash
  source /opt/ros/dls2/setup.bash
  source /opt/is-workspace/install/setup.bash
  export LD_LIBRARY_PATH=/usr/lib/dls2:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/lib/dls2/gait_generators:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/lib/dls2/controllers:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/lib/dls2/estimators:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/lib/dls2/messages:$LD_LIBRARY_PATH
  export PATH=/opt/qt515/bin:$PATH
  export LD_LIBRARY_PATH=/opt/qt515/lib:$LD_LIBRARY_PATH
  export PATH=/opt/qtcreator/bin:$PATH
  export LD_LIBRARY_PATH=/opt/qtcreator/lib:$LD_LIBRARY_PATH
fi
```

### Download Gazebo models

To properly run the robots simulations with Gazebo, you need to complete a last step, that is downloading the Gazebo models. To do this, you can:

* create the Gazebo `models` folder and a script in `dls_ws_home` folder. From your home directory run:
```
$ cd dls_ws_home/.gazebo
$ mkdir models
$ cd ..
$ touch download_gazebo_models.sh
$ chmod +x download_gazebo_models.sh
```
* copy these lines below in your new script:
```
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
cp -vfR * "$HOME/dls_ws_home/.gazebo/models/"

# Remove the folder downloaded with wget
cd ..
rm -rf "models.gazebosim.org"
```
* now you can run the script from `dls_ws_home`:
```
$ ./download_gazebo_models
```

Once the download is complete, you can go inside `models` folder and verify that it now contains the Gazebo models. 

### Important Notes

- If you are oustide of IIT and not connected to the vpn you will have DNS issues. Please run `dls1 --dns` or `dls2 --dns` to fix the problem or [configure your VPN connection](https://gitlab.advr.iit.it/dls-lab/new-wiki/-/wikis/software/new_pc_with_Ubuntu_20_04_3/new_pc_with_Ubuntu_20_04_3#configuring-iit-vpn).
- If you install something inside the docker (e.g. using apt), when you stop the container these changes won't be saved. If you want to save whatever you have inside the container, you need to do `docker commit`. https://docs.docker.com/engine/reference/commandline/commit/
