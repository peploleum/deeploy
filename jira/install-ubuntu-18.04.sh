#!/usr/bin/env bash

set -x
#choose option 2 (custom) for the most control.
INSTALL_TYPE=2
#this is where Jira will be installed.
DESTINATION_DIRECTORY=/usr/share/jira
#this is where Jira data like logs, search indexes and files will be stored.
HOME_DIRECTORY=/usr/share/jira/home
mkdir dist && cd dist
mkdir $DESTINATION_DIRECTORY
wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.0.2-x64.bin
chmod a+x atlassian-jira-software-8.0.2-x64.bin
sudo ./atlassian-jira-software-8.0.2-x64.bin