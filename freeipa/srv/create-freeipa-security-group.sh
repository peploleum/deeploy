#!/usr/bin/env bash

. ../../openstack/admin-openrc

openstack security group delete freeipa

openstack security group create freeipa
openstack security group rule create --protocol udp --dst-port 53:53 freeipa
openstack security group rule create --protocol udp --dst-port 88:88 freeipa
openstack security group rule create --protocol udp --dst-port 464:464 freeipa
openstack security group rule create --protocol udp --dst-port 123:123 freeipa
openstack security group rule create --protocol tcp --dst-port 53:53 freeipa
openstack security group rule create --protocol tcp --dst-port 180:180 freeipa
openstack security group rule create --protocol tcp --dst-port 443:443 freeipa
openstack security group rule create --protocol tcp --dst-port 389:389 freeipa
openstack security group rule create --protocol tcp --dst-port 636:636 freeipa
openstack security group rule create --protocol tcp --dst-port 88:88 freeipa
openstack security group rule create --protocol tcp --dst-port 464:464 freeipa
openstack security group rule create --protocol tcp --dst-port 7389:7389 freeipa
openstack security group rule create --protocol tcp --dst-port 19443:19443 freeipa
openstack security group rule create --protocol tcp --dst-port 19444:19444 freeipa
openstack security group rule create --protocol tcp --dst-port 19445:19445 freeipa
