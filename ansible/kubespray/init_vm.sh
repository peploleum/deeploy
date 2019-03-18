#!/bin/bash

cd ~/deeploy/openstack
. admin-openrc

# Remove Instances
./remove_instance.sh k8s-ansible 192.168.0.211
./remove_instance.sh k8s-master 192.168.0.220
./remove_instance.sh k8s-node1 192.168.0.221
./remove_instance.sh k8s-node2 192.168.0.222

# Remove Kubernetes Security Group
openstack security group delete kubernetes

# Create Security Group
openstack security group create kubernetes
openstack security group rule create kubernetes --protocol udp --dst-port 1:65535
openstack security group rule create kubernetes --protocol tcp --dst-port 1:65535

# Create Instances
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.11 192.168.0.211 k8s-ansible ~/deeploy/ansible/kubespray/cloud-config-manager.yml
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.20 192.168.0.220 k8s-master ~/deeploy/ansible/kubespray/cloud-config-k8s.yml
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.21 192.168.0.221 k8s-node1 ~/deeploy/ansible/kubespray/cloud-config-k8s.yml
./create_instance.sh M Ubuntu_18.04_server sandbox 12.12.12.22 192.168.0.222 k8s-node2 ~/deeploy/ansible/kubespray/cloud-config-k8s.yml

# Set security group
openstack server add security group k8s-ansible kubernetes
openstack server add security group k8s-master kubernetes
openstack server add security group k8s-node1 kubernetes
openstack server add security group k8s-node2 kubernetes

openstack server remove security group k8s-ansible openstack
openstack server remove security group k8s-master openstack
openstack server remove security group k8s-node1 openstack
openstack server remove security group k8s-node2 openstack

