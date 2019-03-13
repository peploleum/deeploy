#!/bin/bash

#Réseau de dev-virt -- public
./create_instance.sh L Ubuntu_18.04_server dev-virt 10.0.0.10 192.168.0.110 core-services
./create_instance.sh XXXL Ubuntu_18.04_server dev-virt 10.0.0.31 192.168.0.131 docker-node-01
./create_instance.sh XXL Ubuntu_18.04_server dev-virt 10.0.0.32 192.168.0.132 docker-node-02
./create_instance.sh L Ubuntu_18.04_server dev-virt 10.0.0.33 192.168.0.133 docker-node-03
./create_instance.sh XXL Ubuntu_18.04_server dev-virt 10.0.0.50 192.168.0.150 atos-services
./create_instance.sh L Ubuntu_16.04_server dev-virt 10.0.0.20 192.168.0.120 kubernetes-master
./create_instance.sh XL Ubuntu_16.04_server dev-virt 10.0.0.21 192.168.0.121 kubernetes-node-01
./create_instance.sh XL Ubuntu_16.04_server dev-virt 10.0.0.22 192.168.0.122 kubernetes-node-02

#Réseau de qualif-virt -- public
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.5 192.168.0.205 kdl-01
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.6 192.168.0.206 kdl-02
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.7 192.168.0.207 kdl-03
./create_instance.sh XL Ubuntu_18.04_server qualif-virt 10.0.10.8 192.168.0.208 kdl-04
