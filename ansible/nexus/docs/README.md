# Nexus Ansible

This document explains how to prepare and install Nexus OSS. It also explains how to parameter yours clients apps and IDE to use Nexus repository.
  
## Prepare the manager

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

## Prepare the target machine

If you don't use `init_vm.sh` to create a dedicated VM for Nexus, ensure that your existing machine have these ports opened :
* 8081 (Nexus main access)
* 9080 (Nexus docker hosted registry)
* 9081 (Nexus docker proxy)
* 9082 (Nexus docker group)

You can add `nexus` security group to your existing VM to open these ports. 

## Prepare and launch Nexus installation

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


## Configure client

Replace in all following `nexus.peploleum.com` by IP or name of your nexus.

### APT


### YUM


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

```yaml
{
  ...

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


### Docker




## External links

* [Blog savoirfairelinux](https://blog.savoirfairelinux.com/fr-ca/2017/ansible-nexus-repository-manager/)
* [Github ansible-nexus3-oss](https://github.com/savoirfairelinux/ansible-nexus3-oss)
* [Github plugin nexus-repository-apt](https://github.com/sonatype-nexus-community/nexus-repository-apt)
