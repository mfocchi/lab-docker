[Go Back Home](Home)

Install Docker on Windows 
================================================================================

1. First Install  Windows Subsystem for Linux (WSL). Open a command prompt with **administration** privileges and type. 

``` powershell
wsl --install
```

2. install Ubuntu 20.04.06 LTS from Microsoft Store. All the procedure is explained in detail here:

   https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overv

2. Download Docker Desktop for Windows following this procedure: https://docs.docker.com/desktop/windows/wsl/ and start it.
3. Open an Ubuntu terminal from start and type:

```powershell
$ docker pull mfocchi/trento_lab_framework:introrob
```

​    6. change ownership of the home (this way you will be able to create dirs and files)

```powershell
$ sudo chown -R $USER:$USER $HOME
```

   7 . create the .bash_aliases inside the home folder

```powershell
$ cd $HOME
$ nano .bashrc
```

  8 . copy the following alias inside the .bash_aliases and save. Next time you will open a terminal this will be automatically loaded. 

```powershell
alias lab='docker rm -f docker_container || true; docker run --name docker_container   --user $(id -u):$(id -g)  --workdir="/home/$USER" --volume="/etc/group:/etc/group:ro"   --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/passwd:/etc/passwd:ro" --device=/dev/dri:/dev/dri  -e "QT_X11_NO_MITSHM=1" --network=host -it  --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume $HOME/trento_lab_home:$HOME --env=HOME --env=USER  --privileged  -e SHELL -e "DISPLAY=:0.0" -e DOCKER=1  --entrypoint /bin/bash mfocchi/trento_lab_framework:introrob'
alias dock-other='docker exec -it docker_container /bin/bash'
alias dock-root='docker exec -it --user root docker_container /bin/bash'
```

9. Close the terminal and open a new one. Add an SSH key to your Github account (create one if you don't have it) following the procedure described   [here](https://github.com/mfocchi/lab-docker/blob/master/install_docker.md).

10. Open a new docker container running the alias "lab"

11. "Configure Code" section: https://github.com/mfocchi/lab-docker#configure-code . 

12. Using the alias **dock-attach** you can open other terminals and link them to the image already open without killing it.

    

    (Optional steps)

13. To install new packages open a terminal and call the alias "dock-root" and install with apt install **without** sudo. To store the changes in the local image, get the ASH (a number) of the active container with:

    ```powershell
    $ docker ps 
    ```

14. Commit the docker image (next time you will open an new container it will retain the changes done to the image without loosing them):

    ```powershell
    $ docker commit ASH mfocchi/trento_lab_framework:introrob
    ```