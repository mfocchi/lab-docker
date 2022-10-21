# Virtual Machines on Mac

There are various possibilities:

1. [Parallels Desktop](https://www.parallels.com/it/), which costs 99,99€
2. Multipass free provided by Canonical
3. UTM free based on Qemu


# Parallels Desktop and UTM

Will consider these two together since they are similar. 

If you have Parallels Desktop for some other reasons, or if you happen to find it for free by mistake, then this should be your go to. 

Download the Ubuntu 20.04 version. Notice that if you are running M1, then the version should be [ARM](https://cdimage.ubuntu.com/releases/20.04/release/) to improve performances, otherwise download the [amd64](https://cdimage.ubuntu.com/focal/daily-live/current/) version. 

Then follow the instructions to have it ready and running.

Notice that the ARM64 versions are _server_ based, so they do not provide a desktop environment out of the box, which instead you need. To install it, once you have created the virtual machine, run the VM, log in and type:

```
sudo apt update 
sudo apt install -y ubuntu-desktop
```
If you are Chinese, you may be interested in installing `ubuntukylin-desktop` instead of `ubuntu-desktop`

# Multipass

If you don't have Parallels Desktop, nor you have found it somewhere for free, then the suggestion is to use Multipass over UTM. While they both virtualize the OS using Qemu, Multipass seems to be a little bit faster and reliable on the success of the creation of the VMs. 

## Downloads and installations

```
brew install --cask multipass
```

From the App Store download and install Microsoft Remote Desktop

## Multipass 

### Create instance

```
multipass launch -n <name> 20.04 
```

Notice that the `<name>` cannot contain symbols.

Available options at `multipass launch --help`

- `-c` <cpus> the number of cpus (maximum is 8)
- `-m` <mem> the dimension of RAM to allocate
- `-d` <disk> the dimension of the disk

These options can also be set afterwards with the commands:

```
multipass set local.<name>.cpus=<cpus>
multipass set local.<name>.memory=<mem>
multipass set local.<name>.disk=<disk>
```

### Instance configuration

Open a shell on the instance 

```
multipass shell labdocker
```

Then inside the instance:

```
sudo adduser <user>
sudo usermod -aG sudo <user>
```

It's important to create a new user and set a password, otherwise the graphical interface won't be available.

Install the packages for the desktop environment and the XRDP server:

```
sudo apt update 
sudo apt install -y ubuntu-desktop xrdp
```

Notice, if you are Chinese, you may be interested in installing `ubuntukylin-desktop` instead of `ubuntu-desktop`

Finally reboot the instance:

```
sudo reboot
```

### Connect remotely

Make sure the instance is running, this can be done by checking `multipass list` under the `State` column, or having a shell to the instance open in one terminal.

Open a new terminal while the instance is running and type:

```
multipass info <name>
```

This will tell you some pieces of information on the instance. We are interested in the IPv4 address of the instance.

Then, to remotely login Open Microsoft Remote Desktop:

1. Open Microsoft Remote Desktop;
2. Go to Connections in the menu bar and click on Add PC, alternatively press cmd+n;
3. Under `PC name` paste the IPv4 address of your machine;
4. Under `User account` click on `Add user account`; set the username and the password that were created before;
5. Click add to add the new remote connection. 





