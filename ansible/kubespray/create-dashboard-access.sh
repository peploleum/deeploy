#!/bin/bash

cd $HOME
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Generate P12 Certicate
sudo grep 'client-certificate-data' /etc/kubernetes/admin.conf  | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
sudo grep 'client-key-data' /etc/kubernetes/admin.conf  | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"

# Add admin right
cat <<EOF >$HOME/dashboard-admin.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
EOF

chmod 755 dashboard-admin.yaml
kubectl create -f dashboard-admin.yaml

# Get Dashboard Token
kubectl -n kube-system describe secrets $(kubectl -n kube-system get secrets -o=custom-columns=NAME:.metadata.name | grep kubernetes-dashboard-token) > token.txt
