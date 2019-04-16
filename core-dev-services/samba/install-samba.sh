#!/usr/bin/env bash

if [ $# -lt 4 ]; then
  echo "Usage: $0 SHARED_DIR_NAME SAMBA_GROUP ADMIN_LOGIN ADMIN_PASSWORD"
  echo
  echo SHARED_DIR_NAME must meet the following:
  echo "  • directory name without spaces and specials characters"
  echo
  echo SAMBA_GROUP must meet the following:
  echo "  • Upper case without spaces"
  echo
  echo ADMIN_LOGIN must meet the following:
  echo "  • admin user"
  echo
  echo ADMIN_PASSWORD must meet the following:
  echo "  • admin password"
  echo
  echo  echo "Examples:"
  echo "  • $0 shared PEPLOLEUM sadmin password"
  exit 1
fi

sharedDir=$1
sambaGroup=$2
adminLogin=$3
adminPassword=$4

sudo apt-get install samba -y

sudo ufw allow 'Samba'

sudo cp /etc/samba/smb.conf{,.backup}

sudo sed -i -e "s/workgroup = WORKGROUP/workgroup = $sambaGroup/g" /etc/samba/smb.conf

sudo systemctl restart nmbd

sudo mkdir /samba
sudo chgrp sambashare /samba

sudo useradd -M -d /samba/$sharedDir -s /usr/sbin/nologin -G sambashare $adminLogin
(echo $adminPassword;echo $adminPassword) | sudo smbpasswd -a $adminLogin
sudo smbpasswd -e $adminLogin

sudo mkdir /samba/$sharedDir
sudo chown $adminLogin:sambashare /samba/$sharedDir
sudo chmod 2770 /samba/$sharedDir

echo "[$sharedDir]
    path = /samba/$sharedDir
    browseable = yes
    read only = no
    force create mode = 0660
    force directory mode = 2770
    valid users = @sambashare @$adminLogin" | sudo tee -a /etc/samba/smb.conf

sudo systemctl restart nmbd
