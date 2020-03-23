#!/bin/bash

if [[ -z "$VERSION" ]]; then
    FULL_VERSION=$(git describe --tags)
    VERSION=${FULL_VERSION//v}
fi

docker push "lustefaniak/sbt:${NAME}_${SBT_VERSION}_${SCALA_VERSION}_${VERSION}"
docker tag "lustefaniak/sbt:${NAME}_${SBT_VERSION}_${SCALA_VERSION}_${VERSION}" "lustefaniak/sbt:${NAME}_${SBT_VERSION}_${SCALA_VERSION}"
docker push "lustefaniak/sbt:${NAME}_${SBT_VERSION}_${SCALA_VERSION}"