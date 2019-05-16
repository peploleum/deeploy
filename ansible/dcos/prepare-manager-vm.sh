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
sed -i -e "s/##BOOTSTRAP_PRIVATE_IP##/$BOOTSTRAP_PRIVATE_IP/g" inventory.ini
sed -i -e "s/##MASTER_PRIVATE_IP##/$MASTER_PRIVATE_IP/g" inventory.ini
sed -i -e "s/##PUBLIC_AGENT_PRIVATE_IP##/$PUBLIC_AGENT_PRIVATE_IP/g" inventory.ini
sed -i -e "s/##PRIVATE_AGENT_PRIVATE_IP##/$PRIVATE_AGENT_PRIVATE_IP/g" inventory.ini

# Copy ``vars config file``
cp -rfp /home/temp/deeploy/ansible/dcos/ansible/dcos.yaml.template group_vars/all/dcos.yaml
# copy ansible.cfg with hash_behaviour set to merge
cp -rfp /home/temp/deeploy/ansible/dcos/ansible/ansible.cfg ansible.cfg

# Update Ansible config file
sed -i -e "s/##BOOTSTRAP_FQDN##/$BOOTSTRAP_FQDN/g" group_vars/all/dcos.yaml
sed -i -e "s/##MASTER_PRIVATE_IP##/$MASTER_PRIVATE_IP/g" group_vars/all/dcos.yaml
sed -i -e "s/##DNS_SEARCH##/$IPA_DOMAIN_NAME/g" group_vars/all/dcos.yaml
sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" group_vars/all/dcos.yaml
sed -i -e "s/##PROXY_IP##/$PROXY_IP/g" group_vars/all/dcos.yaml
sed -i -e "s/##PROXY_PORT##/$PROXY_PORT/g" group_vars/all/dcos.yaml
