#!/usr/bin/env bash

set -x
if [ $# -lt 4 ] ; then
  echo "Usage: deploy_filer.sh IPA_SERVER_IP IPA_SERVER_FQDN IPA_DOMAIN_NAME IPA_REALM"
  echo
  echo IPA_SERVER_IP must be:
  echo "  â€¢ valid IP of running IPA server"
  echo
  echo IPA_SERVER_FQDN must meet the following:
  echo "  â€¢ valid Fully Qualified Domain Name of running IPA server"
  echo
  echo IPA_DOMAIN_NAME must meet the following:
  echo "  â€¢ be defined in samba"
  echo
  echo IPA_REALM must meet the following:
  echo "  â€¢ be defined in samba"
  echo
    echo "Examples:"
  echo "  â€¢ $0 10.0.0.1 ipa.gitlab.peploleum.com gitlab peploleum.com "
  exit 1
fi

#add ipa server hostname and IP address to hosts
echo "$1 $2" | sudo tee -a /etc/hosts

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
sudo usermod -aG sftp ubuntu
sudo chmod 700 /home/ubuntu/

#Installation de samba
sudo apt install -y tasksel
sudo tasksel install samba-server
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_backup
sudo bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf_backup | grep . > /etc/samba/smb.conf'
sudo smbpasswd -a test
sudo sed -i '1i [homes]' /etc/samba/smb.conf
sudo sed -i '2i    comment = Home Directories' /etc/samba/smb.conf
sudo sed -i '3i    browseable = yes' /etc/samba/smb.conf
sudo sed -i '4i    read only = no' /etc/samba/smb.conf
sudo sed -i '5i    create mask = 0700' /etc/samba/smb.conf
sudo sed -i '6i    directory mask = 0700' /etc/samba/smb.conf
sudo sed -i '7i    valid users = %S' /etc/samba/smb.conf
sudo sed -i "s/workgroup = WORKGROUP/workgroup = $3/g" /etc/samba/smb.conf 
sudo sed -i '11i   realm = $3.$4' /etc/samba/smb.conf
sudo sed -i '12i   dedicated keytab file = FILE:/etc/samba/samba.keytab' /etc/samba/smb.conf
sudo sed -i '13i   kerberos method = dedicated keytab' /etc/samba/smb.conf
sudo sed -i '14i   security = ads' /etc/samba/smb.conf
sudo systemctl restart smbd

smbclient -L localhost
sudo mkdir /home/test/partage
sudo chmod 755 /home/test/partage
sudo systemctl status smbd

set +x
