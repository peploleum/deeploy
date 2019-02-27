#!/bin/bash
#WARNING: apt needs date synchronization with ubuntu archive servers
#you may need to set the correct date first (e.g. sudo date 0227150219)
#update apt index
sudo apt-get update
#allow apt to use a repository over HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#add Docker's offical GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#set stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#install docker-ce
sudo apt-get update && sudo apt-get install -y docker-ce

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

#sudo sed -i '4i dns-search openstacklocal corp.capgemini.com' /etc/network/interfaces
#sudo sed -i '5i dns-nameservers 66.28.0.45 66.28.0.61 127.0.1.1' /etc/network/interfaces


