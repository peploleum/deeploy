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


