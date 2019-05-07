# ANSIBLE

## Kubespray

See [Kubespray documentation](./kubespray/README.md).

## Nexus

See [Nexus documentation](./nexus/docs/README.md).

## iRedMail

See [iRedMail documentation](./iredmail/README.md).

## Gitlab [TODO]

See [Gitlab documentation](./gitlab/README.md).

## General stuff

### Prepare target machine

* Have SSH Server

### Prepare manager (deployment machine)

* Run the script install_ansible.sh
* Update the file /etc/ansible/hosts with target machine IP or create your own hosts.ini file

### Run your playbook

        ansible-playbook -i hosts.ini your-playbook.yml <ssh and sudo option>
        
SSH Options :
* With Rsa_key file 
        
        --key-file "path/to/rsa_key.pem"
* With user and password

        --user <remote_user> --ask-pass

* If you don't want password prompt, create RSA key and copy it on target then use `--user` option without `--ask-pass`

        Create a RSA key ssh-keygen -t rsa
        Copy your key on the host ssh-copy-id <remote_user>@<remote_host>
        Use option --user <remote_user>

Sudo Options :
* Declare privilege escalation method
        
        --become --become-method sudo --become-user root
* If password is needed, add the following

        --ask-become-pass
        

