#!/bin/bash

VBoxManage createvm --name proxyserver --ostype Linux_64 --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm proxyserver --memory 8192 --cpus 4 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/proxyserver.vdi --size 1000000
VBoxManage storagectl proxyserver --name "IDE Controller" --add ide
VBoxManage storageattach proxyserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/proxyserver.vdi
VBoxManage storageattach proxyserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/CentOS-7-x86_64-DVD-1810.iso

VBoxManage modifyvm proxyserver --vrde on

VBoxManage startvm proxyserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"
