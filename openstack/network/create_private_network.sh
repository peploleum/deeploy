#!/bin/bash

# This script create a private network 
echo param 1 : Network name -- ex : sandbox
echo param 2 : IP range -- ex : 10.0.10.0/24
echo param 3 : Start -- ex : 10.0.10.10
echo param 4 : End -- ex : 10.0.10.250

cd ..
. admin-openrc
cd network

# Cleanup
openstack router remove subnet router1 subnet-$1
openstack network delete $1

openstack network create $1
openstack subnet create subnet-$1 --subnet-range $2 --network $1 --allocation-pool start=$3,end=$4 --dns-nameserver 66.28.0.45 --dns-nameserver 8.8.8.8
openstack router add subnet router1 subnet-$1 
