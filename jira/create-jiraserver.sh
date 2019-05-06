#!/bin/bash

VBoxManage createvm --name jiraserver --ostype Linux_64 --register

# Trouble during ipa-server-install if less than 4Go RAM and 4 cpu
VBoxManage modifyvm jiraserver --memory 6144 --cpus 4 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/jiraserver.vdi --size 50000
VBoxManage storagectl jiraserver --name "IDE Controller" --add ide
VBoxManage storageattach jiraserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/jiraserver.vdi
VBoxManage storageattach jiraserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/CentOS-7-x86_64-DVD-1810.iso

VBoxManage modifyvm jiraserver --vrde on

VBoxManage startvm jiraserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

