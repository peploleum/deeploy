#!/bin/bash

# This script launch pull request to the nexus.

nexusIp=10.0.0.11
nexusPort=8081
nexusDockerPort=9082

## DOCKER Pull
docker login ${nexusIp}:${nexusDockerPort}

docker pull ${nexusIp}:${nexusDockerPort}/elasticsearch/elasticsearch-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/kibana/kibana-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/logstash/logstash-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/apm/apm-server-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/auditbeat-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/filebeat-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/heartbeat-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/journalbeat-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/metricbeat-oss:6.6.2
docker pull ${nexusIp}:${nexusDockerPort}/beats/packetbeat-oss:6.6.2

docker pull ${nexusIp}:${nexusDockerPort}/sonarqube:7.6-community

docker pull ${nexusIp}:${nexusDockerPort}/gitlab/gitlab-ce:11.9.1-ce.0
docker pull ${nexusIp}:${nexusDockerPort}/gitlab/gitlab-runner:v11.9.1

docker pull ${nexusIp}:${nexusDockerPort}/sonatype/nexus3:3.15.2

docker pull ${nexusIp}:${nexusDockerPort}/mongo:3.6.11-xenial
docker pull ${nexusIp}:${nexusDockerPort}/cassandra:3.11.4
docker pull ${nexusIp}:${nexusDockerPort}/redis:4.0.14
docker pull ${nexusIp}:${nexusDockerPort}/mariadb:10.2.23
docker pull ${nexusIp}:${nexusDockerPort}/postgres:9.6.12
## Janusgraph (pas de repos docker officiel)
#docker pull ${nexusIp}:${nexusDockerPort}/janusgraph:0.3.1


