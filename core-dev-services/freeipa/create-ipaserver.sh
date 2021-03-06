#!/bin/bash

VBoxManage createvm --name ipaserver --ostype Linux_64 --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm ipaserver --memory 4096 --cpus 4 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/ipaserver.vdi --size 30000
VBoxManage storagectl ipaserver --name "IDE Controller" --add ide
VBoxManage storageattach ipaserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/ipaserver.vdi
VBoxManage storageattach ipaserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/CentOS-7-x86_64-DVD-1810.iso

VBoxManage modifyvm ipaserver --vrde on

VBoxManage startvm ipaserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

