#!/bin/bash

cd /home/ubuntu/deeploy/webmail
tar xjf iRedMail-0.9.9.tar.bz2
cd /home/ubuntu/deeploy/webmail/iRedMail-0.9.9/
sudo chmod +x iRedMail.sh
sudo ./iRedMail.sh
sudo rm -r iRedMail-0.9.9
