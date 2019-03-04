#!/bin/bash

#make sure host can resolve freeipa server, if not:
echo '10.65.34.95 ipaserver.peploleum.com' | sudo tee -a /etc/hosts

docker cp configure-ldap.sh $1:/
docker cp  freeipa_settings.yml $1:/etc/gitlab/freeipa_settings.yml

