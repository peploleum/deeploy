#!/usr/bin/env bash

. admin-openrc

openstack security group delete mesos

openstack security group create mesos
openstack security group rule create --protocol tcp --dst-port 5050:5050 mesos
openstack security group rule create --protocol tcp --dst-port 5051:5051 mesos
openstack security group rule create --protocol tcp --dst-port 2181:2181 mesos
