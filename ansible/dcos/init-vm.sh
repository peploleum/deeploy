#!/bin/bash

# This script init 4 VM to deploy DCOS. Please check dcos.conf file before runnig this script.
# requires openstack CLI client

# Load variables
. dcos.conf
. $DEEPLOY_PATH/openstack/admin-openrc

# Remove Instances
$DEEPLOY_PATH/openstack/remove-instance.sh $ANSIBLE_NAME $ANSIBLE_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $BOOTSTRAP_NAME $BOOTSTRAP_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $MASTER_NAME $MASTER_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $PRIVATE_AGENT_NAME $PRIVATE_AGENT_PUBLIC_IP
$DEEPLOY_PATH/openstack/remove-instance.sh $PUBLIC_AGENT_NAME $PUBLIC_AGENT_PUBLIC_IP

# Remove DCOS Security Group
openstack security group delete dcos

# Create Security Group
if openstack security group list | grep dcos
then
        echo "Openstack DCOS security group already exist."
else
	openstack security group create dcos
	openstack security group rule create dcos --protocol udp --dst-port 1:65535
	openstack security group rule create dcos --protocol tcp --dst-port 1:65535
	openstack security group rule create dcos --protocol icmp
fi

# Update conf file
sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
sed -i -e "s/##IPA_SERVER_FQDN##/$IPA_SERVER_FQDN/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
sed -i -e "s/##IPA_DOMAIN_NAME##/$IPA_DOMAIN_NAME/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
sed -i -e "s/##IPA_REALM##/$IPA_REALM/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
sed -i -e "s/##IPA_PRINCIPAL##/$IPA_PRINCIPAL/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
sed -i -e "s/##IPA_PASSWORD##/$IPA_PASSWORD/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml

sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
sed -i -e "s/##IPA_SERVER_FQDN##/$IPA_SERVER_FQDN/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
sed -i -e "s/##IPA_DOMAIN_NAME##/$IPA_DOMAIN_NAME/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
sed -i -e "s/##IPA_REALM##/$IPA_REALM/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
sed -i -e "s/##IPA_PRINCIPAL##/$IPA_PRINCIPAL/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
sed -i -e "s/##IPA_PASSWORD##/$IPA_PASSWORD/g" $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml

# Create Instances
$DEEPLOY_PATH/openstack/create-instance.sh $ANSIBLE_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $ANSIBLE_PRIVATE_IP $ANSIBLE_PUBLIC_IP $ANSIBLE_NAME $DEEPLOY_PATH/ansible/dcos/cloud-config-manager-new.yml
openstack server add security group $ANSIBLE_NAME dcos
$DEEPLOY_PATH/openstack/create-instance.sh $MASTER_FLAVOR  $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME  $MASTER_PRIVATE_IP $MASTER_PUBLIC_IP $MASTER_NAME $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
openstack server add security group $MASTER_NAME dcos
$DEEPLOY_PATH/openstack/create-instance.sh $BOOTSTRAP_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME $BOOTSTRAP_PRIVATE_IP $BOOTSTRAP_PUBLIC_IP $BOOTSTRAP_NAME $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
openstack server add security group $BOOTSTRAP_NAME dcos
$DEEPLOY_PATH/openstack/create-instance.sh $PRIVATE_AGENT_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME $PRIVATE_AGENT_PRIVATE_IP $PRIVATE_AGENT_PUBLIC_IP $PRIVATE_AGENT_NAME $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
openstack server add security group $PRIVATE_AGENT_NAME dcos
$DEEPLOY_PATH/openstack/create-instance.sh $PUBLIC_AGENT_FLAVOR $OPENSTACK_IMAGE $PRIVATE_NETWORK_NAME $PUBLIC_AGENT_PRIVATE_IP $PUBLIC_AGENT_PUBLIC_IP $PUBLIC_AGENT_NAME $DEEPLOY_PATH/ansible/dcos/cloud-config-dcos-new.yml
openstack server add security group $PUBLIC_AGENT_NAME dcos

# Set security group
openstack server remove security group $ANSIBLE_NAME openstack
openstack server remove security group $MASTER_NAME openstack
openstack server remove security group $BOOTSTRAP_NAME openstack
openstack server remove security group $PRIVATE_AGENT_NAME openstack
openstack server remove security group $PUBLIC_AGENT_NAME openstack

