#!/bin/bash

# This script init 4 VM to deploy Kubernetes. Please check kubespray.conf file before runnig this script.

# Load variables
. kubespray.conf
. $DEEPLOY_PATH/openstack/admin-openrc

# Remove Instances
$DEEPLOY_PATH/openstack/remove-instance.sh $ANSIBLE_NAME $ANSIBLE_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $MASTER_NAME $MASTER_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $NODE1_NAME $NODE1_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $NODE2_NAME $NODE2_PUBLIC_IP

# Remove Kubernetes Security Group
openstack security group delete kubernetes

# Create Security Group
if openstack security group list | grep kubernetes
then
        echo "Openstack Kubernetes security group already exist."
else
	openstack security group create kubernetes
	openstack security group rule create kubernetes --protocol udp --dst-port 1:65535
	openstack security group rule create kubernetes --protocol tcp --dst-port 1:65535
	openstack security group rule create kubernetes --protocol icmp
fi

# Update conf file
sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
sed -i -e "s/##IPA_SERVER_FQDN##/$IPA_SERVER_FQDN/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
sed -i -e "s/##IPA_DOMAIN_NAME##/$IPA_DOMAIN_NAME/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
sed -i -e "s/##IPA_REALM##/$IPA_REALM/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
sed -i -e "s/##IPA_PRINCIPAL##/$IPA_PRINCIPAL/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
sed -i -e "s/##IPA_PASSWORD##/$IPA_PASSWORD/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml

sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
sed -i -e "s/##IPA_SERVER_FQDN##/$IPA_SERVER_FQDN/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
sed -i -e "s/##IPA_DOMAIN_NAME##/$IPA_DOMAIN_NAME/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
sed -i -e "s/##IPA_REALM##/$IPA_REALM/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
sed -i -e "s/##IPA_PRINCIPAL##/$IPA_PRINCIPAL/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
sed -i -e "s/##IPA_PASSWORD##/$IPA_PASSWORD/g" $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml

# Create Instances
$DEEPLOY_PATH/openstack/create_instance.sh $ANSIBLE_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $ANSIBLE_PRIVATE_IP $ANSIBLE_PUBLIC_IP $ANSIBLE_NAME $DEEPLOY_PATH/ansible/kubespray/cloud-config-manager.yml
openstack server add security group $ANSIBLE_NAME kubernetes
$DEEPLOY_PATH/openstack/create_instance.sh $MASTER_FLAVOR  $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $MASTER_PRIVATE_IP $MASTER_PUBLIC_IP $MASTER_NAME $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
openstack server add security group $MASTER_NAME kubernetes
$DEEPLOY_PATH/openstack/create_instance.sh $NODE1_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME $NODE1_PRIVATE_IP $NODE1_PUBLIC_IP $NODE1_NAME $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
openstack server add security group $NODE1_NAME kubernetes
$DEEPLOY_PATH/openstack/create_instance.sh $NODE2_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME $NODE2_PRIVATE_IP $NODE2_PUBLIC_IP $NODE2_NAME $DEEPLOY_PATH/ansible/kubespray/cloud-config-k8s.yml
openstack server add security group $NODE2_NAME kubernetes

# Set security group
openstack server remove security group $ANSIBLE_NAME openstack
openstack server remove security group $MASTER_NAME openstack
openstack server remove security group $NODE1_NAME openstack
openstack server remove security group $NODE2_NAME openstack

