#!/bin/bash
set -x
if [ $# -lt 1 ]; then
  echo "Usage: $0 GITLAB_HOST_FQDN"
  echo
  echo GITLAB_HOST_FQDN must be:
  echo "  • valid FQDN of gitlab host"
  echo
  echo  echo "Examples:"
  echo "  • $0 ipaserver.peploleum.com"
  exit 1
fi
export GITLAB_HOST_FQDN=$1

docker-compose -f gitlab.yml up -d
