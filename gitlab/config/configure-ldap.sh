#!/bin/bash
set -x
if [ $# -lt 2 ]; then
  echo "Usage: $0 IPA_SERVER_IP IPA_SERVER_FQDN" 
  echo
  echo IPA_SERVER_IP must be:
  echo "  • valid IP of running IPA server"
  echo
  echo IPA_SERVER_FQDN must meet the following:
  echo "  • valid Fully Qualified Domain Name of running IPA server"
  echo
  echo  echo "Examples:"
  echo "  • $0 10.0.0.1 ipaserver.peploleum.com"
  exit 1
fi
#sudo is useless in gitlab-ce container
echo '$1 $2' | tee -a /etc/host
echo "enabling ldap ... updating gitlab.rb"
echo "gitlab_rails['ldap_enabled'] = true" | tee -a /etc/gitlab/gitlab.rb
echo "gitlab_rails['ldap_servers'] = YAML.load_file('/etc/gitlab/freeipa_settings.yml')" | tee -a /etc/gitlab/gitlab.rb
echo "restarting gitlab service"
gitlab-ctl reconfigure
