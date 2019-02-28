#!/bin/bash

echo param 1 : nom du controlleur openstack
echo param 2 : ip du controlleur openstack
echo param 3 : nom du compute node openstack
echo param 4 : ip du compute node openstack
echo param 5 : nom de l\'interface du reseau physique

sudo sed -i "s/::1            localhost6.localdomain6 localhost6/#::1            localhost6.localdomain6 localhost6/g" /etc/hosts
sudo sed -i '3i IP_CONTROLLER	HOSTNAME_CONTROLLER' /etc/hosts
sudo sed -i "s/IP_CONTROLLER/$2/g" /etc/hosts
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/hosts
sudo sed -i '4i IP_COMPUTE	HOSTNAME_COMPUTE' /etc/hosts
sudo sed -i "s/IP_COMPUTE/$4/g" /etc/hosts
sudo sed -i "s/HOSTNAME_COMPUTE/$3/g" /etc/hosts

#Installation de mysql

sudo apt-get update
sudo apt install -y mysql-server

sudo ufw allow mysql

sudo systemctl start mysql
sudo systemctl enable mysql
sudo sed -e '54,54 s/#/^/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/max_connections        = 100/max_connections        = 10000/g" /etc/mysql/mysql.conf.d/mysqld.cnf

#Installation du client Openstack

sudo apt install -y python-openstackclient

#Installation d'Openstack Identite


TEMP=`sudo mysql << MyScript
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'root';
MyScript`

sudo apt install -y keystone apache2 libapache2-mod-wsgi
sudo sed -e '721,721 s/^/#/' /etc/keystone/keystone.conf
sudo sed -i '722i connection = mysql+pymysql://keystone:root@localhost/keystone' /etc/keystone/keystone.conf
sudo sed -i '2892i provider = fernet' /etc/keystone/keystone.conf
sudo su -s /bin/sh -c "keystone-manage db_sync" keystone
sudo keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
sudo keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
sudo keystone-manage bootstrap --bootstrap-password root --bootstrap-admin-url http://$1:5000/v3/ --bootstrap-internal-url http://$1:5000/v3/ --bootstrap-public-url http://$1:5000/v3/ --bootstrap-region-id RegionOne
sudo sed -i '70i ServerName localhost' /etc/apache2/apache2.conf	
sudo service apache2 restart

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=root
export OS_AUTH_URL=http://$1:5000/v3
export OS_IDENTITY_API_VERSION=3

openstack domain create --description "domaine" exemple
openstack project create --domain default --description "Service projet" service
openstack project create --domain default --description "Demo projet" demo
openstack user create --domain default --password-prompt demo
openstack role create user
openstack role add --project demo --user demo user
	
unset OS_AUTH_URL OS_PASSWORD
openstack --os-auth-url http://$1:5000/v3 --os-default-domain-id default --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin token issue
openstack --os-auth-url http://$1:5000/v3 --os-default-domain-id default --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo token issue
. admin-openrc
openstack token issue

#Installation d'Openstack Imagerie

TEMP=`sudo mysql << MyScript
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'root';
MyScript`

. admin-openrc
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "Openstack image" image
openstack endpoint create --region RegionOne image public http://$1:9292
openstack endpoint create --region RegionOne image internal http://$1:9292
openstack endpoint create --region RegionOne image admin http://$1:9292

sudo apt install -y glance
sudo sed -e '1925,1926 s/^/#/' /etc/glance/glance-api.conf
sudo sed -i '1927i connection = mysql+pymysql://glance:root@localhost/glance' /etc/glance/glance-api.conf
sudo sed -i '2043i stores = file,http' /etc/glance/glance-api.conf
sudo sed -i '2044i default_store = file' /etc/glance/glance-api.conf
sudo sed -i '2045i filesystem_store_datadir = /var/lib/glance/images/' /etc/glance/glance-api.conf
sudo sed -i '3464i container_formats = ami,ari,aki,bare,ovf,ova,docker' /etc/glance/glance-api.conf
sudo sed -i '3465i disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.root-tar' /etc/glance/glance-api.conf
sudo sed -i '3479i auth_uri = http://HOSTNAME_CONTROLLER:5000' /etc/glance/glance-api.conf
sudo sed -i '3480i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/glance/glance-api.conf
sudo sed -i '3481i memcached_servers = HOSTNAME_CONTROLLER:11211' /etc/glance/glance-api.conf
sudo sed -i '3482i auth_type = password' /etc/glance/glance-api.conf
sudo sed -i '3483i project_domain_name = default' /etc/glance/glance-api.conf
sudo sed -i '3484i user_domain_name = default' /etc/glance/glance-api.conf
sudo sed -i '3485i project_name = service' /etc/glance/glance-api.conf
sudo sed -i '3486i username = glance' /etc/glance/glance-api.conf
sudo sed -i '3487i password = root' /etc/glance/glance-api.conf
sudo sed -i '4494i flavor = keystone' /etc/glance/glance-api.conf

sudo su -s /bin/sh -c "glance-manage db_sync" glance	
sudo service glance-registry restart
sudo service glance-api restart
 	
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img  --disk-format qcow2 --container-format bare --public
openstack image list

#Installation d'Openstack Compute
	
TEMP=`sudo mysql << MyScript
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'root';
MyScript`

. admin-openrc
openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "Openstack Compute" compute
openstack endpoint create --region RegionOne compute public http://$1:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://$1:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://$1:8774/v2.1
openstack user create --domain default --password-prompt placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://$1:8778
openstack endpoint create --region RegionOne placement internal http://$1:8778
openstack endpoint create --region RegionOne placement admin http://$1:8778

sudo sed -i "s/deb http://archive.ubuntu.com/ubuntu bionic main restricted/deb http://archive.ubuntu.com/ubuntu bionic main universe restricted/g" /etc/apt/source.list
sudo sed -i "s/deb http://archive.ubuntu.com/ubuntu bionic-security main restricted/deb http://archive.ubuntu.com/ubuntu bionic-security main universe restricted/g" /etc/apt/source.list
sudo sed -i "s/deb http://archive.ubuntu.com/ubuntu bionic-updates main restricted/deb http://archive.ubuntu.com/ubuntu bionic-updates main universe restricted/g" /etc/apt/source.list
sudo apt update
sudo apt install -y nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api
sudo apt install -y rabbitmq-server
sudo rabbitmqctl add_user openstack root
sudo rabbitmqctl set_permissions openstack ".*" ".*" ".*"

sudo sed -i '5i transport_url = rabbit://openstack:root@localhost' /etc/nova/nova.conf
sudo sed -e '1295,1295 s/^/#/' /etc/nova/nova.conf
sudo sed -i '1296i my_ip = IP_CONTROLLER' /etc/nova/nova.conf
sudo sed -i '3210i auth_strategy = keystone' /etc/nova/nova.conf
sudo sed -e '3508,3508 s/^/#/' /etc/nova/nova.conf
sudo sed -i '3509i connection = mysql+pymysql://nova:root@localhost/nova_api' /etc/nova/nova.conf
sudo sed -i '3679i enable = False' /etc/nova/nova.conf
sudo sed -e '4628,4628 s/^/#/' /etc/nova/nova.conf
sudo sed -i '4629i connection = mysql+pymysql://nova:root@localhost/nova' /etc/nova/nova.conf
sudo sed -i '6133i auth_url = http://HOSTNAME_CONTROLLER:5000/v3' /etc/nova/nova.conf
sudo sed -i '6134i memcached_servers = HOSTNAME_CONTROLLER:11211' /etc/nova/nova.conf
sudo sed -i '6135i auth_type = password' /etc/nova/nova.conf
sudo sed -i '6136i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '6137i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '6138i project_name = service' /etc/nova/nova.conf
sudo sed -i '6139i username = nova' /etc/nova/nova.conf
sudo sed -i '6140i password = root' /etc/nova/nova.conf
sudo sed -i '7972i lock_path = /var/lib/nova/tmp' /etc/nova/nova.conf
sudo sed -e '8868,8868 s/^/#/' /etc/nova/nova.conf
sudo sed -i '8869i os_region_name = RegionOne' /etc/nova/nova.conf
sudo sed -i '8870i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '8871i project_name = service' /etc/nova/nova.conf
sudo sed -i '8872i auth_type = password' /etc/nova/nova.conf
sudo sed -i '8873i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '8874i auth_url = http://HOSTNAME_CONTROLLER:5000/v3' /etc/nova/nova.conf
sudo sed -i '8875i username = placement' /etc/nova/nova.conf
sudo sed -i '8876i password = root' /etc/nova/nova.conf
sudo sed -e '9536,9536 s/#/^/' /etc/nova/nova.conf
sudo sed -i "s/discover_hosts_in_cells_interval = -1/discover_hosts_in_cells_interval = 300/g" /etc/nova/nova.conf
sudo sed -e '9870,9870 s/#/^/' /etc/nova/nova.conf
sudo sed -i "s/keymap = en-us/keymap = fr/g" /etc/nova/nova.conf
sudo sed -i '10352i enabled = true' /etc/nova/nova.conf
sudo sed -i '10353i server_listen = 0.0.0.0' /etc/nova/nova.conf
sudo sed -i '10354i server_proxyclient_address = HOSTNAME_COMPUTE_NODE' /etc/nova/nova.conf

sudo su -s /bin/sh -c "nova-manage api_db sync" nova
sudo su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
sudo su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
sudo su -s /bin/sh -c "nova-manage db sync" nova 
sudo nova-manage cell_v2 list_cells
	
sudo service nova-api restart
sudo service nova-consoleauth restart
sudo service nova-scheduler restart
sudo service nova-conductor restart
sudo service nova-novncproxy restart

. admin-openrc
openstack compute service list
openstack catalog list
openstack image list
sudo nova-status upgrade check

#Installation d'Openstack network

TEMP=`sudo mysql << MyScript
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'root';
MyScript`

. admin-openrc
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "Openstack Networking" network
openstack endpoint create --region RegionOne network public http://$1:9696
openstack endpoint create --region RegionOne network internal http://$1:9696
openstack endpoint create --region RegionOne network admin http://$1:9696

sudo apt install -y neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
sudo sed -i '3i service_plugins = router' /etc/neutron/neutron.conf
sudo sed -i '4i allow_overlapping_ips = false' /etc/neutron/neutron.conf
sudo sed -i '5i rpc_backend = rabbit' /etc/neutron/neutron.conf
sudo sed -i '6i auth_strategy = keystone' /etc/neutron/neutron.conf
sudo sed -i '7i notify_nova_on_port_status_changes = true' /etc/neutron/neutron.conf
sudo sed -i '8i notify_nova_on_port_data_changes = true' /etc/neutron/neutron.conf
sudo sed -e '711,711 s/^/#/' /etc/neutron/neutron.conf
sudo sed -i '712i connection = mysql+pymysql://neutron:root@localhost/neutron' /etc/neutron/neutron.conf
sudo sed -i '827i auth_uri = http://HOSTNAME_CONTROLLER:5000' /etc/neutron/neutron.conf
sudo sed -i '828i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/neutron/neutron.conf
sudo sed -i '829i memcached_servers = HOSTNAME_CONTROLLER:11211' /etc/neutron/neutron.conf
sudo sed -i '830i auth_type = password' /etc/neutron/neutron.conf
sudo sed -i '831i project_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '832i user_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '833i project_name = service' /etc/neutron/neutron.conf
sudo sed -i '834i username = neutron' /etc/neutron/neutron.conf
sudo sed -i '835i password = root' /etc/neutron/neutron.conf
sudo sed -i '1117i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/neutron/neutron.conf
sudo sed -i '1118i auth_type = password' /etc/neutron/neutron.conf
sudo sed -i '1119i project_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '1120i user_domain_name = default' /etc/neutron/neutron.conf
sudo sed -i '1121i project_name = service' /etc/neutron/neutron.conf
sudo sed -i '1122i region_name = RegionOne' /etc/neutron/neutron.conf
sudo sed -i '1123i username = nova' /etc/neutron/neutron.conf
sudo sed -i '1124i password = root' /etc/neutron/neutron.conf
sudo sed -i '1536i rabbit_host = localhost' /etc/neutron/neutron.conf
sudo sed -i '1537i rabbit_userid = openstack' /etc/neutron/neutron.conf
sudo sed -i '1538i rabbit_password = root' /etc/neutron/neutron.conf

sudo sed -i '129i type_drivers = local,flat,vlan,gre,vxlan,geneve' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '129i tenant_network_types = vxlan' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '129i mechanism_drivers = linuxbridge,l2population' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '129i extension_drivers = port_security' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '181i flat_networks = provider' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '236i vni_ranges = 1:1000' /etc/neutron/plugins/ml2/ml2_conf.ini
sudo sed -i '253i enable_ipset = true' /etc/neutron/plugins/ml2/ml2_conf.ini

sudo sed -i '147i physical_interface_mappings = provider:PHYSICAL_NETWORK_INTERFACE' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i '183i enable_security_group = true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i '184i firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i '204i enable_vxlan =true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i '205i local_ip = IP_CONTROLLER' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i '206i l2_population = true' /etc/neutron/plugins/ml2/linuxbridge_agent.ini

sudo sed -i '2i interface_driver = linuxbridge' /etc/neutron/l3_agent.ini

sudo sed -i '2i interface_driver = linuxbridge' /etc/neutron/dhcp_agent.ini
sudo sed -i '3i dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq' /etc/neutron/dhcp_agent.ini
sudo sed -i '4i enable_isolated_metadata = false' /etc/neutron/dhcp_agent.ini

sudo sed -i '2i nova_metadata_host = HOSTNAME_CONTROLLER' /etc/neutron/metadata_agent.ini
sudo sed -i '3i metadata_proxy_shared_secret = INSIGHT' /etc/neutron/metadata_agent.ini

sudo sed -i '7644i url = http://HOSTNAME_CONTROLLER:9696' /etc/nova/nova.conf
sudo sed -i '7645i auth_url = http://HOSTNAME_CONTROLLER:5000' /etc/nova/nova.conf
sudo sed -i '7646i auth_type = password' /etc/nova/nova.conf
sudo sed -i '7647i project_domain_name = default' /etc/nova/nova.conf
sudo sed -i '7648i user_domain_name = default' /etc/nova/nova.conf
sudo sed -i '7649i region_name = RegionOne' /etc/nova/nova.conf
sudo sed -i '7650i project_name = service' /etc/nova/nova.conf
sudo sed -i '7651i username = neutron' /etc/nova/nova.conf
sudo sed -i '7652i password = root' /etc/nova/nova.conf
sudo sed -i '7653i service_metadata_proxy = true' /etc/nova/nova.conf
sudo sed -i '7654i metadata_proxy_shared_secret = INSIGHT' /etc/nova/nova.conf

sudo su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
sudo service nova-api restart
sudo service neutron-server restart
sudo service neutron-linuxbridge-agent restart
sudo service neutron-dhcp-agent restart
sudo service neutron-metadata-agent restart
sudo service neutron-l3-agent restart
openstack network agent list

#Installation d'Openstack dashboard
sudo apt install -y openstack-dashboard
sudo sed -i "s/\"data-processing\": 1.1,/#\"data-processing\": 1.1,/g"  /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/\"compute\": 2,/#\"compute\": 2,/g"  /etc/openstack-dashboard/local_settings.py
sudo sed -e '76,76 s/#/^/' /etc/openstack-dashboard/local_settings.py
sudo sed -e '98,98 s/#/^/' /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/'LOCATION': '127.0.0.1:11211',/'LOCATION': 'HOSTNAME_CONTROLLER:11211',/g"  /etc/openstack-dashboard/local_settings.py
sudo sed -i '197i OPENSTACK_HOST = "HOSTNAME_CONTROLLER"' /etc/openstack-dashboard/local_settings.py
sudo sed -i '198i OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST' /etc/openstack-dashboard/local_settings.py
sudo sed -i '199i OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"' /etc/openstack-dashboard/local_settings.py
sudo sed -i '333i '"enable_router"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '334i '"enable_quotas"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '335i '"enable_ipv6"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '336i '"enable_distributed_router"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '337i '"enable_ha_router"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '338i '"enable_lb"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '339i '"enable_firewall"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '340i '"enable_vpn"': False,' /etc/openstack-dashboard/local_settings.py
sudo sed -i '341i '"enable_fip_topology_check"': False,' /etc/openstack-dashboard/local_settings.py
sudo service apache2 reload

sudo sed -i "s/-l 127.0.0.1/IP_CONTROLLER/g"  /etc/memcached.conf
sudo service memcached restart

sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/glance/glance-api.conf
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/nova/nova.conf 
sudo sed -i "s/IP_CONTROLLER/$2/g" /etc/nova/nova.conf 
sudo sed -i "s/HOSTNAME_COMPUTE_NODE/$3/g" /etc/nova/nova.conf 
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/neutron/neutron.conf
sudo sed -i "s/PHYSICAL_NETWORK_INTERFACE/$5/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "s/IP_CONTROLLER/$2/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/neutron/metadata_agent.ini
sudo sed -i "s/HOSTNAME_CONTROLLER/$1/g" /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/IP_CONTROLLER/$2/g" /etc/memcached.conf