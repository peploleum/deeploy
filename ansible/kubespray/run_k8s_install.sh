#!/bin/bash

ansible-playbook -i inventory/mycluster/hosts.ini --key-file "~/.ssh/rsa_key.pem" --become --become-user=root cluster.yml
