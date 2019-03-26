#!/bin/bash

if [ $# -lt 6 ] ; then
	echo "Usage: create_instance.sh FLAVOR IMAGE NETWORK IP_PRIVATE IP_PUBLIC INSTANCE_NAME USER_DATA(optional) [EXTRA_SECURITY_GROUP]"
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
  echo EXTRA_SECURITY_GROUP is optional:
  echo "  • list of existing security group"
  echo
  echo "Examples:"
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance" 
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance my_user_data.txt"
  echo "  • $0 S Ubuntu_18.04_server sandbox 12.12.12.118 192.168.0.218 my_instance my_user_data.txt sg_1 sg_2"
  exit 1
fi

. admin-openrc

KEY_NAME=rsa_key

nb_param=$#


#Create Port
echo "Create port-$6"

# Add extra security group
more_sg=""
if [ $nb_param -gt 7 ]; then
	array=( $@ )
	len=${#array[@]}
	extra_group=${array[@]:7:$len}
	echo "Add Extra Security Group : $extra_group"
	for sec_group in ${extra_group[@]}
	do
		more_sg="--security-group $sec_group $more_sg"
	done
fi

openstack port create --network $3 --fixed-ip subnet=subnet-$3,ip-address=$4 --device-owner compute:nova --security-group openstack $more_sg port-$6

#Create Instance
if [ $nb_param = 6 ]; then
	echo "Create instance $6"
	openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --port port-$6 $6
else
	echo "Create instance $6 with user data $7"
	openstack server create --flavor $1 --image $2 --key-name $KEY_NAME --user-data $7 --port port-$6 $6
fi

#Add floating-ip
openstack floating ip create public --floating-ip-address $5 --port port-$6

#Generate token instance
openstack console url show $6
