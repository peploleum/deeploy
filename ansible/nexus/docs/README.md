# Nexus Ansible

This document explains how to prepare and install Nexus OSS. It also explains how to parameter yours clients apps and IDE to use Nexus repository.

## Summary

* [Installation](#installation)
  * [Prepare the manager](#prepare-the-manager)
  * [Prepare the target machine](#prepare-the-target-machine)
  * [Prepare and launch Nexus installation](#prepare-and-launch-nexus-installation)
* [Update Nexus Repository](#update-nexus-repository)
* [Configure client](#configure-client)
  * [APT](#apt)
  * [YUM](#yum)
  * [Maven](#maven-java-and-scala)
  * [Node](#node-javascript)
  * [Pypi](#pypi-python)
  * [Docker](#docker)
* [External links](#external-links)

## Installation
### Prepare the manager

Update variables in the file `vm/nexus.conf`.

If you want to install Nexus on an existing machine, modify this line :

    export USE_NEXUS_VM=false

Launch VM with :
    
    ./vm/init_vm.sh

Connect on manager :

    cd ~
    cp -R /home/temp/* .
    sudo rm -R /home/temp
    cd deeploy/ansible
    ./install_ansible.sh

### Prepare the target machine

If you don't use `init_vm.sh` to create a dedicated VM for Nexus, ensure that your existing machine have these ports opened :
* 8081 (Nexus main access)
* 9080 (Nexus docker hosted registry)
* 9081 (Nexus docker proxy)
* 9082 (Nexus docker group)

You can add `nexus` security group to your existing VM to open these ports. 

### Prepare and launch Nexus installation

On the manager :
* Check and update the target IP in `hosts.ini`
* Check and update all ansible variables in  `roles/nexus/defaults/main.yml`. A large part of this file is explain [here](nexus-oss-3.md).

This file allow you to manage users / roles / blobstore / repository / ldap / ... during the installation. Take time to be sure that everything is good for you before running installation. 
> **WARNING** : LDAP configuration must be updated or removed.

Run the deployment :

     ansible-playbook -i hosts.ini --key-file "~/rsa_key.pem" --become --become-method=sudo --become-user=root nexus-playbook.yml
 
 Wait some minutes. If all it's ok you'll have this kind of return : 
 
 ```console
 PLAY RECAP ************************************************************************
 nexus                      : ok=308  changed=31   unreachable=0    failed=0
 ```
 
## Update Nexus repository

You need to have Nexus installed with this Ansible role on 2 separated machine (Ubuntu 18.04 server). One offline and one online.

### Generate Backup on offline machine

A cron backup task is running once a day and create an archive in `/var/nexus-backup/`. The file name is `blob-backup-yy-mm-dd.tar.gz`.  

If needed, you can create a new backup file with this command :

     sudo nexus-blob-backup.sh

Transfer the last archive on the online machine.

### Update online machine from backup
 
Use the `nexus-blob-restore.sh` script to apply the backup.
 
     sudo nexus-blob-restore.sh blob-backup-yy-mm-dd.tar.gz
     
Wait a minute, your online Nexus must have exactly the same content of your offline Nexus.

Execute all you want to add content in your Nexus. You can use the [documentation below](#configure-client) to param your apps to work with Nexus.

Once you have finish, use backup script on your online machine to create a new archive.

     sudo nexus-blob-backup.sh
     
Transfer the archive on the offline machine.

### Update offline machine

On the offline machine use this command :

     sudo nexus-blob-restore.sh blob-backup-yy-mm-dd.tar.gz

Wait a minute while Nexus is booting. Check with Nexus WebUI that your offline Nexus is up to date.

## Configure client

Replace in all following `nexus.peploleum.com` with IP or name of your nexus.

### APT

We describe 3 methods:
* Manual
* Apt-add-repository
* Cloud-init

##### Manual
You can update manually `/etc/apt/sources.list` and files in `/etc/apt/sources.list.d/` and replace url. For example, replace line :
     
     deb http://nova.clouds.archive.ubuntu.com/ubuntu/ bionic main restricted
with
 
     deb http://nexus.peploleum.com:8081/repository/apt-archive-bionic/ bionic main restricted

##### Apt-add-repository
You can use `apt-add-repository` to add new source to apt.

     sudo apt-add-repository http://nexus.peploleum.com:8081/repository/apt-ansible-bionic/
 
##### Cloud-init
You can use `cloud-init` file when you create your VM to configure your apt repository.

```yaml
#cloud-config

apt:
  primary:
    - arches: [default]
      uri: http://nexus.peploleum.com:8081/repository/apt-archive-bionic/
  security:
    - arches: [default]
      uri: http://nexus.peploleum.com:8081/repository/apt-security-bionic/
  sources:
    docker:
      source: "deb http://nexus.peploleum.com:8081/repository/apt-docker-bionic bionic stable"
      key: |
        ------BEGIN PGP PUBLIC KEY BLOCK-------
        <key data>
        ------END PGP PUBLIC KEY BLOCK-------
```

> [Here](ubuntu-cloudinit.yml) is a file for ubuntu server 18.04 with docker repository.

### YUM

We describe 2 methods:
* Manual
* Cloud-init

> **WARNING** : On CentOS, you need to disable fastestmirror to avoid troubles. In file `/etc/yum/pluginconf.d/fastestmirror.conf`, change `enabled` value to `0`.

##### Manual
You can update or create files in `/etc/yum.repos.d/` and replace url. For example, replace line :
     
     baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
with
 
     baseurl=http://nexus.peploleum.com:8081/repository/yum-centos/$releasever/os/$basearch/

##### Cloud-init
You can use `cloud-init` file when you create your VM to configure your apt repository.

```yaml
#cloud-config

yum_repos:
    nexus-yum-base:
        name: Nexus CentOS-$releasever - Base
        baseurl: http://nexus.peploleum.com:8081/repository/yum-centos/$releasever/os/$basearch/
        enabled: true
        gpgcheck: true
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

> [Here](centos-cloudinit.yml) is a file for centos 7 18.11 with docker repository. It also disable fastestmirror plugin.

### Maven (Java and Scala)
Update `settings.xml` to add nexus as server and mirror. Find this file :
* `${maven.home}/conf/settings.xml` to globally configure
* `${user.home}/.m2/settings.xml` to user configure

```xml
<settings>

  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
    <server>
      <id>nexus-releases</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
  </servers>

  <mirrors>
    <mirror>
      <id>nexus</id>
      <name>nexus</name>
      <url>http://nexus.peploleum.com:8081/repository/maven-public/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>

</settings>
```

If you want to publish your project, put this in the `pom.xml` :

```xml
  <distributionManagement>
    <snapshotRepository>
      <id>nexus-snapshots</id>
      <url>http://nexus.peploleum.com:8081/repository/maven-private-snapshots/</url>
    </snapshotRepository>
    <repository>
      <id>nexus-releases</id>
      <url>http://nexus.peploleum.com:8081/repository/maven-private-releases/</url>
    </repository>
  </distributionManagement>
```

### Node (Javascript)

Update `.npmrc` or `npmrc` to add nexus as repository. Find this file :
* per-project config file (`/path/to/my/project/.npmrc`)
* per-user config file (`~/.npmrc`)
* npm builtin config file (`/path/to/npm/npmrc`)

```bash
registry=http://nexus.peploleum.com:8081/repository/npm-all/
```

If you have a project that you want to publish to your Nexus, put this in `package.json`:

```json
{


  "publishConfig": {
    "registry": "http://nexus.peploleum.com:8081/repository/npm-internal/"
  }
}
```

and put authentication in your `.npmrc`
```bash
email=you@example.com
always-auth=true
_auth=YWRtaW46YWRtaW4xMjM=
```
`YWRtaW46YWRtaW4xMjM=` is base64-encoded string for `admin:admin123`. You can create this encoded string with the command line call to openssl :

    echo -n 'admin:admin123' | openssl base64

Now, you can publish with :

    npm publish

### Pypi (Python)

Create or update `pip.conf` or `pip.ini` file. Find file here :
* `/etc/pip.conf` or `~/.config/pip/pip.conf` on Linux
* `%HOME/pip/pip.ini` on Windows

```ini
[global]
index = http://nexus.peploleum.com:8081/repository/pypi-all/pypi
index-url = http://nexus.peploleum.com:8081/repository/pypi-all/simple
trusted-host = nexus.peploleum.com
```

You can pull package :

     pip install <package_name>

##### Publish python package

Create file `.pypirc` in `$HOME` and declare your private repository :

```ini
[distutils]
index-servers=
    nexus

[nexus]
repository: http://nexus.peploleum.com:8081/repository/pypi-internal/
username: admin
password: admin123
```

Install `twine` to publish :

    pip install twine 

> **WARNING** : Ensure that `twine` is in your $PATH. you can use `pip show -f twine` to locate.

Publish with :
 
    twine upload -r nexus /path/to/dist.tar.gz

### Docker

Create or update `daemon.json` to declare nexus registry as insecure. Find this file :
* `/etc/docker/daemon.json` on Linux
* `C:\ProgramData\Docker\config\daemon.json` on Windows

Your `daemon.json` may look like this :
```json
{
"debug": true,
"ipv6": true,
"fixed-cidr-v6": "2001:db8:1::/64",
"hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"],
"insecure-registries": ["http://nexus.peploleum.com:9082","http://nexus.peploleum.com:9080"]
}
```

Reload configuration :
* On Linux :

      sudo systemctl daemon-reload
      sudo systemctl restart docker

* On Windows, restart docker service

##### Pull
Login to repository :

     docker login nexus.peploleum.com:9082
Pull image :
     
     docker pull nexus.peploleum.com:9082/hello-world:latest

##### Push
Login to repository :

     docker login nexus.peploleum.com:9080
Tag and push image :
     
     docker tag <image ID> nexus.peploleum.com:9080/<image>:<tag>
     docker push nexus.peploleum.com:9080/<image>:<tag>

> **WARNING** pull port and push port are different. 

## External links

* [Blog savoirfairelinux](https://blog.savoirfairelinux.com/fr-ca/2017/ansible-nexus-repository-manager/)
* [Github ansible-nexus3-oss](https://github.com/savoirfairelinux/ansible-nexus3-oss)
* [Github plugin nexus-repository-apt](https://github.com/sonatype-nexus-community/nexus-repository-apt)
