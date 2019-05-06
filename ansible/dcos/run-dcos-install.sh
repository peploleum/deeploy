#!/bin/bash

# Load variables
. /home/temp/deeploy/dcos/dcos.conf
. $DEEPLOY_PATH/openstack/admin-openrc

cd ~/dcos
ansible-playbook -i inventory.ini --key-file "~/rsa_key.pem" dcos.yml