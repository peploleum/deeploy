#!/bin/bash

echo param 1 : gitlab-runner container id
echo param 2 : project name
echo param 3 : gitlab ip
echo param 4 : register token

sudo docker exec -it $1  gitlab-runner register --non-interactive --executor "docker" --docker-image docker:latest --url "http://$3:9080" --registration-token "$4" --description "$2-runner" --tag-list "$2,docker" --run-untagged --locked="false" --docker-extra-hosts="gitlab.peploleum.com:$3" --docker-privileged
