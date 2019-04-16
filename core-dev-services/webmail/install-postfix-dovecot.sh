#!/usr/bin/env bash

if [ $# -lt 4 ]; then
  echo "Usage: $0 MAIL_SERVER_IP DOMAIN_NAME IPA_PRINCIPAL IPA_PASSWORD"
  echo
  echo MAIL_SERVER_IP must meet the following:
  echo "  • valid IPv4"
  echo
  echo DOMAIN_NAME must meet the following:
  echo "  • domain name"
  echo
  echo IPA_PRINCIPAL must meet the following:
  echo "  • admin user"
  echo
  echo IPA_PASSWORD must meet the following:
  echo "  • admin password"
  echo
  echo  echo "Examples:"
  echo "  • $0 10.0.0.26 peploleum.com admin adminadmin"
  exit 1
fi

shortName=$(hostname -s)

# Prepare FreeIPA
echo $4 | kinit $3
ipa group-add mailusers --no-members
ipa dnsrecord-add $2 $shortName --a-ip-address=$1 --a-create-reverse
ipa dnsrecord-add $2 @ --mx-rec="0 $shortName.$2."

# POSTFIX
sudo yum -y install postfix
sudo chkconfig postfix on

sudo sed -i -e "s/#myhostname = host.domain.tld/myhostname = $shortName.$2/g" /etc/postfix/main.cf
sudo sed -i -e "s/#mydomain = domain.tld/mydomain = $2/g" /etc/postfix/main.cf
sudo sed -i 's/#myorigin = $mydomain/myorigin = $mydomain/g' /etc/postfix/main.cf
sudo sed -i 's/#inet_interfaces = all/inet_interfaces = all/g' /etc/postfix/main.cf
sudo sed -i 's/inet_interfaces = localhost/#inet_interfaces = localhost/g' /etc/postfix/main.cf
sudo sed -i 's/mydestination = $myhostname, localhost.$mydomain, localhost/mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain/g' /etc/postfix/main.cf

sudo service postfix restart

sudo mkdir /mail
sudo chmod 770 /mail
sudo chgrp mailusers /mail
sudo chcon -t user_home_t /mail

# DOVECOT
sudo yum -y install dovecot
# set dovecot to start on boot
sudo chkconfig dovecot on
# set dovecot to listen on imap and imaps only
sudo sed -i 's/#protocols = imap pop3 lmtp/protocols = imap/g' /etc/dovecot/dovecot.conf
# point dovecot to required mailbox directory (This is the section that was previously failing)
echo "mail_location = mbox:/mail/%u/:INBOX=/var/mail/%u" | sudo tee -a /etc/dovecot/dovecot.conf
# reload dovecot to apply changes
sudo service dovecot restart

sudo chmod 770 /var/mail
sudo chgrp mailusers /var/mail

# ROUNDCUBE
sudo yum install -y httpd php php-common php-json php-xml php-mbstring php-imap php-pear-DB php-mysql mysql mariadb-server

sudo sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/g" /etc/php.ini
# memory_limit=64M,
# display_errors=Off, log_errors=On, error_log=logs/errors.log,
# upload_max_filesize=5M, post_max_size=6M,
# zlib.output_compression=Off, suhosin.session.encrypt=Off, session.auto_start=Off,
# session.gc_maxlifetime=21600, session.gc_divisor=500, session.gc_probability=1.

# Prepare Roundcube html directory
sudo tar -zxpvf roundcubemail-1.3.9-complete.tar.gz -C /var/www/html/
sudo mv /var/www/html/roundcubemail-1.3.9 /var/www/html/roundcube
sudo cp config.inc.php /var/www/html/roundcube/config/config.inc.php
sudo chown -R apache:apache /var/www/html/roundcube
sudo chmod -R 755 /var/www/html/roundcube

sudo sed -i -e "s/!!MAIL_SERVER!!/$shortName.$2/g" /var/www/html/roundcube/config/config.inc.php
sudo sed -i -e "s/!!DOMAIN_NAME!!/$2/g" /var/www/html/roundcube/config/config.inc.php

# Prepare database
sudo systemctl start mariadb
sudo systemctl enable  mariadb

TEMP=`sudo mysql -u root -p << MyScript
CREATE DATABASE roundcubemail /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;
GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'roundcube';
FLUSH PRIVILEGES;
MyScript`

sudo mysql -u roundcube -p roundcube roundcubemail < /var/www/html/roundcube/SQL/mysql.initial.sql

# Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd
