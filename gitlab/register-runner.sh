#!/bin/bash

echo param 1 : gitlab-runner container id
echo param 2 : gitlab ip
echo param 3 : register token

sudo docker exec -it $1  gitlab-runner register --non-interactive --executor "docker" --docker-image docker:latest --url "http://$2:9080" --registration-token "$3" --description "graphy-runner" --tag-list "graphy,docker" --run-untagged --locked="false" --docker-extra-hosts="gitlab.peploleum.com:$2"