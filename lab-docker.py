#!/usr/bin/env python3

# PYTHON_ARGCOMPLETE_OK
# Important notes to self:
# python docker sdk does not have the '--gpu' option (yet) so its done 'manually' below
# I had some issues in the beginning so I made both the high level and api versions

import sys

#  if not sys.version_info[0] == (3):
#       print('Please use python 3')
#       sys.exit()

try:
    import argparse
    import os
    import subprocess
    import shutil
    import docker
    import dockerpty
    import argcomplete
except ImportError as e:
    print(e)
    sys.exit()


class EnvironmentConfig:
    def __init__(self):
        self.home = os.environ['HOME']
        self.display = os.environ['DISPLAY']
        self.shell = '/bin/bash'


        result = subprocess.run(['whoami'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.user = result.stdout.decode('utf-8').strip()
        result = subprocess.run(['id', '-u'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.id = result.stdout.decode('utf-8').strip()
        self.systemd_dir = '/sys/fs/cgroup/systemd'
        self.bashrc_skel = '/etc/skel/.bashrc'
        result = subprocess.run(['git', 'config', '--global', 'user.email'],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.git_email = result.stdout.decode('utf-8').strip()
        result = subprocess.run(['git', 'config', '--global', 'user.name'],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.git_name = result.stdout.decode('utf-8').strip()


class DlsConfig:
    def __init__(self, environment_config, run_qt=False, code_dir_name='trento_lab_home'):
        self.dls_dir = environment_config.home + '/'+code_dir_name
        self.bashrc = self.dls_dir+'/.bashrc'
        self.run_qt = run_qt


class ContainerConfig:
    def __init__(self, environment_config, dls_config, image):
        self.hostname = 'docker'
        self.name = 'docker_container'
        self.devices = ['/dev/dri:/dev/dri', '/dev/input:/dev/input'] if 'linux' in sys.platform else []
        self.network_mode = 'host'
        self.ulimits = [docker.types.Ulimit(name='nofile', soft=1024, hard=524288)]
        self.runtime = 'runc'
        self.device_requests = []
        self.user = environment_config.id+':users'
        self.environment = [
	    'USER='+ environment_config.user,
            'QT_X11_NO_MITSHM=1',
            'SHELL=' + environment_config.shell,
            'DISPLAY=:0.0',
            'DOCKER=1', 'NVIDIA_VISIBLE_DEVICES=all'
        ]
        self.volumes = [
            '/tmp/.X11-unix:/tmp/.X11-unix:rw',
            environment_config.home+'/.ssh:'+environment_config.home+'/.ssh:rw',
            dls_config.dls_dir+':'+environment_config.home
        ]
        if "linux" in sys.platform: # I cannot find a way to replace /etc/passwd in Mac 
            self.volumes.append('/etc/passwd:/etc/passwd:ro')
        elif "darwin" in sys.platform:
            shutil.copy('/etc/passwd', './passwd')
            import pwd
            with open('./passwd', "a") as F:
                F.write("{}:{}:{}:{}:{}:{}:{}".format(
                    environment_config.user,
                    pwd.getpwnam(environment_config.user).pw_passwd,
                    pwd.getpwnam(environment_config.user).pw_uid,
                    pwd.getpwnam(environment_config.user).pw_gid,
                    pwd.getpwnam(environment_config.user).pw_gecos,
                    pwd.getpwnam(environment_config.user).pw_dir,
                    pwd.getpwnam(environment_config.user).pw_shell
                ))
            self.volumes.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),'passwd')+':/etc/passwd:ro')


        self.working_dir = environment_config.home
        self.image = image
        self.security_opt = ['apparmor:unconfined']


def disable_access_control():
    result = subprocess.run(['xhost'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    access_control_enabled = (result.stdout.decode('utf-8').find('access control enabled')) == 0
    if access_control_enabled:
        subprocess.run(['xhost','+'])


def ensure_docker_is_running():
    if "linux" in sys.platform:
        result = subprocess.run(['systemctl', 'is-active', 'docker'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        docker_inactive = (result.stdout.decode('utf-8').find('inactive')) == 1
        if docker_inactive:
            result = subprocess.run(['sudo', 'systemctl', 'status', 'docker'],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # No need to check if Docker is running under Mac has it raises an exception before reaching this check    


def mount_systemd(environment_config):
    result = subprocess.run(['mountpoint', '-q', environment_config.systemd_dir],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        result = subprocess.run(['sudo', 'mkdir', '-p', environment_config.systemd_dir],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        result = subprocess.run(
            ['sudo', 'mount', '-t', 'cgroup', '-o', 'none,name=systemcd', 'cgroup', environment_config.systemd_dir],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def check_dls_home(dls_config):
    if not os.path.exists(dls_config.dls_dir):
        result = subprocess.run(['mkdir', dls_config.dls_dir], stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def check_bashrc(environment_config, dls_config):
    if not os.path.isfile(dls_config.bashrc):
        shutil.copyfile(environment_config.bashrc_skel, dls_config.bashrc)


def is_container_running(container_name):
    result = subprocess.run(['docker', 'ps', '-a', '-q', '-f', 'name='+container_name],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return len(result.stdout) > 0


def stop_container(container_name):
    subprocess.run(['docker', 'rm', '-f', container_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)



def run_container_high_level_api(client, container_config, environment_config, dls_config, no_attach=True):
    container = client.containers.run(
        container_config.image,
        command='/bin/bash',
        detach=True,
        hostname=container_config.hostname,
        name=container_config.name,
        devices=container_config.devices,
        network_mode=container_config.network_mode,
        user=container_config.user,
        group_add=['plugdev'],
        environment=container_config.environment,
        volumes=container_config.volumes,
        working_dir=container_config.working_dir,
        runtime=container_config.runtime,
        stdin_open=True,

        tty=True,
        security_opt=container_config.security_opt,
        )
    # Set git config
    result = container.exec_run(['git', 'config', '--global', 'user.email', environment_config.git_email])
    result = container.exec_run(['git', 'config', '--global', 'user.name', environment_config.git_name])
    # Handy script for killing gazebo timeouts
    result = container.exec_run(['/root/dls_docker/scripts/timeout.sh', '0.1', '0.1'], user='root')
    # Start qtcreator
    if dls_config.run_qt:
        result = container.exec_run(['/bin/bash', '-c', 'source .bashrc && qtcreator'],
                                    user=container_config.user, detach=True)

    if not no_attach:
        dockerpty.exec_command(client.api, container.id, ['/bin/bash'])


def run_container_low_level_api(client, container_config, environment_config, dls_config, no_attach=False):
    container = client.api.create_container(
        container_config.image,
        command='/bin/bash',
        hostname=container_config.hostname,
        name=container_config.name,
        networking_config=client.api.create_networking_config({
            'host': client.api.create_endpoint_config()
        }),
        user=container_config.user,
        environment=container_config.environment,
        host_config=client.api.create_host_config
        (
            network_mode='host',
            ulimits=container_config.ulimits,
            binds=container_config.volumes,
            devices=container_config.devices,
            device_requests=container_config.device_requests,
            security_opt=container_config.security_opt,
            group_add=['plugdev'],
        ),
        working_dir=container_config.working_dir,
        runtime=container_config.runtime,
        tty=True,
        stdin_open=True,
        detach=True,
        )
    result = client.api.start(container)
    # Set git config
    exec_id = client.api.exec_create(container, ['git', 'config', '--global', 'user.email', environment_config.git_email])  # noqa: E501
    result = client.api.exec_start(exec_id)
    exec_id = client.api.exec_create(container, ['git', 'config', '--global', 'user.name', environment_config.git_name])
    result = client.api.exec_start(exec_id)
    # Handy script for killing gazebo timeouts
    exec_id = client.api.exec_create(container, ['/root/dls_docker/scripts/timeout.sh', '0.1', '0.1'], user='root')
    result = client.api.exec_start(exec_id)
    # Start qtcreator
    if dls_config.run_qt:
        result = client.api.exec_create(container, ['/bin/bash', '-c', 'source .bashrc && qtcreator'], user=container_config.user)  # noqa: E501
        result = client.api.exec_start(result, detach=True)

    if not no_attach:
        # dockerpty.start(client.api, container.get('Id'))
        dockerpty.exec_command(client.api, container, ['/bin/bash'])


def check_exists(image):
    client = docker.from_env()
    try:
        result = client.images.get(image)
    except docker.errors.ImageNotFound:
        print(image + ' Not Found')
        return False
    return True


def run_container(args, image):
    environment_config = EnvironmentConfig()
    dls_config = DlsConfig(environment_config, run_qt=args.qtcreator, code_dir_name=args.codedir)

    container_config = ContainerConfig(environment_config, dls_config, image)
    if len(args.env) > 0:
        container_config.environment.extend(args.env)
    if args.nvidia:
        container_config.runtime = 'nvidia'
        container_config.device_requests = [{
            'Driver': 'nvidia',
            'Capabilities': [['gpu'], ['nvidia'], ['compute'], ['compat32'], ['graphics'], ['utility'], ['video'], ['display']],  # not sure which capabilities are really needed  # noqa: E501
            'Count': -1,  # enable all gpus
        }]
    disable_access_control()
    ensure_docker_is_running()
    # Not working for MAC
    #mount_systemd(environment_config)  # Need to use non-privileged containers
    check_dls_home(dls_config)
    check_bashrc(environment_config, dls_config)
    if is_container_running(container_config.name):
        if args.force:
            stop_container(container_config.name)
        else:
            print(container_config.name+' already running')
            sys.exit()
    client = docker.from_env()

    if args.api:
        run_container_low_level_api(client, container_config, environment_config, dls_config, args.noattach)
    else:
        run_container_high_level_api(client, container_config, environment_config, dls_config, args.noattach)


def combine_image_name(server, port, project, image, nvidia, tag):
    image = server+':'+port+'/'+project+'/'+image
    if nvidia:
        image += '-nvidia'
    image += ':'+tag
    return image


def run(args):
    image = args.name
    run_container(args, image)


def kill(args):
    subprocess.run(['docker', 'kill', args.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def stop(args):
    subprocess.run(['docker', 'stop', args.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def rm(args):
    subprocess.run(['docker', 'rm', '-f', args.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def attach(args):
    client = docker.from_env()
    container_list = client.containers.list()
    for container in container_list:
        if container.name == 'docker_container':
            if not args.root:
                dockerpty.exec_command(client.api, container.id, ['/bin/bash'])
            else:
                exec_id = client.api.exec_create(container.id, ['/bin/bash'], tty=True, stdin=True, user='root')
                operation = dockerpty.pty.ExecOperation(client.api, exec_id, interactive=True, stdout=None,
                                                        stderr=None, stdin=None)
                dockerpty.pty.PseudoTerminal(client.api, operation).start()




def make_parser():
    parser = argparse.ArgumentParser(description='Process command line arguments.')

    subs = parser.add_subparsers(title='Commands')

    parser_run      = subs.add_parser('run',      help='run docker image with single arguments')  # noqa: E221
    parser_stop     = subs.add_parser('stop',     help='Stop container')  # noqa: E221
    parser_kill     = subs.add_parser('kill',     help='Kill container')  # noqa: E221
    parser_rm       = subs.add_parser('rm',       help='Remove container')  # noqa: E221
    parser_attach   = subs.add_parser('attach',   help='Attach a terminal to container')  # noqa: E221
 
    parser_run.set_defaults(func=run)
    parser_stop.set_defaults(func=stop)
    parser_kill.set_defaults(func=kill)
    parser_attach.set_defaults(func=attach)
    parser_rm.set_defaults(func=rm)
 
    parser.add_argument('-a', '--api', action='store_true', help='use the python docker sdk low level api')
    parser.add_argument('-d', '--debug', action='store_true', help='to debug this python script')

    parser_run.add_argument('name', default='ubuntu:16.04', nargs='?', help='docker image to run')
    parser_run.add_argument('-nv', '--nvidia', action='store_true', help='use the nvidia driver')
    parser_run.add_argument('-qt', '--qtcreator', action='store_true', help='start qt creator')
    parser_run.add_argument('-f', '--force', action='store_true', help='start container even if another container with the same name exists (it will be deleted)')  # noqa: E501
    parser_run.add_argument('-e', '--env', default=[], action='append', help='extra environment to pass to the container')  # noqa: E501
    parser_run.add_argument('-na', '--noattach', action='store_true', help='Run container but do not attach a terminal')  # noqa: E501
    parser_run.add_argument('-codedir', '--codedir', default='trento_lab_home', help='specify home folder in dls_ws_*')

    parser_kill.add_argument('name', default='docker_container', nargs='?', help='docker container to kill')
    parser_stop.add_argument('name', default='docker_container', nargs='?', help='docker container to stop')
    parser_rm.add_argument('name', default='docker_container', nargs='?', help='docker container to remove')
    parser_attach.add_argument('name', default='docker_container', nargs='?', help='docker container to attach')
    parser_attach.add_argument('-r', '--root', action='store_true', help='attach the root user to the container')

    return parser


def main():
    parser = make_parser()
    debug = True
    argcomplete.autocomplete(parser)
    try:
        args = parser.parse_args()
	# ALWAYS IN DEBUG MODE
        #debug = args.debug	
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
