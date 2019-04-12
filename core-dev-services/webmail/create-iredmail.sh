#!/bin/bash

VBoxManage createvm --name iredmailserver --ostype Ubuntu_64 --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm iredmailserver --memory 4096 --cpus 4 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/iredmailserver.vdi --size 20000
VBoxManage storagectl iredmailserver --name "IDE Controller" --add ide
VBoxManage storageattach iredmailserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/iredmailserver.vdi
VBoxManage storageattach iredmailserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/ubuntu-18.04.2-live-server-amd64.iso

VBoxManage modifyvm iredmailserver --vrde on

VBoxManage startvm iredmailserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

