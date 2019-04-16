# Filer Samba

This document describes how to install a samba filer on Ubuntu 18.04 server.

## Install

The script `install-samba.sh` install samba and create a shared directory with a admin user.

    ./install-samba.sh SharedDir PEPLOLEUM sambadmin password

The `SharedDir` is created here : `/samba/SharedDir`

## Connecting on samba share

### On Windows

* Open an explorer and type `\\<IP>\SharedDir`
* Login with `PEPLOLEUM\sambadmin` and `password`

### On Linux

* Install samba client
    
      sudo apt install smbclient
      
  or
  
      sudo yum install samba-client

* Access with 

       mbclient //<IP>/SharedDir -U PEPLOLEUM/sambadmin

  or
  
      smbclient //<IP>/SharedDir -U PEPLOLEUM/sambadmin

### Mounting the samba Share on Linux.

* Install cifs

      sudo apt install cifs-utils

  or

      sudo yum install cifs-utils
      
* Create a mount point

      sudo mkdir /mnt/smbmount
      
* Mount the share using the following command:

      sudo mount -t cifs -o username=sambadmin,domain=PEPLOLEUM,password=password //<IP>/SharedDir /mnt/smbmount

### Add extra user

* Create user

      sudo useradd -s /usr/sbin/nologin -G sambashare billybob

* Add user in samba database, you will be prompt for password :

      sudo smbpasswd -a billybob

* Once the password is set, enable the Samba account :

      sudo smbpasswd -e billybob

### Add extra shared directory

* Create directory in `/samba/`

      sudo mkdir /samba/newSharedDir

* Set the directory ownership to admin user and group sambashare:
                    
      sudo chown sambadmin:sambashare /samba/newSharedDir
      sudo chmod 2770 /samba/newSharedDir

* Configure the samba share by updating `/etc/samba/smb.conf`. Add :

```ini
[newSharedDir]
    path = /samba/newSharedDir
    browseable = yes
    read only = no
    force create mode = 0660
    force directory mode = 2770
    valid users = @sambashare @sambadmin
```

The options have the following meanings:

`[newSharedDir]` - The names of the shares that you will use when logging in.
path - The path to the share.

`browseable` - Whether the share should be listed in the available shares list. By setting to no other users will not be able to see the share.

`read only` - Whether the users specified in the valid users list are able to write to this share.

`force create mode` - Sets the permissions for the newly created files in this share.

`force directory mode` - Sets the permissions for the newly created directories in this share.

`valid users` - A list of users and groups that are allowed to access the share. Groups are prefixed with the @ symbol.


* Reboot Samba service

      sudo systemctl restart nmbd
