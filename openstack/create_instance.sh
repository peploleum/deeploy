#!/bin/bash

echo param 1 : Nom du flavor \(gabarit\)
echo param 2 : Nom de l\'image
echo param 3 : Network name
echo param 4 : Nom de la paire de cles
echo param 5 : Nom de l\'instance

#Create flavor
openstack server create --flavor $1 --image $2 --network $3 --security-group openstack --key-name $4 $5

#Generate token instance
openstack console url show $5
