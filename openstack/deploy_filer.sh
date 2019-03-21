#!/usr/bin/env bash

set -x

#Installation de sftp
sudo apt-get install -y vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf_orig
sudo sed -i '1i listen=NO' /etc/vsftpd.conf
sudo sed -i '2i listen_ipv6=NO' /etc/vsftpd.conf
sudo sed -i '3i anonymous_enable=NO' /etc/vsftpd.conf
sudo sed -i '4i local_enable=YES' /etc/vsftpd.conf
sudo sed -i '5i write_enable=YES' /etc/vsftpd.conf
sudo sed -i '6i local_umask=022' /etc/vsftpd.conf
sudo sed -i '7i dirmessage_enable=YES' /etc/vsftpd.conf
sudo sed -i '8i use_localtime=YES' /etc/vsftpd.conf
sudo sed -i '9i xferlog_enable=YES' /etc/vsftpd.conf
sudo sed -i '10i connect_from_port_20=YES' /etc/vsftpd.conf
sudo sed -i '11i chroot_local_user=YES' /etc/vsftpd.conf
sudo sed -i '12i secure_chroot_dir=/var/run/vsftpd/empty' /etc/vsftpd.conf
sudo sed -i '13i pam_service_name=vsftpd' /etc/vsftpd.conf
sudo sed -i '14i rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem' /etc/vsftpd.conf
sudo sed -i '15i rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key' /etc/vsftpd.conf
sudo sed -i '16i ssl_enable=NO' /etc/vsftpd.conf
sudo sed -i '17i pasv_enable=Yes' /etc/vsftpd.conf
sudo sed -i '18i pasv_min_port=10000' /etc/vsftpd.conf
sudo sed -i '19i pasv_max_port=10100' /etc/vsftpd.conf
sudo sed -i '20i allow_writeable_chroot=YES' /etc/vsftpd.conf
sudo ufw allow from any to any port 20,21,10000:10100 proto tcp
sudo service vsftpd restart

#Ajout de l'utilisateur dans le group sftp
sudo addgroup sftp
sudo adduser -q test
sudo adduser test sftp
sudo chmod 777 /home/test/

#Installation de samba
sudo apt install -y tasksel
sudo apt-get update
sudo tasksel install samba-server
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_backup
sudo bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf_backup | grep . > /etc/samba/smb.conf'
sudo smbpasswd -a test

#Création du partage
sudo mkdir /media/partage
sudo chmod 777 /media/partage
sudo chown test /media/partage
sudo adduser test root
sudo sed -i '27i [partage]' /etc/samba/smb.conf
sudo sed -i '28i    comment = Partage réseau' /etc/samba/smb.conf
sudo sed -i '29i    path = /media/partage' /etc/samba/smb.conf
sudo sed -i '30i    available = yes' /etc/samba/smb.conf
sudo sed -i '31i    valid users = test,ubuntu' /etc/samba/smb.conf
sudo sed -i '32i    read only = no' /etc/samba/smb.conf
sudo sed -i '23i    browseable = yes' /etc/samba/smb.conf
sudo sed -i '34i    public = yes' /etc/samba/smb.conf
sudo sed -i '35i    writable = yes' /etc/samba/smb.conf
sudo systemctl restart smbd

smbclient -L localhost
sudo systemctl status smbd

set +x
