# deeploy

## Kubernetes

### Prerequisites :  
* Prepare your system to resolve the namespace réseau cap (IP du dns cap)
* copy the following files :

        rbac-kdd.yaml
        calico.yaml
        kubernetes-dashboard.yaml
        service.yaml
        ClusterRoleBinding.yaml


### Download and install kubecfg.p12 :

Download kubecfg.p12 generated without MobaXterm
Click "Advanced Parameters", manage certificates.
Import file kubecfg.p12.
Restart browser.

### Copy token

Copy in file token.tkt, result of the command :

        kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

### Access url kubernetes-dashboard

        https://IP du kubernetes master:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy


