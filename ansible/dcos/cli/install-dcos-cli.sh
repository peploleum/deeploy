#!/bin/bash

# This script installs DCOS 1.12 CLI
if [ $# -lt 1 ]; then
  echo "Usage: $0 DCOS_MASTER_FQDN"
  echo
  echo DCOS_MASTER_FQDN must be:
  echo "  • valid"
  echo "  • example: https://dcos-master.peploleum.com"
  echo
  echo  echo "Examples:"
  echo "  • $0 dcos-master.peploleum.com"
  exit 1
fi
# creating working directory
[ -d usr/local/bin ] || sudo mkdir -p /usr/local/bin

# downloading package
curl https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.12/dcos -o dcos

# move CLI binary to bin directory
sudo mv dcos /usr/local/bin

# make CLI binary executable
chmod +x /usr/local/bin/dcos

#set up connection to master
dcos cluster setup http://$1
