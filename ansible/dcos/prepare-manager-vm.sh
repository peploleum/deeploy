#!/bin/bash

# Load variables
. dcos.conf
. ~/ipa.conf

# Install Ansible
$DEEPLOY_PATH/ansible/install-ansible-centos.sh

# Clone dcos-ansible project
git clone $DCOS_ANSIBLE_GITHUB ~/dcos
cd ~/dcos
git checkout $DCOS_ANSIBLE_GITHUB_VERSION

# Copy ``inventory file``
cp -rfp ~/deeploy/ansible/dcos/ansible/inventory.ini inventory.ini

# Update Ansible inventory file
export BOOSTRAP_FQDN=$BOOTSTRAP_NAME.$IPA_DOMAIN_NAME
export AGENT_FQDN=$AGENT_NAME.$IPA_DOMAIN_NAME
export MASTER_FQDN=$MASTER_NAME.$IPA_DOMAIN_NAME
sed -i -e "s/##BOOSTRAP_FQDN##/$BOOSTRAP_FQDN/g" inventory.ini
sed -i -e "s/##AGENT_FQDN##/$AGENT_FQDN/g" inventory.ini
sed -i -e "s/##MASTER_FQDN##/$MASTER_FQDN/g" inventory.ini

