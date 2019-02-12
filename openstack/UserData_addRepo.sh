#!/bin/bash

#Example script to run at first boot via Openstack

echo "userdata running on hostname: $(uname -n)"

sudo apt install yum
sudo chmod 777 /etc/yum/repos.d/
cat > /etc/yum/repos.d/nexus.repo << EOF
[nexusrepo]
name=Nexus Repository
baseurl=http://IP du nexus:Port du nexus/repository/yum
enabled=1
protect=0
gpgcheck=0
metadata_expire=30s
EOF

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bk
cat > /etc/apt/sources.list << EOF
deb http://IP du nexus:Port du nexus/repository/apt-ubuntu16.04 xenial main
...
EOF