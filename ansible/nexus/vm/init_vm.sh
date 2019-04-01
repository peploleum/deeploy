#!/bin/bash

# This script init 1 or 2 VM to deploy Nexus. Please check nexus.conf file before running this script.

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
	openstack security group rule create nexus --protocol tcp --dst-port 8081
	openstack security group rule create nexus --protocol tcp --dst-port 9080
	openstack security group rule create nexus --protocol tcp --dst-port 9081
	openstack security group rule create nexus --protocol tcp --dst-port 9082
fi

# Create Instances
$DEEPLOY_PATH/openstack/create_instance.sh $ANSIBLE_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $ANSIBLE_PRIVATE_IP $ANSIBLE_PUBLIC_IP $ANSIBLE_NAME $DEEPLOY_PATH/ansible/nexus/vm/cloud-config-manager.yml

if $USE_NEXUS_VM
then
  $DEEPLOY_PATH/openstack/create_instance.sh $MASTER_FLAVOR  $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $MASTER_PRIVATE_IP $MASTER_PUBLIC_IP $MASTER_NAME
  openstack server add security group $MASTER_NAME nexus
fi
