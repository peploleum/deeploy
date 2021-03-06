#!/bin/bash

# This script init Public network, Flavor and Image
echo param 1 : Public network CIDR -- ex: 192.168.0.0/16
echo param 2 : Public network start pool -- ex: 192.168.0.101
echo param 3 : Public network end pool -- ex: 192.168.0.250
echo param 4 : Public network gateway -- ex: 192.168.0.1
echo param 5 : Public network DNS -- ex: 66.28.0.45

NETWORK_NAME=public
KEY_NAME=rsa_key

# Access openstack
. admin-openrc

#Clean before deployment conf openstack
openstack image delete Ubuntu_16.04_desktop
openstack image delete Ubuntu_18.04_desktop
openstack image delete Ubuntu_16.04_server
openstack image delete Ubuntu_18.04_server

openstack flavor delete S
openstack flavor delete M
openstack flavor delete L
openstack flavor delete XL
openstack flavor delete XXL
openstack flavor delete XXXL

openstack router unset --external-gateway router1
openstack router remove subnet router1 $(openstack subnet list -c ID -f value)
openstack router delete router1

openstack network delete $(openstack network list -c ID -f value)

openstack security group delete openstack

openstack keypair delete $KEY_NAME

#Create image Ubuntu 
openstack image create --disk-format vmdk --public --file images/ubuntu_16.04_desktop.vmdk Ubuntu_16.04_desktop
openstack image create --disk-format vmdk --public --file images/ubuntu_18.04_desktop.vmdk Ubuntu_18.04_desktop
openstack image create --disk-format qcow2 --public --file images/ubuntu-16.04-server.img Ubuntu_16.04_server
openstack image create --disk-format qcow2 --public --file images/ubuntu-18.04-server.img Ubuntu_18.04_server

#Create all gabarits
openstack flavor create --id 0 --vcpus 1 --ram 2048 --disk 1 S
openstack flavor create --id 1 --vcpus 2 --ram 4096 --disk 20 M
openstack flavor create --id 2 --vcpus 4 --ram 16000 --disk 100 L
openstack flavor create --id 3 --vcpus 8 --ram 16000 --disk 250 XL
openstack flavor create --id 4 --vcpus 8 --ram 32000 --disk 250 XXL
openstack flavor create --id 5 --vcpus 16 --ram 64000 --disk 250 XXXL

# Create public network
openstack router create router1
openstack network create $NETWORK_NAME --share --external --provider-network-type flat --provider-physical-network provider
openstack subnet create --network $NETWORK_NAME --allocation-pool start=$2,end=$3 --dns-nameserver $5 --gateway $4 --subnet-range $1 subnet-$NETWORK_NAME
openstack router set --external-gateway $NETWORK_NAME router1

# Add rules SSH and PING for Group default
openstack security group create openstack
openstack security group rule create --protocol icmp openstack
openstack security group rule create --protocol tcp --dst-port 22:22 openstack
openstack security group rule create --protocol tcp --dst-port 6443:6443 openstack

#Create key
openstack keypair create $KEY_NAME --private-key ~/$KEY_NAME.pem
