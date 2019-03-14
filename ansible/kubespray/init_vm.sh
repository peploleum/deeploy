#!/bin/bash

cd ~/deeploy/openstack
. admin-openrc

./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.11 192.168.0.211 k8s-ansible
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.20 192.168.0.220 k8s-master
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.21 192.168.0.221 k8s-node1
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.22 192.168.0.222 k8s-node2
