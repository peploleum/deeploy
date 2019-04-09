#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 MAIL_DOMAIN_NAME"
  echo
  echo MAIL_DOMAIN_NAME must be:
  echo "  • valid name domain of running mail server"
  echo
  echo  echo "Examples:"
  echo "  • $0 openstacklocal"
  exit 1
fi

sudo sed -i "s/127.0.0.1 localhost/127.0.0.1 $(hostname -f).$1 localhost/g" /etc/hosts
cd /home/ubuntu/deeploy/webmail
tar xjf iRedMail-0.9.9.tar.bz2
cp config /iRedMail-0.9.9/
cd /home/ubuntu/deeploy/webmail/iRedMail-0.9.9/
sudo chmod +x iRedMail.sh
sudo ./iRedMail.sh
#cd ..
#sudo rm -r iRedMail-0.9.9
