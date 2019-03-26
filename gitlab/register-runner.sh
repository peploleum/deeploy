#!/bin/bash

set -x
if [ $# -lt 5 ]; then
  echo "Usage: $0 GITLAB_RUNNER_CONTAINER_ID GITLAB_PROJECT_NAME GITLAB_HOST_IP REGISTER_TOKEN GITLAB_HOST_FQDN"
  echo
  echo GITLAB_RUNNER_CONTAINER_ID must be:
  echo "  • valid running gitlab container ID"
  echo
  echo GITLAB_PROJECT_NAME must meet the following:
  echo "  • existing valid project name"
  echo
  echo GITLAB_HOST_IP must meet the following:
  echo "  • Gitlab host IP"
  echo "  • valid IP v4"
  echo
  echo REGISTER_TOKEN must meet the following:
  echo "  • valid register token for project"
  echo
  echo GITLAB_HOST_FQDN must meet the following:
  echo "  • valid fully qualified domain name of gitlab host"
  echo
  echo  echo "Examples:"
  echo "  • $0 12 insight 10.0.0.32 121221 gitlab.peploleum.com"
  exit 1
fi
echo param 1 : gitlab-runner container id
echo param 2 : project name
echo param 3 : gitlab ip
echo param 4 : register token

sudo docker exec -it $1  gitlab-runner register --non-interactive --executor "docker" --docker-image docker:latest --url "http://$3:9080" --registration-token "$4" --description "$2-runner" --tag-list "$2,docker" --run-untagged --locked="false" --docker-extra-hosts="$4:$3" --docker-privileged
