#!/usr/bin/env bash

. ../../docker.conf
. ../nexus.conf

# change base image here  (3.6.8-jessie | 3.6.8-alpine3.8)
export VERSION=3.6.8-jessie
export IMAGE=python:$VERSION
export SOURCE=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PULL_PORT/$IMAGE
export TARGET=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PUSH_PORT/$IMAGE

echo $SOURCE
echo $TARGET
(docker build -t $IMAGE --build-arg IMAGE=$IMAGE --build-arg NEXUS_HOST=$NEXUS_HOST --build-arg NEXUS_PORT=$NEXUS_PORT --no-cache .)
if [ "$?" == 0 ] ; then
  docker tag $IMAGE $TARGET
  docker login $DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PUSH_PORT -u $DOCKER_PRIVATE_REGISTRY_USER -p $DOCKER_PRIVATE_REGISTRY_PASSWORD
  echo pushing $TARGET
  docker push $TARGET
else
  echo "failed to build image"
	exit
fi
