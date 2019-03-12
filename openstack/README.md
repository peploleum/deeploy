# DEEPLOY

## Openstack

### Warning
* The password to enter is "**root**".

### Prerequisites :  
* Logging in openstack-controller
* Verify admin-openrc

### Install controller node :
#### Prerequisites :
* Install Ubuntu 18.04 server
* Execute sudo apt-get update
* Execute sudo apt-get upgrade

The controller node is accessible in ssh.

Execute the command :

        git clone https://github.com/peploleum/deeploy.git
        cd deeploy/openstack/
        sudo chmod +x deploy_controller_node.sh

Execute shell deploy_controller_node.sh in controller node.
        
        param 1 : nom du controlleur openstack
        param 2 : ip du controlleur openstack
        param 3 : nom du compute node openstack
        param 4 : ip du compute node openstack
        param 5 : nom de l'interface du reseau physique

### Add new compute node :
#### Prerequisites :
* Install Ubuntu 18.04 server
* Execute sudo apt-get update
* Execute sudo apt-get upgrade

The new compute node is accessible in ssh.

Execute the command :

        git clone https://github.com/peploleum/deeploy.git
        cd deeploy/openstack/
        sudo chmod +x deploy_compute_node.sh
        
Execute shell deploy_compute_node.sh in new compute node.
        
        param 1 : nom du controlleur openstack
        param 2 : ip du controlleur openstack
        param 3 : nom de l'interface du reseau physique du compute node
        param 4 : ip du compute node openstack

#### New node enrolment :

Execute the command on controller openstack:
        
        sudo chmod +x enrolment_node.sh

Execute shell enrolment_node.sh in openstack-controller.
Uncomment discover_hosts_in_cells_interval in etc/nova/nova.conf

### Init Openstack :
#### General
This script initialize Network, Security Group, KeyPair, Flavor and Image.

Execute script deploy_param_openstack.sh in openstack-controller.

        param 1 : Public network CIDR -- ex: 192.168.0.0/16
        param 2 : Public network start pool -- ex: 192.168.0.101
        param 3 : Public network end pool -- ex: 192.168.0.250
        param 4 : Public network gateway -- ex: 192.168.0.1
        param 5 : Public network DNS -- ex: 66.28.0.45        

#### Private network
Create all your customs privates networks using script create_private_network.sh

        param 1 : Network name -- ex : sandbox
        param 2 : IP range -- ex : 10.0.10.0/24
        param 3 : Start -- ex : 10.0.10.10
        param 4 : End -- ex : 10.0.10.250

### Create instance Openstack :

This script launch a new Virtual Machine.

sudo chmod +x create_instance.sh

Execute script create_instance.sh in openstack-controller.

        param 1 : Flavor name -- ex : Small
        param 2 : Image name -- ex : Ubuntu-16.04
        param 3 : Network name -- ex : sandbox
        param 4 : Private Instance IP -- ex : 10.0.10.113
        param 5 : Public Floating IP -- ex : 192.168.0.113
        param 6 : Instance name -- ex : instance04

example : ./create_instance.sh custom Ubuntu_16.04 sandbox 12.12.12.12 192.168.0.112 sampleServer

### Create new Image from ISO file

Follow these steps on the openstack-controller
 * Install packages and param user

        sudo apt-get install -y qemu-kvm libvirt-bin virtinst virt-manager libguestfs-tools
        sudo adduser $USER libvirt
 * Download ISO

        Example : curl http://ro.releases.ubuntu.com/releases/16.04.5/ubuntu-16.04.5-server-amd64.iso --output ubuntu-16.04.5-server-amd64.iso
* Launch virt-manager
        
        sudo virt-manager

* Use the UI to install OS. You can use this guide for help (https://docs.openstack.org/image-guide/create-images-manually.html)

* Clean up the image

        sudo virt-sysprep -d IMAGE_NAME
* Upload image on Openstack

        openstack image create --name IMAGE_NAME --disk-format qcow2 --min-disk MIN_DISK_SIZE --min-ram MIN_RAM_SIZE --file IMAGE_QCOW2 --public
        
        IMAGE_NAME : The name of the image
        MIN_DISK_SIZE : Amount of disk space in GB that is required to boot the image
        MIN_RAM_SIZE : Amount of RAM in MB that is required to boot the image
        IMAGE_QCOW2 : .qcow2 file generated previously

## Links

[Openstack webUI](http://192.168.0.10/horizon/identity/)

