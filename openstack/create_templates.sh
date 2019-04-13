#!/bin/bash

. admin-openrc

# Cleanup
remove-instance.sh core-services 192.168.0.111
remove-instance.sh docker-node-01 192.168.0.131
remove-instance.sh docker-node-02 192.168.0.132
remove-instance.sh docker-node-03 192.168.0.133
remove-instance.sh atos-services 192.168.0.150
remove-instance.sh kubernetes-master 192.168.0.120
remove-instance.sh kubernetes-node-01 192.168.0.121
remove-instance.sh kubernetes-node-02 192.168.0.122

remove-instance.sh kdl-01 192.168.0.171
remove-instance.sh kdl-02 192.168.0.172
remove-instance.sh kdl-03 192.168.0.173
remove-instance.sh kdl-04 192.168.0.174

#Réseau de dev-virt -- public
./create_instance.sh L Ubuntu_18.04_server dev-virt 10.0.0.11 192.168.0.111 core-services
./create_instance.sh XXXL Ubuntu_18.04_server dev-virt 10.0.0.31 192.168.0.131 docker-node-01
./create_instance.sh XXL Ubuntu_18.04_server dev-virt 10.0.0.32 192.168.0.132 docker-node-02
./create_instance.sh L Ubuntu_18.04_server dev-virt 10.0.0.33 192.168.0.133 docker-node-03
./create_instance.sh XXL Ubuntu_18.04_server dev-virt 10.0.0.50 192.168.0.150 atos-services
./create_instance.sh L Ubuntu_16.04_server dev-virt 10.0.0.20 192.168.0.120 kubernetes-master
./create_instance.sh XL Ubuntu_16.04_server dev-virt 10.0.0.21 192.168.0.121 kubernetes-node-01
./create_instance.sh XL Ubuntu_16.04_server dev-virt 10.0.0.22 192.168.0.122 kubernetes-node-02

#Réseau de qualif-virt -- public
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.11 192.168.0.171 kdl-01
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.12 192.168.0.172 kdl-02
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.13 192.168.0.173 kdl-03
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.14 192.168.0.174 kdl-04
