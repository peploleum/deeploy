#!/bin/bash

echo param 1 : Adresse du sous réseau prive \(ex:xxx.xxx.xxx.xxx\)
echo param 2 : Adresse du sous réseau prive sans le dernier digit \(ex:xxx.xxx.xxx\)
echo param 3 : Adresse de début du reseau public
echo param 4 : Adresse de fin du reseau public
echo param 5 : Adresse du serveur dns public
echo param 6 : Adresse de la passerelle public
echo param 7 : Adresse du sous reseau public \(ex:xxx.xxx.xxx.xxx\)
echo param 8 : Digit du masquage du réseau \(ex:xx\)
echo param 9 : Nom de la paire de clés openstack

# Access openstack
. admin-openrc

#Create image Ubuntu and kubernetes
openstack image create --disk-format iso --public --file ubuntu-16.04.5-desktop-amd64.iso Ubuntu-16.04
openstack image create --container-format ova --disk-format vmdk --public --file kubernetes-disk1.vmdk Kubernetes

#Create all gabarits
openstack flavor create --id 0 --vcpus 1 --ram 2048 --disk 1 Small
openstack flavor create --id 1 --vcpus 2 --ram 4096 --disk 20 Medium
openstack flavor create --id 2 --vcpus 4 --ram 16000 --disk 100 Large
openstack flavor create --id 3 --vcpus 8 --ram 32000 --disk 500 Extra large
openstack flavor create --id 4 --vcpus 16 --ram 64000 --disk 5000 Extra extra large
openstack flavor create --id 5 --vcpus 4 --ram 16000 --disk 250 Kubernetes

# Create all networks
neutron router-create router
openstack network create private
openstack subnet create --subnet-range $1/23 --network private --dns-nameserver 8.8.4.4 private-v4
openstack subnet create --subnet-range fe80:$2::/64 --ip-version 6 --ipv6-ra-mode slaac --ipv6-address-mode slaac --network private --dns-nameserver 2001:4860:4860::8844 private-v6
openstack router add subnet router private-v4
openstack router add subnet router private-v6
openstack network create --share --external --provider-physical-network provider --provider-network-type flat public
openstack subnet create --network public --allocation-pool start=$3,end=$4 --dns-nameserver $5 --gateway $6 --subnet-range $7/$8 public
neutron router-gateway-set router public

# Add rules SSH and PING for Group default
openstack security group create openstack
openstack security group rule create --protocol icmp openstack
openstack security group rule create --protocol tcp --dst-port 22:22 openstack
openstack security group rule create --protocol tcp --dst-port 6443:6443 openstack

#Create key
openstack keypair create $9