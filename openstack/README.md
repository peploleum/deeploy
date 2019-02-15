# deeploy

## Openstack

### Prerequisites :  
* Logging in openstack-controller
* copy the following files :

        admin-openrc
        DeployParamOpenstack.sh
        CreateInstance.sh
        EnrolmentNode.sh
        UserData_addRepo.sh
        DeployComputeNode.sh
* Verify admin-openrc

### DeployParameterOpenstack :

Execute script DeployParamOpenstack.sh in openstack-controller.

### Create instance Openstack :

Execute script CreateInstance.sh in openstack-controller.

### Add new compute node :
#### Prerequisites :
* Install Ubuntu 18.04 server
* Execute sudo apt-get update
* Execute sudo apt-get upgrade

The new compute node is accessible in ssh.

Execute the command :

        git clone https://github.com/peploleum/deeploy.git
        cd deeploy/openstack/
        sudo chmod 777 DeployComputeNode.sh
        
Execute shell DeployComputeNode.sh in new compute node.
        
        param 1 : nom du controlleur openstack
        param 2 : ip du controlleur openstack
        param 3 : nom de l\'interface du reseau physique du compute node
        param 4 : ip du compute node openstack

### Enrolment new node :

Execute the command on controller openstack:
        
        sudo chmod 777 EnrolmentNode.sh

Execute shell EnrolmentNode.sh in openstack-controller.

