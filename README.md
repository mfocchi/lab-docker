## Instructions
- Install docker running the script install_docker.sh from the installation tools repo
```
$ ./install_docker.sh
```
- Reboot your computer

- Clone the [repository](https://gitlab.advr.iit.it/dls-lab/dls_docker).
```
$ git clone https://gitlab.advr.iit.it/dls-lab/dls_docker
```
- Pull all the dls docker images
```
$ ./pull_docker.sh
```
- Edit .bashrc
- Run the docker
```
$ ./run_docker.sh
```
- Attach a second terminal to the docker image
```
$ join_docker.sh
```

## Issues
- Image forces user to be root
- Finalizing .bashrc scripts
- Need to set "export ROS_HOSTNAME=localhost"
- Fix run_docker.sh script (if statement)
