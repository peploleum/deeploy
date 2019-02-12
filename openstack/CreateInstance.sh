#!/bin/bash

echo param 1 : Nom du flavor
echo param 2 : Nom de l\'image
echo param 3 : ID du network
echo param 4 : Nom de la paire de cles
echo param 5 : Nom de l\'instance

#Create flavor
openstack server create --flavor $1 --image $2 --nic net-id=$3 --security-group default --key-name $4 $5

#Generate token instance
openstack console url show $5