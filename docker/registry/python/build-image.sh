#!/usr/bin/env bash

export SOURCE=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PULL_PORT/python:3.6.8-alpine3.9
export TARGET=$DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PUSH_PORT/python:3.6.8-alpine3.9

echo $SOURCE
echo $TARGET
docker build -t $TARGET --build-arg IMAGE=$SOURCE .
docker login $DOCKER_PRIVATE_REGISTRY_HOST:$DOCKER_PRIVATE_REGISTRY_PULL_PORT -u $DOCKER_PRIVATE_REGISTRY_USER -p $DOCKER_PRIVATE_REGISTRY_PASSWORD

echo pushing $TARGET
docker push $TARGET
