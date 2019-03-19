#!/bin/bash

if [ $# -lt 6 ] || [ $# -gt 8 ] ; then
  echo "Usage: create_instance.sh FLAVOR IMAGE NETWORK IP_PRIVATE IP_PUBLIC INSTANCE_NAME USER_DATA[optional] EXTRA_ARGS[optional]"
  echo
  echo FLAVOR must meet the following:
  echo "  • be defined in openstack" 
  echo
  echo IMAGE must meet the following:
  echo "  • be defined in openstack"
  echo
  echo NETWORK must meet the following:
  echo "  • be defined in openstack"
  echo
  echo IP_PRIVATE must meet the following:
  echo "  • valid IPv4"
  echo "  • IP include in the NETWORK IP Range"
  echo
  echo IP_PUBLIC must meet the following:
  echo "  • valid IPv4"
  echo "  • IP include in the public openstack network IP Range"
  echo
  echo INSTANCE_NAME must meet the following:
  echo "  • valid hostname"
  echo
  echo USER_DATA is optional:
  echo "  • valid user data file"
  echo
  echo EXTRA_ARGS is optional:
  echo "  • string to add extra argument to the openstack server create function"
  echo
  echo "Examples:"
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance" 
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance my_user_data.txt"
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance my_user_data.txt \"--file test.txt=test.txt\""
  exit 1
fi

. admin-openrc

KEY_NAME=rsa_key

#Create Port
openstack port create --network $3 --fixed-ip subnet=subnet-$3,ip-address=$4 --device-owner compute:nova --security-group openstack port-$6

#Create Instance
nb_param=$#
case $nb_param in
  6)
    openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --port port-$6 $6
    ;;
  7)
    openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --user-data $7 --port port-$6 $6
    ;;
  8)
    openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --user-data $7 --port port-$6 $8 $6
    ;;
  *)
    echo "Bad param"
    exit 1
    ;;
esac

#Add floating-ip
openstack floating ip create public --floating-ip-address $5 --port port-$6

#Generate token instance
openstack console url show $6
