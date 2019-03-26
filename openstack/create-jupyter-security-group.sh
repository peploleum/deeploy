#!/usr/bin/env bash

. admin-openrc

openstack security group delete jupyter

openstack security group create jupyter
openstack security group rule create --protocol tcp --dst-port 8888:8888 jupyter
