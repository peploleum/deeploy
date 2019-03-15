#!/bin/bash

../install_ansible.sh

git clone https://github.com/kubernetes-sigs/kubespray.git ~/kubespray
cd ~/kubespray
git checkout v2.8.3

# Install dependencies from ``requirements.txt``
sudo pip install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(12.12.12.20 12.12.12.21 12.12.12.22)
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sed -i -e "s/node1/k8s-master/g" inventory/mycluster/hosts.ini
sed -i -e "s/node2/k8s-node1/g" inventory/mycluster/hosts.ini
sed -i -e "s/node3/k8s-node2/g" inventory/mycluster/hosts.ini
