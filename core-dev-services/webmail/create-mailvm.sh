#!/bin/bash

VBoxManage createvm --name mailserver --ostype Linux_64 --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm mailserver --memory 4096 --cpus 2 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/mailserver.vdi --size 50000
VBoxManage storagectl mailserver --name "IDE Controller" --add ide
VBoxManage storageattach mailserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/mailserver.vdi
VBoxManage storageattach mailserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/CentOS-7-x86_64-DVD-1810.iso

VBoxManage modifyvm mailserver --vrde on

VBoxManage startvm mailserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

