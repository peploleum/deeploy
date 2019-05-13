#!/bin/bash

# Load variables
. /home/temp/deeploy/ansible/dcos/dcos.conf
. /home/temp/deeploy/openstack/admin-openrc

cd ~/dcos
ansible-playbook -e 'dcos_cluster_name_confirmed=True' -i inventory.ini --key-file "/home/temp/rsa_key.pem" dcos.yml -vvv
