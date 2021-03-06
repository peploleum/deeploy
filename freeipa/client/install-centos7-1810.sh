#!/usr/bin/env bash
set -x
if [ $# -lt 6 ]; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_FQDN IPA_DOMAIN_NAME IPA_REALM IPA_PRINCIPAL IPA_PASSWORD [ARGS]"
  echo
  echo IPA_SERVER_IP must be:
  echo "  • valid IP of running IPA server"
  echo
  echo IPA_SERVER_FQDN must meet the following:
  echo "  • valid Fully Qualified Domain Name of running IPA server"
  echo
  echo IPA_DOMAIN_NAME must meet the following:
  echo "  • domain name"
  echo
  echo IPA_REALM must meet the following:
  echo "  • domain realm"
  echo
  echo IPA_PRINCIPAL must meet the following:
  echo "  • admin user"
  echo
  echo IPA_PASSWORD must meet the following:
  echo "  • admin password"
  echo
  echo [ARGS] must meet the following:
  echo "  • args that will be appended to the command line"
  echo
  echo  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver.peploleum.com peploleum.com PEPLOLEUM.COM admin adminadmin"
  exit 1
fi
echo "ARGS are ${@:7}"
#install freeipa-client package for ubuntu 18.04 and set hostname according to proper DNS
sudo yum -y update
sudo hostnamectl set-hostname $(hostname -s)
sudo yum install -y freeipa-client

#add ipa server hostname and IP address to hosts
echo "$1 $2" | sudo tee -a /etc/hosts
echo "127.0.1.1 $(hostname -s).$3 $(hostname -s)" | sudo tee -a /etc/hosts


#install freeipa client
sudo ipa-client-install --hostname=`hostname -f` --mkhomedir --server=$2 --domain=$3 --realm=$4 --principal=$5 --password=$6 -U "${@:7}"

