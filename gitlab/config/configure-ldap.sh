#!/bin/bash

echo "enabling ldap ... updating gitlab.rb"
echo "gitlab_rails['ldap_enabled'] = true" | sudo tee -a /etc/gitlab/gitlab.rb
echo "gitlab_rails['ldap_servers'] = YAML.load_file('/etc/gitlab/freeipa_settings.yml')" | sudo tee -a /etc/gitlab/gitlab.rb
echo "restarting gitlab service"
sudo gitlab-ctl reconfigure
