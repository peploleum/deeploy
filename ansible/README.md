# ANSIBLE

## Kubespray

See [Kubespray documentation](./kubespray/README.md).

## General stuff

### Prepare target machine

* Install ssh server

        sudo apt-get install openssh-server

### Prepare deploy host

* Run the script install_ansible.sh
* Update the file /etc/ansible/hosts with target machine IP or Name
* Initialize ssh connection

        ssh (ssh_user)@(target)

### Run gitlab_playbook

        ansible-playbook gitlab-playbook.yml -u (ssh_user) --ask-pass --ask-become-pass

