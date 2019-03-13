#!/bin/bash

echo param 1 : Flavor name -- ex : Small
echo param 2 : Image name -- ex : Ubuntu-16.04
echo param 3 : Network name -- ex : sandbox
echo param 4 : Private Instance IP -- ex : 10.0.10.113
echo param 5 : Public Floating IP -- ex : 192.168.0.113
echo param 6 : Instance name -- ex : instance04

KEY_NAME=rsa_key

#Create Port
openstack port create --network $3 --fixed-ip subnet=subnet-$3,ip-address=$4 --device-owner compute:nova --security-group openstack port-$6

#Create Instance
openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --port port-$6 $6

#Add floating-ip
openstack floating ip create public --floating-ip-address $5 --port port-$6

#Generate token instance
openstack console url show $6
