#!/bin/bash

# Enable IPv4 Forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i '29i net.ipv4.ip_forward=1' /etc/sysctl.conf
