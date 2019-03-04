#!/bin/bash
#sudo is useless in gitlab-ce container
echo '10.65.34.95 ipaserver.peploleum.com' | tee -a /etc/host
echo "enabling ldap ... updating gitlab.rb"
echo "gitlab_rails['ldap_enabled'] = true" | tee -a /etc/gitlab/gitlab.rb
echo "gitlab_rails['ldap_servers'] = YAML.load_file('/etc/gitlab/freeipa_settings.yml')" | tee -a /etc/gitlab/gitlab.rb
echo "restarting gitlab service"
gitlab-ctl reconfigure
