#!/usr/bin/env bash

VERSION=1.0.0
NAME=kube

docker build -t registry.ops.heptagram.tech/devops/kubernetes/dockerimages/${NAME}:${VERSION} .

docker push registry.ops.heptagram.tech/devops/kubernetes/dockerimages/${NAME}:${VERSION}