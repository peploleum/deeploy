#!/bin/bash

# This script init 4 VM to deploy Kubernetes. Please check kubespray.conf file before runnig this script.

# Load variables
. nexus.conf 
. $DEEPLOY_PATH/openstack/admin-openrc

# Remove Instances
$DEEPLOY_PATH/openstack/remove_instance.sh $ANSIBLE_NAME $ANSIBLE_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove_instance.sh $MASTER_NAME $MASTER_PUBLIC_IP

# Remove Kubernetes Security Group
openstack security group delete nexus

# Create Security Group
if openstack security group list | grep nexus
then
        echo "Openstack nexus security group already exist."
else
	openstack security group create nexus
#	openstack security group rule create kubernetes --protocol udp --dst-port 1:65535
#	openstack security group rule create kubernetes --protocol tcp --dst-port 1:65535
#	openstack security group rule create kubernetes --protocol icmp
fi

# Create Instances
$DEEPLOY_PATH/openstack/create_instance.sh $ANSIBLE_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $ANSIBLE_PRIVATE_IP $ANSIBLE_PUBLIC_IP $ANSIBLE_NAME
#openstack server add security group $ANSIBLE_NAME nexus
$DEEPLOY_PATH/openstack/create_instance.sh $MASTER_FLAVOR  $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $MASTER_PRIVATE_IP $MASTER_PUBLIC_IP $MASTER_NAME
#openstack server add security group $ANSIBLE_NAME nexus

