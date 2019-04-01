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

## Prepare and launch install




## Update Nexus repository


## Configure client


## External links

* [Blog savoirfairelinux](https://blog.savoirfairelinux.com/fr-ca/2017/ansible-nexus-repository-manager/)
* [Github ansible-nexus3-oss](https://github.com/savoirfairelinux/ansible-nexus3-oss)
* [Github plugin nexus-repository-apt](https://github.com/sonatype-nexus-community/nexus-repository-apt)
