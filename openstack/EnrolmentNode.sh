#!/bin/bash

#Execute on openstack-controller

# Access openstack
. admin-openrc

# View new node
openstack compute service list --service nova-compute

# Add node in openstack-controller
sudo su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova