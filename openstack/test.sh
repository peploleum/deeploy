#!/bin/bash

sudo apt install -y expect

## En cas de problème le programme est arrêté au bout de 20 secondes
set timeout 20

set password root

/usr/bin/expect <<EOD

spawn openstack user create --domain default --password-prompt superman
#expect "*assword:" { send "$password\n"}
#expect "User Password:" {send "root\n"}

expect "Password:"
send "$password\n" 
expect "Password:"
send "$password\n" 
interact
EOD
