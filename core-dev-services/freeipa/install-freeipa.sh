#!/bin/bash

set -x
if [ $# -lt 6 ]; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_NAME IPA_DOMAIN_NAME IPA_PASSWORD"
  echo
  echo IPA_SERVER_IP must be:
  echo "  • valid IP of IPA server"
  echo
  echo IPA_SERVER_NAME must meet the following:
  echo "  • valid Name of IPA server"
  echo
  echo IPA_DOMAIN_NAME must meet the following:
  echo "  • domain name"
  echo
  echo IPA_PASSWORD must meet the following:
  echo "  • admin password"
  echo
  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver peploleum.com adminadmin"
  exit 1
fi

realmName=$(echo $3 | tr [a-z] [A-Z])

sudo apt-get -y update
sudo apt-get -y upgrade

sudo hostnamectl set-hostname $2.$3
echo "$1 $2.$3 $2" | sudo tee -a /etc/hosts

sudo apt-get install -y freeipa-server freeipa-server-dns freeipa-server-trust-ad

sudo ipa-server-install -a $4 -p $4 --domain=$3 --realm=$realmName --setup-dns --no-forwarders -U


