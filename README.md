## Installation Instructions

- Install docker (See the [wiki](https://gitlab.advr.iit.it/Wiki/DLS_Lab_wiki/-/wikis/Docker)
- Install python3 packages needed by script
```
$ pip3 install argparse docker dockerpty python-networkmanager argcomplete
```
- Add the following lines to the end of your .bashrc. Make sure to correct the path to where you cloned the code.
```
DLS_DOCKER_PATH="/home/USER/PATH/dls_docker"
eval "$(register-python-argcomplete dls-docker.py)"
export PATH=$DLS_DOCKER_PATH:$PATH
alias dls1="dls-docker.py run2 -f -nv -e DLS=1 -j dls -i dls-dev"
alias dls2="dls-docker.py run2 -f -nv -e DLS=2 -j dls2 -i dls2-operator"
```

## Usuage
- dls-docker.py is a wrapper around docker to make it easier to use the DLS environment.
- After successfully running the script once it will create the folder ~/dls_ws_home on your host computer.  Inside of all of the docker images this folder is mapper to $HOME.  This means that any files you place in your home folder will survice the stop/starting of a new docker container.  All other files / installed programs will disappear on the next run

### DLS1 - User
- Run the alias 'dls1'.  You should see your terminal change form user@hostname to user@docker.
- Launch the framework
```
$ source /opt/ros/kinetic/setup.bash
$ source /opt/ros/dls-distro/setup.bash
$ hyqgreen_launch_sim
```

### DLS2 - User
- Run the alias 'dls2'.  You should see your terminal change form user@hostname to user@docker.
- Launch the framework
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

### DLS1 - Developer
- Run the alias 'dls1'
- Prepare workspace
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
$ hyqgreen_launch_sim
```
- Launch the framework
```
$ hyqgreen_launch_sim
```

### DLS2 - Framework Developer
- Run the alias 'dls2'
- Prepare workspace
```
$ source /opt/ros/kinetic/setup.bash
$ git clone git@gitlab.advr.iit.it:dls-lab/dls2.git
$ cd dls2
$ mkdir build
$ cd build
$ cmake ..
$ make -j8
```
- Build the new debians
```
$ make package
```
- Install the new debians.  In a new terminal run 'dls-docker.py attach --root'
```
$ cd ~/dls2/build
$ dpkg -i *.deb
```
- Launch the framework
```
$ dls -c -r hyq
```

### Suggested bashrc
Inside docker. Remeber ~/dls_ws_home/.bashrc = ~/.bashrc
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
