#! /usr/bin/python3
# PYTHON_ARGCOMPLETE_OK
# Important notes to self:
# python docker sdk does not have the '--gpu' option (yet) so its done 'manually' below
# I had some issues in the beginning so I made both the high level and api versions

import sys

#if not sys.version_info[0] == (3):
#	print('Please use python 3')
#	sys.exit()

try:
	import argparse
	import os
	import subprocess
	import shutil
	import docker
	import dockerpty
	import NetworkManager
	import argcomplete
except ImportError as e:
	print(e)
	sys.exit()
	
class EnvironmentConfig:
	def __init__(self,use_iit_dns=True):
		self.home=os.environ['HOME']
		self.display=os.environ['DISPLAY']
		self.shell=os.environ['SHELL']
		self.dns_servers=[]
		self.dns_searches=[]
		if use_iit_dns:
			self.dns_servers=['10.255.8.30','10.255.8.31'] #IIT
			self.dns_searches=['dls.local','iit.local']
		else:
			for conn in NetworkManager.NetworkManager.ActiveConnections:
				for dev in conn.Devices:
					self.dns_servers=self.dns_servers+dev.Ip4Config.Nameservers
					self.dns_searches=self.dns_searches+dev.Ip4Config.Searches
		result=subprocess.run(['whoami'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		self.user=result.stdout.decode('utf-8').strip()
		result=subprocess.run(['id','-u'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		self.id=result.stdout.decode('utf-8').strip()
		self.systemd_dir='/sys/fs/cgroup/systemd'
		self.bashrc_skel='/etc/skel/.bashrc'
		result=subprocess.run(['git','config','--global','user.email'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		self.git_email=result.stdout.decode('utf-8').strip()
		result=subprocess.run(['git','config','--global','user.name'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		self.git_name=result.stdout.decode('utf-8').strip()

class DlsConfig:
	def __init__(self,environment_config,run_qt=False):
		self.dls_dir = environment_config.home+'/dls_ws_home'
		self.bashrc = self.dls_dir+'/.bashrc'
		self.run_qt = run_qt

class ContainerConfig:
	def __init__(self,environment_config,dls_config,image):
		self.hostname='docker'
		self.name='dls_container'
		self.devices=['/dev/dri:/dev/dri']
		self.network_mode='host'
		self.dns=environment_config.dns_servers
		self.dns_search=environment_config.dns_searches
		self.runtime='runc'
		self.device_requests = []
		self.user=environment_config.id+':users'
		self.environment=['QT_X11_NO_MITSHM=1','SHELL='+environment_config.shell,'DISPLAY='+environment_config.display,'DOCKER=1','NVIDIA_VISIBLE_DEVICES=all']
		self.volumes=['/tmp/.X11-unix:/tmp/.X11-unix:rw','/etc/passwd:/etc/passwd',environment_config.home+'/.ssh:'+environment_config.home+'/.ssh:rw',dls_config.dls_dir+':'+environment_config.home]
		self.working_dir=environment_config.home
		self.image=image
		
class Dls1Images:
	images=['dls-env','dls-dev']
	project='dls'
	server='server-harbor'
	port='80'
	tag='latest'

class Dls2Images:
	images=['dls2-env','dls2-dev','dls2-operator']
	project='dls2'
	server='server-harbor'
	port='80'
	tag='latest'	

def disable_access_control():
	result = subprocess.run(['xhost'],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	access_control_enabled = (result.stdout.decode('utf-8').find('access control enabled'))==1
	if access_control_enabled:
		subprocess.run(['xhost +'])

def ensure_docker_is_running():
	result = subprocess.run(['systemctl','is-active docker'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	docker_inactive = (result.stdout.decode('utf-8').find('inactive'))==1
	if docker_inactive:
		result = subprocess.run(['sudo', 'systemctl status docker'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def mount_systemd(environment_config):
	result = subprocess.run(['mountpoint','-q',environment_config.systemd_dir],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	if result.returncode !=0:
		result = subprocess.run(['sudo','mkdir','-p',environment_config.systemd_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		result = subprocess.run(['sudo','mount','-t','cgroup','-o','none,name=systemcd','cgroup',environment_config.systemd_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def check_dls_home(dls_config):
	if not os.path.exists(dls_config.dls_dir):
		result = subprocess.run(['mkdir',dls_config.dls_dir],stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def check_bashrc(environment_config,dls_config):
	if not os.path.isfile(dls_config.bashrc):
		shutil.copyfile(environment_config.bashrc_skel, dls_config.bashrc)

def is_container_running(container_name):
	result = subprocess.run(['docker','ps','-a','-q','-f','name='+container_name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	return len(result.stdout)>0

def stop_container(container_name):
	subprocess.run(['docker','rm','-f',container_name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)

def pull_base(image):
	client = docker.from_env()
	print(image)
	try:
		prev={'status':'','id':''}
		for line in client.api.pull(image,stream=True,decode=True,tag='latest'):
			if prev["status"]==line["status"] and prev["id"]==line["id"]:
				sys.stdout.write("\033[F") # Cursor up one line
				sys.stdout.write("\033[K") # Clear to the end of line
			if (
				line["status"]=='Downloading' or
				line["status"]=='Extracting'
			):
				print('   '+line['id']+': '+line["status"]+' '+str(line['progressDetail']['current'])+'/'+str(line['progressDetail']['total'])+' '+line['progress'])
			else:
				print('   '+line['id']+': '+line["status"])
			prev = line
	except docker.errors.APIError as err:
		print(err)	

def run_container_high_level_api(client,container_config,environment_config,dls_config):
	container=client.containers.run(
		container_config.image,
		command='/bin/bash',
		detach=True,
		hostname=container_config.hostname,
		name=container_config.name,
		devices=container_config.devices,
		network_mode=container_config.network_mode,
		user=container_config.user,
		environment=container_config.environment,
		volumes=container_config.volumes,
		working_dir=container_config.working_dir,
		runtime=container_config.runtime,
		stdin_open=True,
		dns=container_config.dns,
		dns_search=container_config.dns_search,		
		tty=True,
		)
	#Set git config
	result=container.exec_run(['git','config','--global','user.email',environment_config.git_email])
	result=container.exec_run(['git','config','--global','user.name',environment_config.git_name])
	#Handy script for killing gazebo timeouts
	result=container.exec_run(['/root/dls_docker/scripts/timeout.sh','0.1','0.1'],user='root')
	#Start qtcreator
	if dls_config.run_qt:
		result=container.exec_run(['/bin/bash','-c','source .bashrc && qtcreator'],user=container_config.user,detach=True)
	dockerpty.exec_command(client.api,container.id,['/bin/bash'])

def run_container_low_level_api(client,container_config,environment_config,dls_config):
	container = client.api.create_container(
		container_config.image,
		command='/bin/bash',
		hostname=container_config.hostname,
		name=container_config.name,
		networking_config = client.api.create_networking_config
		({
			'host': client.api.create_endpoint_config()
		}),
		user=container_config.user,
		environment=container_config.environment,
		host_config=client.api.create_host_config
		(
			network_mode='host',
			binds=container_config.volumes,
			devices=container_config.devices,
			device_requests=container_config.device_requests,
			dns=container_config.dns,
			dns_search=container_config.dns_search,
		),
		working_dir=container_config.working_dir,
		runtime=container_config.runtime,
		tty=True,
		stdin_open=True,
		detach=True,
		)
	result = client.api.start(container)
	#Set git config
	exec_id = client.api.exec_create(container,['git','config','--global','user.email',environment_config.git_email])
	result=client.api.exec_start(exec_id)
	exec_id = client.api.exec_create(container,['git','config','--global','user.name',environment_config.git_name])
	result=client.api.exec_start(exec_id)
	#Handy script for killing gazebo timeouts
	exec_id = client.api.exec_create(container,['/root/dls_docker/scripts/timeout.sh','0.1','0.1'],user='root')
	result=client.api.exec_start(exec_id)
	#Start qtcreator
	if dls_config.run_qt:
		result=client.api.exec_create(container,['/bin/bash','-c','source .bashrc && qtcreator'],user=container_config.user)
		result=client.api.exec_start(result,detach=True)
	
	#dockerpty.start(client.api, container.get('Id'))	
	dockerpty.exec_command(client.api,container,['/bin/bash'])

def check_exists(image):
	client = docker.from_env()
	try:
		result = client.images.get(image)
	except docker.errors.ImageNotFound:
		print(image + ' Not Found')
		return False
	return True
			
def run_container(args,image):
	environment_config = EnvironmentConfig(use_iit_dns=not args.dns)
	dls_config = DlsConfig(environment_config,run_qt=args.qtcreator)
	container_config = ContainerConfig(environment_config,dls_config,image)
	if len(args.env)>0:
		container_config.environment.extend(args.env)
	if args.nvidia:
		container_config.runtime='nvidia'
		container_config.device_requests = [{
		    'Driver': 'nvidia',
		    'Capabilities': [['gpu'], ['nvidia'], ['compute'], ['compat32'], ['graphics'], ['utility'], ['video'], ['display']],  # not sure which capabilities are really needed
		    'Count': -1,  # enable all gpus
		}]
	disable_access_control()
	ensure_docker_is_running()
	mount_systemd(environment_config) #Need to use non-privileged containers
	check_dls_home(dls_config)
	check_bashrc(environment_config,dls_config)
	if is_container_running(container_config.name):
		if args.force:
			stop_container(container_config.name)
		else:
			print(container_config.name+' already running')
			sys.exit()
	client = docker.from_env()
	if not check_exists(image):
		pull_base(image)
	if args.api:
		run_container_low_level_api(client,container_config,environment_config,dls_config)
	else:
		run_container_high_level_api(client,container_config,environment_config,dls_config)

def combine_image_name(server,port,project,image,nvidia,tag):
	image=server+':'+port+'/'+project+'/'+image
	if nvidia:
		image+='-nvidia'
	image+=':'+tag
	return image
		
def run2(args):
	image=combine_image_name(args.server,args.port,args.project,args.image,args.nvidia,args.tag)
	run_container(args,image)


def run(args):
	image=args.name
	run_container(args,image)

def kill(args):
	subprocess.run(['docker','kill',args.name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)

def stop(args):
	subprocess.run(['docker','stop',args.name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)

def rm(args):
	subprocess.run(['docker','rm','-f',args.name],stdout=subprocess.PIPE,stderr=subprocess.PIPE)

def attach(args):
	client = docker.from_env()
	container_list = client.containers.list()
	for container in container_list:
		if container.name=='dls_container':
			if not args.root:
				dockerpty.exec_command(client.api,container.id,['/bin/bash'])
			else:
				exec_id = client.api.exec_create(container.id, ['/bin/bash'], tty=True, stdin=True,user='root')
				operation = dockerpty.pty.ExecOperation(client.api,exec_id,interactive=True, stdout=None, stderr=None, stdin=None)
				dockerpty.pty.PseudoTerminal(client.api, operation).start()
				
def pull2(args):
	image = combine_image_name(args.server,args.port,args.project,args.image,args.nvidia,args.tag)
	pull_base(image)

def pull(args):
	pull_base(args.name)

def pull_all(args):
	if args.dls1 or not args.dls2:
		for image in Dls1Images.images:
			name = combine_image_name(Dls1Images.server,Dls1Images.port,Dls1Images.project,image,args.nvidia,Dls1Images.tag) 
			pull_base(name)
	if args.dls2 or not args.dls1:
		for image in Dls2Images.images:
			name = combine_image_name(Dls2Images.server,Dls2Images.port,Dls2Images.project,image,args.nvidia,Dls2Images.tag)
			pull_base(name)


def make_parser():
	parser = argparse.ArgumentParser(description='Process command line arguments.')

	subs = parser.add_subparsers(title='Commands')

	parser_run 		= subs.add_parser('run',	help='run docker image with single arguments')
	parser_run2		= subs.add_parser('run2',	help='run docker image with server, port, project, image, and tag arguments')
	parser_stop		= subs.add_parser('stop',	help='Stop container')
	parser_kill		= subs.add_parser('kill',	help='Kill container')
	parser_rm		= subs.add_parser('rm',	help='Remove container')
	parser_attach		= subs.add_parser('attach',	help='Attach a terminal to container')
	parser_pull		= subs.add_parser('pull',	help='pull a docker image')
	parser_pull2		= subs.add_parser('pull2',	help='pull docker image with server, port, project, image, and tag arguments')
	parser_pull_all	= subs.add_parser('pull_all',	help='pull all of the dls1 and dls2 images')

	parser_run.set_defaults(func=run)
	parser_run2.set_defaults(func=run2)
	parser_stop.set_defaults(func=stop)
	parser_kill.set_defaults(func=kill)
	parser_attach.set_defaults(func=attach)
	parser_rm.set_defaults(func=rm)
	parser_pull.set_defaults(func=pull)
	parser_pull2.set_defaults(func=pull2)
	parser_pull_all.set_defaults(func=pull_all)

	parser.add_argument('-a','--api',action='store_true',help='use the python docker sdk low level api')
	parser.add_argument('-d','--debug',action='store_true',help='to debug this python script')
	
	parser_run2.add_argument('-i','--image', default='dls2-operator', help='docker image to run')
	parser_run2.add_argument('-j','--project',default='dls2',help='docker image repo project')
	parser_run2.add_argument('-s','--server',default='server-harbor', help='image repo server')
	parser_run2.add_argument('-p','--port',default='80', help='image repo port')
	parser_run2.add_argument('-t','--tag',default='latest',help='docker image tag')
	parser_run2.add_argument('-nv','--nvidia', action='store_true', help='use the nvidia driver')
	parser_run2.add_argument('-qt', '--qtcreator', action='store_true', help='start qt creator')
	parser_run2.add_argument('-f','--force',action='store_true',help='start container even if another container with the same name exists (it will be deleted)')
	parser_run2.add_argument('-e','--env',default=[],action='append',help='extra environment to pass to the container')
	parser_run2.add_argument('-d','--dns',action='store_true',help='use host dns instead of iit dns')	
	parser_run.add_argument('name', default='ubuntu:16.04', nargs='?', help='docker image to run')
	parser_run.add_argument('-nv','--nvidia', action='store_true', help='use the nvidia driver')
	parser_run.add_argument('-qt', '--qtcreator', action='store_true', help='start qt creator')
	parser_run.add_argument('-f','--force',action='store_true',help='start container even if another container with the same name exists (it will be deleted)')
	parser_run.add_argument('-e','--env',default=[],action='append',help='extra environment to pass to the container')
	parser_run.add_argument('-d','--dns',action='store_true',help='use host dns instead of iit dns')
	
	parser_kill.add_argument('name', default='dls_container', nargs='?', help='docker container to kill')
	parser_stop.add_argument('name', default='dls_container', nargs='?', help='docker container to stop')
	parser_rm.add_argument('name', default='dls_container', nargs='?', help='docker container to remove')
	parser_attach.add_argument('name', default='dls_container', nargs='?', help='docker container to attach')
	parser_attach.add_argument('-r','--root',action='store_true',help='attach the root user to the container')
	
	parser_pull.add_argument('-a','--all',action='store_true',help='pull all docker images currently on localhost')
	parser_pull.add_argument('name',nargs='?',help='name of the image to pull')	
	
	parser_pull2.add_argument('-i','--image', default='dls2-operator', help='docker image to run')
	parser_pull2.add_argument('-j','--project',default='dls2',help='docker image repo project')
	parser_pull2.add_argument('-s','--server',default='server-harbor', help='image repo server')
	parser_pull2.add_argument('-p','--port',default='80', help='image repo port')
	parser_pull2.add_argument('-t','--tag',default='latest',help='docker image tag')
	parser_pull2.add_argument('-nv','--nvidia', action='store_true', help='use the nvidia driver')

	parser_pull_all.add_argument('-nv','--nvidia',action='store_true',help='pull the images with the nvidia driver')
	pull_all_group = parser_pull_all.add_mutually_exclusive_group()
	pull_all_group.add_argument('-d1','--dls1',action='store_true',help='just pull the dls1 images')
	pull_all_group.add_argument('-d2','--dls2',action='store_true',help='just pull the dls2 images')

	
	return parser

def main():
	parser = make_parser()
	debug=True
	argcomplete.autocomplete(parser)
	try:
		args = parser.parse_args()
		debug=args.debug
		args.func(args)
	except:
		if debug:
			print("Unexpected error:", sys.exc_info()[0])
			raise
		else:
			parser.print_help(sys.stderr)
	sys.exit()

if __name__ == '__main__':
    main()


	





