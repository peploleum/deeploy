# DCOS


DCOS [website](https://dcos.io/).

#### Deployment

Installing DCOS with Ansible on 3 VMs in an openstack network.

Check 'dcos.conf' and modify it if needed.

Then, create the VM with :
    
    ./init-vm.sh

It creates 5 VMs :

* dcos-ansible (12.12.12.128 / 192.168.0.228) as manager
* dcos-bootstrap (12.12.12.129 / 192.168.0.229) as dcos bootstrap node
* dcos-master-01 (12.12.12.130 / 192.168.0.230) as dcos master
* dcos-public-agent (12.12.12.131 / 192.168.0.231) as dcos public agent
* dcos-private-agent (12.12.12.132 / 192.168.0.232) as dcos private agent

Connect on dcos-ansible and prepare the VM to deploy DCOS.

    cd /home/temp/deeploy/ansible/dcos
    
> check dcos.conf and then run:

    ./prepare-manager-vm.sh

Connect to [DCOS Web GUI](http://dcos-master-01/).
