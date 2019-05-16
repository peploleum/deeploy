# SQUID Ansible

This document explains how to prepare and install Squid, SquidGuard and Webmin.

## Installation
### Prepare the manager

Create VM and install ansible. `ansible/install-ansible-centos.sh` on CentOS or `ansible/install-ansible.sh` on Ubuntu.

Enable SSH access on the proxy server. Follow [Ansible Stuff](../README.md#run-your-playbook)

### Prepare and launch Squid installation

* Disable SELinux : edit `/etc/selinux/config` and replace `SELINUX=enforcing` by `SELINUX=disabled` then **REBOOT**

* Check and update the target IP and variables in `hosts.ini`

* Run the deployment :

      ansible-playbook -i hosts.ini --user <remote_user> --become --ask-become-pass squid-playbook.yml

