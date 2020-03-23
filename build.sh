#!/usr/bin/env bash

if [[ -z "$NAME" ]]; then
    echo "Must provide BASE in environment" 1>&2
    exit 1
fi

if [[ -z "$SBT_VERSION" ]]; then
    echo "Must provide SBT_VERSION in environment" 1>&2
    exit 1
fi

OPTIONAL_SBT_LAUNCHER_VERSION_FLAGS=""
if [[ ! -z "$SBT_LAUNCHER_VERSION" ]]; then
    OPTIONAL_SBT_LAUNCHER_VERSION_FLAGS="--build-arg SBT_LAUNCHER_VERSION=${SBT_LAUNCHER_VERSION}"
fi

if [[ -z "$SCALA_VERSION" ]]; then
    echo "Must provide SCALA_VERSION in environment" 1>&2
    exit 1
fi

if [[ -z "$VERSION" ]]; then
    FULL_VERSION=$(git describe --tags)
    VERSION=${FULL_VERSION//v}
fi

echo "Building using NAME=$NAME BASE_IMAGE=$BASE_IMAGE SBT_VERSION=$SBT_VERSION SBT_LAUNCHER_VERSION=$SBT_LAUNCHER_VERSION SCALA_VERSION=$SCALA_VERSION VERSION=$VERSION"

docker build . --build-arg BASE_IMAGE="${BASE_IMAGE}"  --build-arg SBT_VERSION="$SBT_VERSION" --build-arg SCALA_VERSION="$SCALA_VERSION" $OPTIONAL_SBT_LAUNCHER_VERSION_FLAGS -t "lustefaniak/sbt:${NAME}_${SBT_VERSION}_${SCALA_VERSION}_${VERSION}"