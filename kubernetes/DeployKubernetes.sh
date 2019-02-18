#!/bin/bash

echo param 1 : ip du noeud master kubernetes

sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install docker-ce
cat > /etc/docker/daemon.json << EOF
{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "json-file",
	"log-opts": {"max-size":"100m" },
	"storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload && sudo systemctl restart docker
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat > /etc/apt/sources.list.d/kubernetes.list << EOF
	"deb http://apt.kubernetes.io/ kubernetes-xenial main"
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo swapoff -a
sudo kubeadm init --apiserver-advertise-address=$1 --pod-network-cidr=192.168.0.0/16 --feature-gates=CoreDNS=false --node-name kubernetes-master
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f rbac-kdd.yaml
kubectl apply -f calico.yaml
kubectl config set-cluster kubernetes --server https://$1:6443 --insecure-skip-tls-verify
kubectl apply -f kubernetes-dashboard.yaml
kubectl get pods --all-namespaces
sudo grep 'client-certificate-data' /etc/kubernetes/admin.conf  | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
sudo grep 'client-key-data' /etc/kubernetes/admin.conf  | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"
kubectl create -f service.yaml
kubectl create -f ClusterRoleBinding.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
kubectl get pods --all-namespaces
