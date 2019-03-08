#!/bin/bash

#Execute on openstack-controller

# Access openstack
. admin-openrc

#Add quota
openstack quota set admin --ram 500000
openstack quota set admin --cores 500
openstack quota set admin --instances 1000

# View new node
openstack compute service list --service nova-compute

# Add node in openstack-controller
sudo su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
