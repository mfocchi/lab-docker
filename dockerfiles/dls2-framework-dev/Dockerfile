ARG RELEASE
FROM server-gitlab-runner:5000/dls2-dev:$RELEASE
ARG RELEASE
RUN apt-get update \
  && apt-get install -y ros-kinetic-desktop-full \
  && apt-get -y install ros-kinetic-roslint ros-kinetic-rqt* ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-realtime-tools ros-kinetic-gazebo-ros-control ros-kinetic-grid-map ros-kinetic-grid-map-pcl ros-kinetic-gazebo-ros-pkgs ros-kinetic-ps3joy ros-kinetic-joy ros-kinetic-octomap* ros-kinetic-stereo-image-proc ros-kinetic-opencv3 ros-kinetic-robot-state-publisher ros-kinetic-openni2-camera ros-kinetic-graph-msgs ros-kinetic-ddynamic-reconfigure ros-kinetic-velodyne* ros-kinetic-kindr-ros ros-kinetic-dwl ros-kinetic-dwl-msgs ros-kinetic-terrain-server ros-kinetic-wb-state-publisher ros-kinetic-dwl-rviz-plugin ros-kinetic-xpp-opt ros-kinetic-dls-mixer ros-kinetic-clmclogger ros-kinetic-signal-scope ros-kinetic-dwl-lcmtypes ros-kinetic-locomotion-viewer ros-kinetic-rviz-visual-tools
