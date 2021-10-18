## Installation Instructions

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
Make sure to correct the `DLS_DOCKER_PATH` variable with path to where you cloned the `dls_docker` repository.
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
    - the one with `--root` gives you root permissions to do some changes and installations in the image. You will loose them when you will close the image if you don't do a docker 
      commit.

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

### Important Notes

- If you are oustide of IIT and NOT connected to the vpn you need you will have
  dns issues.  Please run `dls1 --dns` or `dls2 --dns` to fix the problem

- If you install something inside the docker (e.g. using apt), when you stop the container these changes won't be saved. If you want to save whatever you have inside the container, you need to do 
`docker commit`. https://docs.docker.com/engine/reference/commandline/commit/
