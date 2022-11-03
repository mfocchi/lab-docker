[Go Back Home](Home)

Install Docker on Windows 
================================================================================

1. Install  Windows Subsystem for Linux (WSL). Open a command prompt with **administration** privileges and type

```powershell
wsl --install
```

New Linux installations, installed using the `wsl --install` command, will be set to WSL 2 by default.

[Install Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/get-started) ***(Recommended)*** Using Windows Terminal supports as many command lines as you would like to install and enables you to open them in multiple tabs or window  panes and quickly switch between multiple Linux distributions or other  command lines.

2. Download [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe) and follow this procedure: https://docs.docker.com/desktop/windows/wsl/

3. open a terminal and type:

   ```powershell
   $ docker pull mfocchi/trento_lab_framework:introrob
   ```

4. add the following alias to the .bashrc:

```powershell
alias lab='docker rm -f docker_container || true; docker run --name docker_container   --user $(id -u):$(id -g)  --workdir="/home/$USER" --volume="/etc/group:/etc/group:ro"   --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/passwd:/etc/passwd:ro" --device=/dev/dri:/dev/dri  -e "QT_X11_NO_MITSHM=1" --network=host -it  --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume $HOME/trento_lab_home:$HOME --env=HOME --env=USER  --privileged  -e SHELL -e "DISPLAY=:0.0" -e DOCKER=1  --entrypoint /bin/bash mfocchi/trento_lab_framework:introrob'
alias dock-other='lab-docker.py attach'
alias dock-root='lab-docker.py attach --root'
```

5. open a docker environment typing "lab" and keep following this wik from "Configure Code" section: https://github.com/mfocchi/lab-docker#configure-code 