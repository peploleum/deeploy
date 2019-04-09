#!/bin/bash

VBoxManage createvm --name ipaserver --ostype Ubuntu_64 --register

VBoxManage modifyvm ipaserver --memory 2048 --cpus 2 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eno1

VBoxManage createmedium disk --filename ~/ipaserver.vdi --size 20000
VBoxManage storagectl ipaserver --name "IDE Controller" --add ide
VBoxManage storageattach ipaserver --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/ipaserver.vdi
VBoxManage storageattach ipaserver --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/ubuntu-18.04.2-live-server-amd64.iso

VBoxManage modifyvm ipaserver --vrde on

VBoxManage --startvm ipaserver --type headless

echo "You can connect to the VM with Remote Desktop on the host IP address to finish the installation !"

