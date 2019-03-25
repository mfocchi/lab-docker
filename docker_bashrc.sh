# In the last line of .bashrc add "source docker_bashrc.sh"

source /opt/ros/kinetic/setup.bash

#Source @DLS-DISTRO
export ROS_WORKSPACE_NAME=dls_ws
source /home/gfink/src/dls-distro/dls_core/scripts/dls_bashrc.sh $ROS_WORKSPACE_NAME


