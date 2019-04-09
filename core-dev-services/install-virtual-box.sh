#!/bin/bash

sudo apt-add-repository main
sudo apt-add-repository universe
sudo apt update
sudo apt upgrade -y

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-add-repository 'deb http://download.virtualbox.org/virtualbox/debian bionic contrib'
sudo apt update

sudo apt install virtualbox-5.2
sudo usermod -aG vboxusers $USER

wget https://download.virtualbox.org/virtualbox/5.2.14/Oracle_VM_VirtualBox_Extension_Pack-5.2.14.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.14.vbox-extpack
rm Oracle_VM_VirtualBox_Extension_Pack-5.2.14.vbox-extpack
