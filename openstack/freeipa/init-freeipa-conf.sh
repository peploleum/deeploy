#!/bin/bash

if [ $# -lt 6 ] || [ $# -gt 6 ] ; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_FQDN IPA_DOMAIN_NAME IPA_REALM IPA_PRINCIPAL IPA_PASSWORD"
  echo
  echo IPA_SERVER_IP must meet the following:
  echo "  • valid IP v4"
  echo
  echo IPA_SERVER_FQDN must meet the following:
  echo "  • valid FQDN"
  echo
  echo IPA_DOMAIN_NAME must meet the following:
  echo "  • valid domain name"
  echo
  echo IPA_REALM must meet the following:
  echo "  • valid REALM"
  echo
  echo IPA_PRINCIPAL must meet the following:
  echo "  • valid principal user name"
  echo
  echo IPA_PASSWORD must meet the following:
  echo "  • valid principal password"
  echo
  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver.peploleum.com peploleum.com PEPLOLEUM.COM admin adminadmin" 
  exit 1
fi

export IPA_SERVER_IP=$1
export IPA_SERVER_FQDN=$2
export IPA_DOMAIN_NAME=$3
export IPA_REALM=$4
export IPA_PRINCIPAL=$5
export IPA_PASSWORD=$6

rm temp-cloud-init-freeipa.yml
cp cloud-init-freeipa.yml temp-cloud-init-freeipa.yml

sed -i -e "s/##IPA_SERVER_IP##/$IPA_SERVER_IP/g" temp-cloud-init-freeipa.yml
sed -i -e "s/##IPA_SERVER_FQDN##/$IPA_SERVER_FQDN/g" temp-cloud-init-freeipa.yml
sed -i -e "s/##IPA_DOMAIN_NAME##/$IPA_DOMAIN_NAME/g" temp-cloud-init-freeipa.yml
sed -i -e "s/##IPA_REALM##/$IPA_REALM/g" temp-cloud-init-freeipa.yml
sed -i -e "s/##IPA_PRINCIPAL##/$IPA_PRINCIPAL/g" temp-cloud-init-freeipa.yml
sed -i -e "s/##IPA_PASSWORD##/$IPA_PASSWORD/g" temp-cloud-init-freeipa.yml

