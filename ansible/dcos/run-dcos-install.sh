#!/bin/bash

# Load variables
. /home/temp/deeploy/ansible/dcos/dcos.conf
. /home/temp/deeploy/openstack/admin-openrc

cd ~/dcos
ansible-playbook -i inventory.ini --key-file "/home/temp/rsa_key.pem" dcos.yml
