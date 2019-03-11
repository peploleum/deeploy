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

### Init image data Openstack :

This script initialize Network, Security Group, KeyPair, Flavor and Image.

Execute script deploy_param_openstack.sh in openstack-controller.

        param 1 : Adresse du sous réseau prive (ex:xxx.xxx.xxx.xxx)
        param 2 : Adresse du sous réseau prive sans le dernier digit (ex:xxx:xxx:xxx)
        param 3 : Adresse de début du reseau public
        param 4 : Adresse de fin du reseau public
        param 5 : Adresse du serveur dns public
        param 6 : Adresse de la passerelle public
        param 7 : Adresse du sous reseau public (ex:xxx.xxx.xxx.xxx)
        param 8 : Digit du masquage du réseau (ex:xx)
        param 9 : Nom de la paire de clés openstack

### Create instance Openstack :

This script launch a new Virtual Machine.

sudo chmod +x create_instance.sh

Execute script create_instance.sh in openstack-controller.

        param 1 : Nom du flavor
        param 2 : Nom de l'image
        param 3 : ID du network
        param 4 : Nom de la paire de cles
        param 5 : Nom de l'instance

example : ./create_instance.sh custom Ubuntu_16.04 20da2941-8676-4f4c-9c05-031ce0305eda INSIGHT docker

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

