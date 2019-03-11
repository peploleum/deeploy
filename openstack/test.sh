#!/usr/bin/expect

spawn openstack user create --domain default --password-prompt superman
#expect "*assword:" { send "$password\n"}
expect "User Password:" {send "root\n"}
