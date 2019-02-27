#!/usr/bin/env bash

#install freeipa-client package for ubuntu 18.04 and set hostname according to proper DNS
sudo apt-get update
sudo apt-get upgrade
sudo hostnamectl set-hostname node-01.peploleum.com
sudo apt-get install -y freeipa-client

#add ipa server hostname and IP address to hosts
echo "10.65.34.192 ipaserver.peploleum.com" | sudo tee -a /etc/hosts

#install freeipa client
sudo ipa-client-install --hostname=`hostname -f` --mkhomedir --server=ipaserver.peploleum.com --domain peploleum.com --realm PEPLOLEUM.COM

#enable mkhomedir
echo 'Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
required pam_mkhomedir.so umask=0022 skel=/etc/skel' | sudo tee /usr/share/pam-configs/mkhomedir

sudo pam-auth-update