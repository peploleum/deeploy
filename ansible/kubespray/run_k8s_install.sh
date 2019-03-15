#!/bin/bash

cd ../../openstack
. admin-openrc

cd ~/kubespray
ansible-playbook -i inventory/mycluster/hosts.ini --key-file "~/rsa_key.pem" --become --become-user=root cluster.yml
