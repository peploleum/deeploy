#!/bin/bash

# Load variables
. kubespray.conf
. ~/ipa.conf

# Install Ansible
$DEEPLOY_PATH/ansible/install-ansible.sh

# Clone Kubespray project
git clone $GITHUB_KUBESPRAY ~/kubespray
cd ~/kubespray
git checkout v2.8.3

# Install dependencies from ``requirements.txt``
sudo pip install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=($MASTER_PRIVATE_IP $NODE1_PRIVATE_IP $NODE2_PRIVATE_IP)
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Replace nodes name
#sed -i -e "s/node1/$MASTER_NAME.$IPA_DOMAIN_NAME/g" inventory/mycluster/hosts.ini
#sed -i -e "s/node2/$NODE1_NAME.$IPA_DOMAIN_NAME/g" inventory/mycluster/hosts.ini
#sed -i -e "s/node3/$NODE2_NAME.$IPA_DOMAIN_NAME/g" inventory/mycluster/hosts.ini
sed -i -e "s/node1/$MASTER_NAME/g" inventory/mycluster/hosts.ini
sed -i -e "s/node2/$NODE1_NAME/g" inventory/mycluster/hosts.ini
sed -i -e "s/node3/$NODE2_NAME/g" inventory/mycluster/hosts.ini
sed -i -e "8,8d" inventory/mycluster/hosts.ini

# Set cilium as network plugin
sed -i -e "s/kube_network_plugin:.*/kube_network_plugin: cilium/g" inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

# Add openstack as cloud provider
sed -i -e "s/#cloud_provider.*/cloud_provider: openstack/g" inventory/mycluster/group_vars/all/all.yml

