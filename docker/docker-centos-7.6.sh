#!/bin/bash
#WARNING: yum needs date synchronization with centos archive servers
#you may need to set the correct date first (e.g. sudo date 0227150219)
#update yum index
sudo yum check-update
#allow yum-config-manager to add repo
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
#add Docker's offical repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#install docker-ce
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker

#set daemon to expose interface on 2375 and enable ipv6 routing to containers
echo '{
"debug": true,
"ipv6": true,
"fixed-cidr-v6": "2001:db8:1::/64",
"hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}' | sudo tee -a /etc/docker/daemon.json

sudo mkdir -p /etc/systemd/system/docker.service.d

echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd' | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf


sudo systemctl daemon-reload
sudo systemctl restart docker

#install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#add current user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER

#needs ssh reconnect for changes to take effect on current user




