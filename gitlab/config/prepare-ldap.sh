#!/bin/bash

set -x
if [ $# -lt 3]; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_FQDN"
  echo
  echo IPA_SERVER_IP must be:
  echo "  • valid IP of running IPA server"
  echo
  echo IPA_SERVER_FQDN must meet the following:
  echo "  • valid Fully Qualified Domain Name of running IPA server"
  echo
  echo GITLAB_CONTAINER_ID must meet the following:
  echo "  • valid running gitlab container id"
  echo
  echo  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver.peploleum.com 12"
  exit 1
fi
#make sure host can resolve freeipa server, if not:
echo '$1 $2' | sudo tee -a /etc/hosts

docker cp configure-ldap.sh $3:/
docker cp  freeipa_settings.yml $3:/etc/gitlab/freeipa_settings.yml

