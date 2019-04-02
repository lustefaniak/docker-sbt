#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u lustefaniak --password-stdin

FULL_VERSION=$(git describe --tags)
VERSION=${FULL_VERSION//v}

docker push "lustefaniak/sbt:${BASE}_${SBT_VERSION}_${SCALA_VERSION}_${VERSION}"