## Instructions
- Purge any previous docker instalation
```
$ sudo apt-get purge docker lxc-docker docker-engine docker.io
```
-Install docker required packages
```
$ sudo apt-get install  curl  apt-transport-https ca-certificates software-properties-common
```
-Setup docker's official GPG keys and enable repository in Ubuntu
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
- Install docker
```
$ sudo apt-get update
$ sudo apt-get install docker-ce
```
- Add your user to the docker group (replace "myusername" with the name of your local user name)
```
sudo usermod -aG docker myusername
```
- Log out and log in from the current linux session

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
