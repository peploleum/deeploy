#!/usr/bin/env bash

set -x
mkdir dist && cd dist
wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.0.2-x64.bin
chmod a+x atlassian-jira-software-8.0.2-x64.bin
sudo ./atlassian-jira-software-8.0.2-x64.bin
