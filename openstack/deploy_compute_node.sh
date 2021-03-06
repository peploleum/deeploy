#!/bin/bash
set -x

echo param 1 : nom du controlleur openstack
echo param 2 : ip du controlleur openstack
echo param 3 : nom de l\'interface du reseau physique
echo param 4 : ip du compute openstack


if [ $# -lt 4 ] ; then
  echo "Usage: $0 CONTROLLER_NAME CONTORLLER_IP NETWORK_INTERFACE COMPUTE_NODE_IP"
  echo
  echo CONTROLLER_NAME must meet the following:
  echo "  • hostname of the openstack controller"
  echo
  echo CONTORLLER_IP must meet the following:
  echo "  • valid IPv4 of the openstack controller"
  echo
  echo NETWORK_INTERFACE must meet the following:
  echo "  • name of the local network interface (e.g. eno1)"
  echo
  echo COMPUTE_NODE_IP must meet the following:
  echo "  • valid IPv4"
  echo "  • IP if the compute node (e.g local machine)"
  echo
  echo "Examples:"
  echo "  • $0 192.168.0.10 openstack-controller eno1 192.168.0.14"
  exit 1
fi


sudo sed -i '3i IP	HOSTNAME' /etc/hosts
sudo sed -i "s/IP/$4/g" /etc/hosts
sudo sed -i "s/HOSTNAME/$(hostname)/g" /etc/hosts
sudo sed -i '4i IP_CONTROLLER	HOSTNAME_CONTROLLER' /etc/hosts
sudo sed -i "s/IP_CONTROLLER/$2/g" /etc/hosts
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/hosts

#Installation de nova

sudo apt install -y nova-compute

sudo sed -i "s/log_dir = /var/log/nova/#log_dir = /var/log/nova/g" /etc/nova/nova.conf 
sudo sed -i '5i transport_url = rabbit://openstack:root@HOSTNAME_CONTROLLER' /etc/nova/nova.conf
sudo sed -i "s/#auth_strategy = keystone/auth_strategy = keystone/g" /etc/nova/nova.conf
sudo sed -i '1295i my_ip = IP' /etc/nova/nova.conf
sudo sed -i '6131i auth_url = http://HOSTNAME_CONTROLLER/v3' /etc/nova/nova.conf
sudo sed -i '6132i memcached_servers = HOSTNAME_CONTROLLER:11211' /etc/nova/nova.conf
sudo sed -i '6133i auth_type = password' /etc/nova/nova.conf
sudo sed -i '6134i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '6135i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '6136i project_name = service' /etc/nova/nova.conf
sudo sed -i '6137i username = nova' /etc/nova/nova.conf
sudo sed -i '6138i password = root' /etc/nova/nova.conf
sudo sed -i "s/#use_neutron = true/use_neutron = true/g" /etc/nova/nova.conf
sudo sed -i "s/#firewall_driver = nova.virt.firewall.NoopFirewallDriver/firewall_driver = nova.virt.firewall.NoopFirewallDriver/g" /etc/nova/nova.conf
sudo sed -i '10348i enabled = true' /etc/nova/nova.conf
sudo sed -i '10349i server_listen = $my_ip' /etc/nova/nova.conf
sudo sed -i '10350i server_proxyclient_address = $my_ip' /etc/nova/nova.conf
sudo sed -i '10351i novncproxy_base_url = http://HOSTNAME_CONTROLLER:6080/vnc_auto.html' /etc/nova/nova.conf
sudo sed -i '5329i api_servers = http://HOSTNAME_CONTROLLER:9292' /etc/nova/nova.conf
sudo sed -i '7969i lock_path = /var/lib/nova/tmp' /etc/nova/nova.conf
sudo sed -i '8865i os_region_name = RegionOne' /etc/nova/nova.conf
sudo sed -i '8866i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '8867i project_name = service' /etc/nova/nova.conf
sudo sed -i '8868i auth_type = password' /etc/nova/nova.conf
sudo sed -i '8869i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '8870i auth_url = http://HOSTNAME_CONTROLLER:5000/v3' /etc/nova/nova.conf
sudo sed -i '8871i username = placement' /etc/nova/nova.conf
sudo sed -i '8872i password = root' /etc/nova/nova.conf

#Commande qui vérifie si le node compute accepte l'accélération matérielle
egrep -c '(vmx|svm)' /proc/cpuinfo

sudo service nova-compute restart

#Installation de neutron

sudo apt install -y neutron-linuxbridge-agent

sudo sed -i '3i transport_url = rabbit://openstack:root@HOSTNAME_CONTROLLER' /etc/neutron/neutron.conf
sudo sed -i '4i auth_strategy = keystone' /etc/neutron/neutron.conf
sudo sed -i '823i auth_uri = http://HOSTNAME_CONTROLLER:5000' /etc/neutron/neutron.conf
sudo sed -i '824i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/neutron/neutron.conf
sudo sed -i '825i memcached_servers = HOSTNAME_CONTROLLER:11211 ' /etc/neutron/neutron.conf
sudo sed -i '826i auth_type = password' /etc/neutron/neutron.conf
sudo sed -i '827i project_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '828i user_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '829i project_name = service' /etc/neutron/neutron.conf
sudo sed -i '830i username = neutron' /etc/neutron/neutron.conf
sudo sed -i '831i password = root' /etc/neutron/neutron.conf

sudo sed -i '147i physical_interface_mappings = provider:PHYSICAL_NETWORK_INTERFACE' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
sudo sed -i '183i enable_security_group = true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
sudo sed -i '184i firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
sudo sed -i '207i enable_vxlan =true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
sudo sed -i '208i local_ip = IP' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
sudo sed -i '209i l2_population = true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini 

sudo sed -i '7642i url = http://HOSTNAME_CONTROLLER:9696' /etc/nova/nova.conf
sudo sed -i '7643i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/nova/nova.conf
sudo sed -i '7644i auth_type = password' /etc/nova/nova.conf
sudo sed -i '7645i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '7646i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '7647i region_name = RegionOne' /etc/nova/nova.conf
sudo sed -i '7648i project_name = service' /etc/nova/nova.conf
sudo sed -i '7649i username = neutron' /etc/nova/nova.conf
sudo sed -i '7650i password = root' /etc/nova/nova.conf

sudo sed -i "s/IP/$4/g" /etc/nova/nova.conf
sudo sed -i "s/IP/$4/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/nova/nova.conf 
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/neutron/neutron.conf 
sudo sed -i "s/PHYSICAL_NETWORK_INTERFACE/$3/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini


sudo service nova-compute restart
sudo service neutron-linuxbridge-agent restart
