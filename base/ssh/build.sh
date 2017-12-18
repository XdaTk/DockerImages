#!/usr/bin/env bash

NAME=ssh
VERSION=v1

docker build -t registry.ops.heptagram.tech/devops/kubernetes/dockerimages/${NAME}:${VERSION} .

docker push registry.ops.heptagram.tech/devops/kubernetes/dockerimages/${NAME}:${VERSION}