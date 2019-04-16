#!/bin/bash

VBoxManage createvm --name mail01 --ostype Debian --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm mail01 --memory 4096 --cpus 4 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/mail01.vdi --size 20000
VBoxManage storagectl mail01 --name "IDE Controller" --add ide
VBoxManage storageattach mail01 --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/mail01.vdi
VBoxManage storageattach mail01 --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/CentOS-7-x86_64-DVD-1810.iso

VBoxManage modifyvm mail01 --vrde on

VBoxManage startvm mail01 --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

