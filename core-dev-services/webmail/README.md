# Mail Server

This document describes how to install a mail server with FreeIPA LDAP authentication.

* Create a CentOS7.1810 VM with at least 2Gb RAM and 20Gb disk.

* Enroll the machine to FreeIPA. Follow [this script](../../freeipa/client/install-centos7-1810.sh).

* Disable the firewall (must be fix with finest config later)

       sudo systemctl disable firewalld 
       sudo systemctl stop firewalld  

* Run `install-postfix-dovecot.sh` with good parameters. For example :

       ./install-postfix-dovecot.sh 10.0.0.26 peploleum.com admin adminadmin
