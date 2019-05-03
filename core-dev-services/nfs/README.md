# Filer NFS

This document describes how to install a NFS filer on Ubuntu 18.04 server.

## Install

Install the package `nfs-kernel-server`

    sudo apt-get install nfs-kernel-server -y

Create User
    
    sudo adduser --no-create-home --disabled-password --uid 1500 nfsguest

Create Directory and change write

    sudo mkdir /shared
    sudo chown nfsguest:nfsguest /shared
    sudo chmod 775 /shared

Edit `/etc/export` and add the directory to the NFS. Add this line :
    
    /shared 192.168.0.0/16(rw,all_squash,anonuid=1500,anongid=1500,sync,no_subtree_check)

## Connect client NFS

### On Windows

* Enabled [NFS Client Service](https://mapr.com/docs/61/AdministratorGuide/MountingNFSonWindowsClient.html). 
  1. Open Start > Control Panel > Programs.
  2. Select Turn Windows features on or off.
  3. Enabled Services for NFS (Client and Admins Tools).
  4. Click OK.
  5. Open PowerShell as Administrator 
  6. Go in this directory
  7. Launch `regedit.exe /s .\NFS_UID.reg`
  8. Reboot the computer
  
* Map a network drive with the Map Network Drive tool
  1. Open Start > My Computer
  2. Select Tools > Map Network Drive
  3. In the Map Network Drive window, choose an unused drive letter from the Drive drop-down list
  4. Specify the Folder `\\ip_dest\shared`
  6. Select Reconnect at login to reconnect automatically
  7. Click Finish

### On Linux

Install NFS client

* `sudo yum install nfs-utils` (Red Hat or CentOS)
* `sudo apt-get install nfs-common` (Ubuntu)

Create a mount point

* `sudo mkdir /mnt/shared`

Mount the directory

* `sudo mount -o hard,nolock ip_dest:/shared /mnt/shared`


  
