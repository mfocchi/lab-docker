## Instructions to run docker on a personal pc

- Install docker running the script install_docker.sh from [installation tools](https://gitlab.advr.iit.it/dls-lab/installation_tools)
```
$ ./install_docker.sh
```
- Reboot your computer
- Clone the [repository](https://gitlab.advr.iit.it/dls-lab/dls_docker).
```
$ git clone https://gitlab.advr.iit.it/dls-lab/dls_docker
```
- Run the docker image
```
$ ./run_docker.sh
```
- Attach a second terminal to the docker image
```
$ ./join_docker.sh
```

## Scripts to use on the server

The following scripts are used by the server-docker and should not be modified or used on your personal pc:

- build_docker.sh
- clean_docker.sh
- create_registry.sh
- preamble.sh
- push_docker.sh 

## Issues
- Image forces user to be root
- Finalizing .bashrc scripts
- Need to set "export ROS_HOSTNAME=localhost"
- Fix run_docker.sh script (if statement)
- Fix pull_docker.sh (missing env variable REPOSITORY)
- Fix docker_bashrc.sh (hardcoded home directory)
