#!/bin/bash

# This script create a subnet in private network 
echo param 1 : Subnet name -- ex : sandbox
echo param 2 : Subnet IP range -- ex : 10.0.10.0/24
echo param 3 : Start -- ex : 10.0.10.10
echo param 4 : End -- ex : 10.0.10.250

cd ..
. admin-openrc
cd network

openstack subnet create $1 --subnet-range $2 --network private --allocation-pool start=$3,end=$4
openstack router add subnet router1 $1 
