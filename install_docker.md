[Go Back Home](Home)

Docker Wiki
================================================================================

This section of the wiki gives information on how to use the docker.

1. [Installing Git and SSH key](#installing-git-and-ssh-key)
3. [Docker Install](#docker-install) 
3. [Installing NVIDIA drivers](#installing-nvidia-drivers) 
4. [Common Docker Install Issues](#docker_issues)



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
  $ cat id_rsa.pub
  ```
  Copy the content of your public SSH into the box at the link before and press "New SSH key". You can now clone the  repositories with SSH without having to issue the password every time (I suggest to do not set any passphrase).



Docker Install
--------------------------------------------------------------------------------

<a name="docker_install"></a>
Clone in the $HOME folder (usually is "home/USERNAME") the lab-docker repository:

```
$ git clone git@github.com:mfocchi/lab-docker.git
```
- Run the script install_docker.sh. This script is important because it installs the docker client on your machine and adds to your user the privileges to run the docker images.
```
$ ./install_docker.sh
```
- If everything went smooth you should read: **To start docker, reboot the system!** You can now restart the PC so that all changes made can be applied.

- If you look into your **host** Ubuntu home directory, you will see that the **trento_lab_home** directory has been created.

- if you have troubles using **gedit** use other editors like  **vim** or **nano** in place of gedit

  
  
  
Installing NVIDIA drivers (optional)
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

Install the driver, note that for Ubuntu 20.04 the 515 version is ok, for Ubuntu 22.04 the 535 is ok, but you can use also other versions:

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



## Docker Issues (optional)

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

- If you do not have Nvidia drivers installed, then make sure you are not using the `-nv` option when launching `lab-docker.py`. You may get a message in the terminal that looks like this:

  ![nvidia_issue](uploads/cd09602de0f7edd1e0432359754f495c/nvidia_issue.jpeg)

  

- Nvidia error: could not select device driver “” with capabilities:

You can solve this way:

```
sudo apt install -y nvidia-docker2
sudo systemctl daemon-reload
sudo systemctl restart docker
```







