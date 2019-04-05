#!/bin/bash

# This script launch pull request to the nexus.

nexus-ip=10.0.0.11
nexus-port=8081
nexus-docker-port=9082

## DOCKER Pull
docker login $nexus-ip:$nexus-docker-port

docker pull $nexus-ip:$nexus-docker-port/elasticsearch/elasticsearch-oss:6.6.2
