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


### DeployParameterOpenstack :

Execute shell DeployParamOpenstack.sh in openstack-controller.

### Create instance Openstack :

Execute shell CreateInstance.sh in openstack-controller.

### Add new compute node :

Execute shell DeployComputeNode.sh in new node compute.
        
        param 1 : nom du controlleur openstack
        param 2 : ip du controlleur openstack
        param 3 : nom de l\'interface du reseau physique du compute node
        param 4 : ip du compute openstack

### Enrolment new node :

Execute shell EnrolmentNode.sh in openstack-controller.

