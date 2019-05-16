#!/bin/bash

# Need EPEL repository (already param by cloud-init)
# sudo yum install epel-release -y
sudo yum install ansible -y
sudo yum install python-netaddr python-pip -y
