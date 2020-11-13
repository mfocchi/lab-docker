#! /usr/bin/python3
# Important notes to self:
# python docker sdk does not have the '--gpu' option (yet) so its done 'manually' below
# I had some issues in the beginning so I made both the high level and api versions

import sys

if not sys.version_info[0] == (3):
	print('Please use python 3')
	sys.exit()

try:
	import argparse
	import os
	import subprocess
	import shutil
	import docker
	import dockerpty
except ImportError as e:
	print(e)
	sys.exit()
	
parser = argparse.ArgumentParser(description='Process command line arguments.')
parser.add_argument('-nv','--nvidia', action='store_true', help='use the nvidia driver')
parser.add_argument('-qt', '--qtcreator', action='store_true', help='start qt creator')
parser.add_argument('-api','--api',action='store_true',help='use the python docker sdk low level api')
parser.add_argument('-e','--env',help='extra environment to pass to the container')
parser.add_argument('-i','--image', default='dls2-operator', help='docker image to run')
parser.add_argument('-j','--project',default='dls2',help='docker image repo project')
parser.add_argument('-t','--tag',default='latest',help='docker image tag')
parser.add_argument('-s','--server',default='server-harbor', help='image repo server')
parser.add_argument('-p','--port',default='80', help='image repo port')
parser.add_argument('-f','--force',action='store_true',help='start container even if another container with the same name exists (it will be deleted)')
args = parser.parse_args()


#Environment
home=os.environ['HOME']
display=os.environ['DISPLAY']
shell=os.environ['SHELL']
result=subprocess.run(['whoami'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
user=result.stdout.decode('utf-8').strip()
result=subprocess.run(['id','-u'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
id=result.stdout.decode('utf-8').strip()
systemd_dir='/sys/fs/cgroup/systemd'
bashrc_skel='/etc/skel/.bashrc'
result=subprocess.run(['git','config','--global','user.email'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
git_email=result.stdout.decode('utf-8').strip()
result=subprocess.run(['git','config','--global','user.name'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
git_name=result.stdout.decode('utf-8').strip()


## Config
dls_dir=home+'/dls_ws_home'
bashrc=dls_dir+'/.bashrc'

container_hostname='docker'
container_name='dls_container'
container_devices=['/dev/dri:/dev/dri']
container_network_mode='host'
container_user=id+':users'
container_environment=['QT_X11_NO_MITSHM=1','SHELL='+shell,'DISPLAY='+display,'DOCKER=1','NVIDIA_VISIBLE_DEVICES=all']
if args.env:
	container_environment=container_environment+[args.env]
container_volumes=['/tmp/.X11-unix:/tmp/.X11-unix:rw','/etc/passwd:/etc/passwd',home+'/.ssh:'+home+'/.ssh:rw',dls_dir+':'+home]
container_working_dir=home
container_image=args.server+':'+args.port+'/'+args.project+'/'+args.image
if args.nvidia:
	container_image+='-nvidia'
	container_runtime='nvidia'
	container_device_requests = [{
	    'Driver': 'nvidia',
	    'Capabilities': [['gpu'], ['nvidia'], ['compute'], ['compat32'], ['graphics'], ['utility'], ['video'], ['display']],  # not sure which capabilities are really needed
	    'Count': -1,  # enable all gpus
	}]
else:
	container_runtime='runc'
	container_device_requests = []
container_image+=':'+args.tag



#Disable access control
result = subprocess.run(['xhost'],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
access_control_enabled = (result.stdout.decode('utf-8').find('access control enabled'))==1
if access_control_enabled:
	subprocess.run(['xhost +'])

#Make sure docker is running
result = subprocess.run(['systemctl','is-active docker'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
docker_inactive = (result.stdout.decode('utf-8').find('inactive'))==1
if docker_inactive:
	result = subprocess.run(['sudo', 'systemctl status docker'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)


#Need to use non-privileged containers
result = subprocess.run(['mountpoint','-q',systemd_dir],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
if result.returncode !=0:
	result = subprocess.run(['sudo','mkdir','-p',systemd_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	result = subprocess.run(['sudo','mount','-t','cgroup','-o','none,name=systemcd','cgroup',systemd_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)

#Check if dls home dir exsists
if not os.path.exists(dls_dir):
	result = subprocess.run(['mkdir',dls_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)

#Check if bashrc exists
if not os.path.isfile(bashrc):
	shutil.copyfile(bashrc_skel, bashrc)

#Check if container already running

result = subprocess.run(['docker','ps','-a','-q','-f','name='+container_name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
if len(result.stdout)>0:
	if args.force:
		subprocess.run(['docker','rm','-f',container_name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	else:
		print('dls_container already running')
		sys.exit()
		
#Create the container
client = docker.from_env()
if not args.api:
	container=client.containers.run(
		container_image,
		command='/bin/bash',
		detach=True,
		hostname=container_hostname,
		name=container_name,
		devices=container_devices,
		network_mode=container_network_mode,
		user=container_user,
		environment=container_environment,
		volumes=container_volumes,
		working_dir=container_working_dir,
		runtime=container_runtime,
		stdin_open=True,
		tty=True,
		)
	#Set git config
	result=container.exec_run(['git','config','--global','user.email',git_email])
	result=container.exec_run(['git','config','--global','user.name',git_name])
	#Handy script for killing gazebo timeouts
	result=container.exec_run(['/root/dls_docker/scripts/timeout.sh','0.1','0.1'],user='root')
	#Start qtcreator
	if args.qtcreator:
		result=container.exec_run(['/bin/bash','-c','source .bashrc && qtcreator'],user=container_user,detach=True)
	dockerpty.exec_command(client.api,container.id,['/bin/bash'])		
else:
	container = client.api.create_container(
		container_image,
		command='/bin/bash',
		hostname=container_hostname,
		name=container_name,
		networking_config = client.api.create_networking_config
		({
			'host': client.api.create_endpoint_config()
		}),
		user=container_user,
		environment=container_environment,
		host_config=client.api.create_host_config
		(
			network_mode='host',
			binds=container_volumes,
			devices=container_devices,
			device_requests=container_device_requests,
		),
		working_dir=container_working_dir,
		runtime=container_runtime,
		tty=True,
		stdin_open=True,
		detach=True,
		)
	#Set git config
	result = client.api.start(container)
	exec_id = client.api.exec_create(container,['git','config','--global','user.email',git_email])
	result=client.api.exec_start(exec_id)
	exec_id = client.api.exec_create(container,['git','config','--global','user.name',git_name])
	result=client.api.exec_start(exec_id)
	#Handy script for killing gazebo timeouts
	exec_id = client.api.exec_create(container,['/root/dls_docker/scripts/timeout.sh','0.1','0.1'],user='root')
	result=client.api.exec_start(exec_id)
	#Start qtcreator
	if args.qtcreator:
		result=client.api.exec_create(container,['/bin/bash','-c','source .bashrc && qtcreator'],user=container_user)
		result=client.api.exec_start(result,detach=True)
		print(result)
	
	#dockerpty.start(client.api, container.get('Id'))	
	dockerpty.exec_command(client.api,container,['/bin/bash'])

