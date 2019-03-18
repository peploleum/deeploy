# KUBESPRAY

This recipe describes how to install kubernetes with Ansible on 3 VM in the Sandbox network.

Create the VM with :
    
    ./init_vm.sh

It creates 4 VM :

* k8s-ansible (12.12.12.11 / 192.168.0.211) as manager
* k8s-master (12.12.12.20 / 192.168.0.220) as kubernetes controller
* k8s-node1 (12.12.12.21 / 192.168.0.221) as kubernetes node
* k8s-node2 (12.12.12.22 / 192.168.0.222) as kubernetes node

Connect on k8s-ansible and prepare the VM to deploy Kubernetes :

    cd ~
    cp -R /home/temp/* .
    sudo rm -R /home/temp
    cd deeploy/ansible/kubespray/
    ./prepare_manager_vm.sh

Once it's done, you can launch ansible deployment with this script :
    
    ./run_k8s_install.sh
Wait some minutes. If all it's ok you'll have this kind of return :

    ..........
    PLAY RECAP *****************************************************************
    k8s-master                 : ok=375  changed=115  unreachable=0    failed=0
    k8s-node1                  : ok=284  changed=86   unreachable=0    failed=0
    k8s-node2                  : ok=282  changed=86   unreachable=0    failed=0
    localhost                  : ok=1    changed=0    unreachable=0    failed=0
    ..........

Now, we are going to finalize the dashboard credential. Connect on k8s-master :

    cd ~
    git clone https://github.com/peploleum/deeploy
    cd deeploy/ansible/kubespray/
    ./create_dashboard_access.sh

This script create kubecfg.p12 and token.txt. To test dashboard :

* Copy these files on your machine.
* Launch your web browser and import certificate file \( kubecfg.p12 \)
* Restart your web browser and go on [Kubernetes Dashboard](https://192.168.0.220:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy)
* Connect using token in the file token.txt

That's all folks!

