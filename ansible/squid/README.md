# SQUID Ansible

This document explains how to prepare and install Squid, SquidGuard and Webmin.

## Installation
### Prepare the manager

Create VM and install ansible. `ansible/install-ansible-centos.sh` on CentOS or `ansible/install-ansible.sh` on Ubuntu.

Enable SSH access on the proxy server. Follow [Ansible Stuff](../README.md#run-your-playbook)

### Prepare and launch Squid installation

On the target server :

* Disable SELinux : edit `/etc/selinux/config` and replace `SELINUX=enforcing` by `SELINUX=disabled` then **REBOOT**

### Launch install

On the manager :

* Check and update the target IP and variables in `hosts.ini`

* Run the deployment :

      ansible-playbook -i hosts.ini --user <remote_user> --become --ask-become-pass squid-playbook.yml

### Finalize Redirection

On the target server :

      sudo firewall-cmd --permanent --zone=public --add-forward-port=port=80:proto=tcp:toport=3128:toaddr=<ip_local>
      sudo firewall-cmd --permanent --zone=public --add-forward-port=port=443:proto=tcp:toport=3129:toaddr=<ip_local>
      sudo firewall-cmd --permanent --add-masquerade
      sudo firewall-cmd --reload
