#!/usr/bin/env bash
set -x
if [ $# -lt 6 ]; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_FQDN IPA_DOMAIN_NAME IPA_REALM IPA_PRINCIPAL IPA_PASSWORD"
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
  echo  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver.peploleum.com peploleum.com PEPLOLEUM.COM admin adminadmin"
  exit 1
fi

#install freeipa-client package for ubuntu 18.04 and set hostname according to proper DNS
sudo apt-get -y update
sudo apt-get -y upgrade
sudo hostnamectl set-hostname $(hostname).$3
sudo apt-get install -y freeipa-client

#add ipa server hostname and IP address to hosts
echo "$1 $2" | sudo tee -a /etc/hosts

#install freeipa client
sudo ipa-client-install --hostname=`hostname -f` --mkhomedir --server=$3 --domain $4 --realm $5 --principal=$6 --password=$6 -U

#enable mkhomedir
echo 'Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
required pam_mkhomedir.so umask=0022 skel=/etc/skel' | sudo tee /usr/share/pam-configs/mkhomedir

sudo pam-auth-update
