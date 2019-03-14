#!/bin/bash

echo param 1 : Instance Name -- ex : my_instance
echo param 2 : Floating IP -- ex : 192.168.0.112

. admin-openrc

# Remove instance
openstack server delete $1

# Remove port
openstack port delete port-$1

# Remove Floating IP
openstack floating ip delete $2

