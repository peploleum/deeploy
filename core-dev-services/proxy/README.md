# Proxy Server

This document describes how to install a proxy server with SQUID and Nexus.

* Create a CentOS7.1810 VM with at least 8Gb RAM and 500Gb disk.

* Enroll the machine to FreeIPA. Follow [this script](../../freeipa/client/install-centos7-1810.sh).

* Disable SELinux by modifying `/etc/selinux/config` and pass change `SELINUX` value in `disabled`

* Restart the VM, `sudo shutdown -r now`

* Install SQUID, follow [Ansible SQUID](../../ansible/squid/README.md)

* Install Nexus, follow [Ansible Nexus](../../ansible/nexus/docs/README.md)

