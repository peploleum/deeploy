#!/usr/bin/env bash

. ../../docker.conf
. ../nexus.conf

export IMAGE=python:3.6.8-alpine3.9
export SOURCE=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PULL_PORT/$IMAGE
export TARGET=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PUSH_PORT/$IMAGE

# Update pip.conf file
sed -i -e "s/##NEXUS_HOST##/$NEXUS_HOST/g" pip.conf
sed -i -e "s/##NEXUS_PORT##/$NEXUS_PORT/g" pip.conf

echo $SOURCE
echo $TARGET
docker build -t $IMAGE --build-arg IMAGE=$SOURCE --build-arg NEXUS_HOST=$NEXUS_HOST --build-arg NEXUS_PORT=$NEXUS_PORT --no-cache .
docker tag $IMAGE $TARGET
docker login $DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PUSH_PORT -u $DOCKER_PRIVATE_REGISTRY_USER -p $DOCKER_PRIVATE_REGISTRY_PASSWORD

echo pushing $TARGET
docker push $TARGET
