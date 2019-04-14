# FreeIPA

This recipe describes how to install FreeIPA with Ansible on a CentOS VM.

This is a fork of [ansible-freeipa](https://github.com/freeipa/ansible-freeipa) repository.

## Prepare FreeIPA VM

Create a CentOS7.1810 VM with at least 4Gb RAM and 20Gb disk.

Update and prepare hostname with FQDN and hosts :

    sudo yum update -y
    sudo hostnamectl set-hostname myhostname.example.com
    echo "ipaserverIP ipaservername.example.com ipaservername" | sudo tee -a /etc/hosts

## Prepare Manager

Create a Ubuntu 18.04 server VM.

Update and install Ansible

    sudo apt update -y
    sudo apt upgrade -y
    git clone https://github.com/peploleum/deeploy.git
    cd deeploy/ansible
    ./install-ansible.sh
    cd freeipa
    
FreeIPA deployment :

* Prepare ipaserver name resolution

      echo "ipaserverIP ipaservername.example.com ipaservername" | sudo tee -a /etc/hosts

* Update `inventory/hosts` file. It's important to use FQDN for ipaserver. Use the [server documentation](docs/SERVER.md) to understand all variables.

* Add specific requirements

      sudo apt-get install python-gssapi
    
* If you're not in openstack environment, prepare rsa key for ssh access. Always press `ENTER` when prompt.
      
      ssh-keygen -t rsa
      ssh-copy-id <remote-user>@<ipaserverIP>
  
## Run FreeIPA install
  
        ansible-playbook -i inventory/hosts install-server.yml --ask-become-pass
 
 Bim Bim !!!
 
