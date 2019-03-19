# KUBESPRAY

This recipe describes how to install kubernetes with Ansible on 3 VM in an openstack network.

First, you need to check 'kubespray.conf' and modify it if needed.

Then, create the VM with :
    
    ./init_vm.sh

It creates 4 VM :

* k8s-ansible (10.0.0.25 / 192.168.0.125) as manager
* kubernetes-master (10.0.0.20 / 192.168.0.120) as kubernetes controller
* kubernetes-node-01 (10.0.0.21 / 192.168.0.121) as kubernetes node
* kubernetes-node-02 (10.0.0.22 / 192.168.0.122) as kubernetes node

Connect on k8s-ansible and prepare the VM to deploy Kubernetes :

    cd ~
    cp -R /home/temp/* .
    sudo rm -R /home/temp
    cd deeploy/ansible/kubespray/

Check 'kubespray.conf' or copy the file create at the first step then launch :

    ./prepare_manager_vm.sh

Once it's done, you can launch ansible deployment with this script :
    
    ./run_k8s_install.sh

Wait some minutes. If all it's ok you'll have this kind of return :

    ..........
    PLAY RECAP *****************************************************************
    kubernetes-master                 : ok=375  changed=115  unreachable=0    failed=0
    kubernetes-node-01                : ok=284  changed=86   unreachable=0    failed=0
    kubernetes-node-02                : ok=282  changed=86   unreachable=0    failed=0
    localhost                         : ok=1    changed=0    unreachable=0    failed=0
    ..........

Now, we are going to finalize the dashboard credential. Connect on kubernetes-master :

    cd ~
    git clone https://github.com/peploleum/deeploy
    cd deeploy/ansible/kubespray/
    ./create_dashboard_access.sh

This script create kubecfg.p12 and token.txt. To test dashboard :

* Copy these files on your machine.
* Launch your web browser and import certificate file \( kubecfg.p12 \)
* Restart your web browser and go on [Kubernetes Dashboard](https://192.168.0.120:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy)
* Connect using token in the file token.txt

That's all folks!

