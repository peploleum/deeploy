#!/bin/bash

# This script create a router named router1, public network and subnet based on subnet pool
echo param 1 : Pool prefix -- ex : 192.168.0.0/16
echo param 2 : Default prefix length -- ex : 18

cd ..
. admin-openrc
cd network

# Cleanup
openstack router unset --external-gateway router1
openstack network delete public
openstack network delete private
openstack subnet pool delete subnet-pool-ip4
openstack address scope delete address-scope-ip4
openstack router remove subnet router1 $(openstack subnet list -c ID -f value)
openstack router delete router1

openstack router create router1
openstack network create public --share --external --provider-network-type flat --provider-physical-network provider 
openstack address scope create --share --ip-version 4 address-scope-ip4
openstack subnet pool create --address-scope address-scope-ip4 --share --pool-prefix $1 --default-prefix-length $2 subnet-pool-ip4
openstack subnet create --network public --subnet-pool subnet-pool-ip4 subnet-public
openstack router set --external-gateway public router1
openstack network create private
