#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update && sudo apt-get install -y docker-ce

sudo cat > /etc/docker/daemon.json << EOF
{
"debug": true,
"ipv6": true,
"fixed-cidr-v6": "2001:db8:1::/64",
"hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo cat > /etc/systemd/system/docker.service.d/docker.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

sudo cat > /etc/resolv.conf << EOF
nameserver 66.28.0.45
nameserver 66.28.0.61
nameserver 127.0.1.1
search corp.capgemini.com
search openstacklocal
EOF

