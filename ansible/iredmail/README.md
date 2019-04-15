# IRedMail

Deploy iRedMail using Ansible

In its current state, iRedMail is deployed using Postgres as the backend. 

## Prepare the host

On a clean ubuntu server 18.04 :

* Enroll your machine in FreeIPA

## Prepare the manager

On a clean ubuntu server 18.04 run the script:

    ./deeploy/ansible/install_ansible.sh

Then

* Create a RSA key `ssh-keygen -t rsa`
* Copy your key on the host `ssh-copy-id <remote_user>@<remote_host>`
* Save `config.yml.sample` as `config.yml`
* Modify `config.yml`
* Update `hosts` with the IP address of the instance you are deploying to
* `ansible-playbook deploy.yml -i hosts --ask-become-pass`
* Reboot the host

## Links

* Webmail : https://iredmailserver.domain.com/mail
* Admin : https://iredmailserver.domain.com/iredadmin
* SOGo : https://iredmailserver.domain.com/SOGo

