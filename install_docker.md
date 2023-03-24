[Go Back Home](Home)

Docker Wiki
================================================================================

This section of the wiki gives information on how to use the docker.

1. [Docker Install](#docker_install)

2. [Common Docker Install Issues](#docker_issues)

3. [Committing a docker image (Making changes permanent)](#docker_commit)


Installing NVIDIA drivers
--------------

If your PC is provided with an NVIDIA graphics card, you can install its drivers in Ubuntu by following these steps:

add the repository

```
sudo add-apt-repository ppa:graphics-drivers/ppa
```

update the repository list:

```
sudo apt-get update
```

Install the driver, note that for Ubuntu 16.04 is recommended the 430 version (X=410) while for Ubuntu 20.04 the 515 version is ok but you can use also other versions:

```
sudo apt-get install nvidia-driver-X
```

The reboot the system

```
sudo reboot
```

Now tell the system to use that driver:

* open the _Software & Updates_ application
* go to "Additional Drivers" and select the latest driver you just installed with "proprietary, tested" description
* press on "Apply Changes".

You can verify if the drivers are installed by opening a terminal and running:
```
nvidia-smi
```
If this does not work, and you are sure you correctly installed the drivers, you might need to deactivate the "safe boot" feature from your BIOS, that usually prevents to load the driver. 

Installing Git and SSH key
--------------

To install Git you can open a terminal and run:
```
sudo apt install git
```
After that, you can check the version installed and configure the credentials with:
```
$ git --version
$ git config --global user.name <"name surnace">
$ git config --global user.email <"youremail@yourdomain.it">
```
After this, if you don't have an SSH key for your Github account, you need to create a new one to use the repositories:
* go to Settings/SSH  and GPG Keys
* open a terminal and run these commands:
  ```
  $ ssh-keygen 
  $ cd ~/.ssh/
  $ cat <new_ssh_key>.pub
  ```
Copy the content of your public SSH into the box at the link before and press "New SSH key". You can now clone the  repositories with SSH.


Docker Install
--------------------------------------------------------------------------------
<a name="docker_install"></a>
Instructions:

- Make sure you have:
  - configured Git and SSH key
  - configured the NVIDIA drivers

Then you can run:
```
$ sudo apt install mesa-utils
$ glxinfo | grep NVIDIA
```
- Clone in the $HOME folder (that is "home/USERNAME") the lab-docker repository:
```
$ git clone git@github.com:mfocchi/lab-docker.git
```
- Run the script install_docker.sh:
```
$ ./install_docker.sh
```
- You can now restart the PC so that all changes made can be applied.
- When the PC has restarted, open the `/etc/hosts` file with permissions from the home folder:
```
$ sudo gedit /etc/hosts 
```
add the following line (same as localhost):
```
127.0.0.1	docker
```
if you have troubles using **gedit** use other editors like  **vim** or **nano** in place of gedit

- Before pulling the docker images you have to download some dependencies (if you have :
```
$ pip3 install argcomplete argparse docker dockerpty
$ sudo apt install python3-argcomplete python3-networkmanager (or python-networkmanager)
```
Docker Issues
--------------------------------------------------------------------------------
<a name="docker_issues"></a>

Check this section only if you had any issues in running the docker!

- When launching any graphical interface inside docker (e.g. pycharm or gedit) you get this error:

```
No protocol specified
Unable to init server: Could not connect: Connection refused

(gedit:97): Gtk-WARNING **: 08:21:29.767: cannot open display: :0.0
```

It means that docker is not copying properly the value of you DISPLAY environment variable, you could try to solve it in this way, in a terminal **outside docker** launch:

```
echo $DISPLAY
```

and you will obtain a **value**  (e.g. :0) if you run the same command in a docker terminal the value will be different, then in the .bashrc inside the docker add the following line:

```
export DISPLAY=value
```

- When installing docker using ./installation_tools/install_docker.sh you may have a pip3 syntax error. 

You could try to solve it in this way:

```
curl https://bootstrap.pypa.io/pip/3.5/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py
```

- Nvidia error: could not select device driver “” with capabilities:

You can solve this way:

```
sudo apt install -y nvidia-docker2
sudo systemctl daemon-reload
sudo systemctl restart docker
```

- If the docker installer retrieved using wget produces the following error
```
./install_docker.sh: line 1: syntax error near unexpected token 'newline'
./install_docker.sh: line 1: `<!DOCTYPE html>'
```
- You may need the '-api' option in lab-docker.py
- If you do not have nvidia drivers installed, then make sure you are not using the `-nv` option when launching `lab-docker.py`. You may get a message in the terminal that looks like


![Screenshot_from_2021-02-03_17-15-50](uploads/959899d54f494f3820e5b8b9210a2dd7/Screenshot_from_2021-02-03_17-15-50.png)

![nvidia_issue](uploads/cd09602de0f7edd1e0432359754f495c/nvidia_issue.jpeg)



- If you are getting the error `[Err] [WindowManager.cc:121] Unable to create the rendering window`, you need to update the Nvidea driver to 430. To do this, go to Software & Updates -> Additional Drivers in Ubuntu and choose the driver. Then install nvidia-driver-toolkit (in case you do not have it) and restart the Docker daemon `sudo systemctl restart docker`.

In this case, the message shown in the terminal when launching the simulation will look like

![model_gazebo_missing](uploads/2895e3900d60de8b82cb6fa0196a2207/model_gazebo_missing.jpeg)



- Ubuntu 18 has install problems of python-networkmanager with a weird dbus error.  Installing libdbus-1-dev libdbus-glib-1-dev seemed to be the fix.





