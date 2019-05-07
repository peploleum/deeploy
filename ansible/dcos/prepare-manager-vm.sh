#!/bin/bash

# Load variables
cd /home/temp/deeploy/ansible/dcos/
. dcos.conf
. /home/temp/ipa.conf

# Install Ansible
/home/temp/deeploy/ansible/install-ansible-centos.sh

# Clone dcos-ansible project
git clone $DCOS_ANSIBLE_GITHUB ~/dcos
cd ~/dcos
git checkout $DCOS_ANSIBLE_GITHUB_VERSION

# Copy ``inventory file``
cp -rfp /home/temp/deeploy/ansible/dcos/ansible/inventory.ini inventory.ini

# Update Ansible inventory file
export BOOTSTRAP_FQDN=$BOOTSTRAP_NAME.$IPA_DOMAIN_NAME
export PRIVATE_AGENT_FQDN=$PRIVATE_AGENT_NAME.$IPA_DOMAIN_NAME
export PUBLIC_AGENT_FQDN=$PUBLIC_AGENT_NAME.$IPA_DOMAIN_NAME
export MASTER_FQDN=$MASTER_NAME.$IPA_DOMAIN_NAME
sed -i -e "s/##BOOTSTRAP_FQDN##/$BOOTSTRAP_FQDN/g" inventory.ini
sed -i -e "s/##PRIVATE_AGENT_FQDN##/$PRIVATE_AGENT_FQDN/g" inventory.ini
sed -i -e "s/##PUBLIC_AGENT_FQDN##/$PUBLIC_AGENT_FQDN/g" inventory.ini
sed -i -e "s/##MASTER_FQDN##/$MASTER_FQDN/g" inventory.ini
sed -i -e "s/##BOOTSTRAP_PUBLIC_IP##/$BOOTSTRAP_PUBLIC_IP/g" inventory.ini
sed -i -e "s/##MASTER_PUBLIC_IP##/$MASTER_PUBLIC_IP/g" inventory.ini
sed -i -e "s/##PUBLIC_AGENT_PUBLIC_IP##/$PUBLIC_AGENT_PUBLIC_IP/g" inventory.ini
sed -i -e "s/##PRIVATE_AGENT_PUBLIC_IP##/$PRIVATE_AGENT_PUBLIC_IP/g" inventory.ini

# Copy ``vars config file``
cp -rfp /home/temp/deeploy/ansible/dcos/ansible/dcos.yaml.template group_vars/all/dcos.yaml

# Update Ansible config file
sed -i -e "s/##BOOTSTRAP_FQDN##/$BOOTSTRAP_FQDN/g" group_vars/all/dcos.yaml
sed -i -e "s/##MASTER_PUBLIC_IP##/$MASTER_PUBLIC_IP/g" group_vars/all/dcos.yaml
