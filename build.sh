#!/usr/bin/env bash

if [[ -z "$BASE" ]]; then
    echo "Must provide BASE in environment" 1>&2
    exit 1
fi

if [[ -z "$SBT_VERSION" ]]; then
    echo "Must provide SBT_VERSION in environment" 1>&2
    exit 1
fi

if [[ -z "$SCALA_VERSION" ]]; then
    echo "Must provide SCALA_VERSION in environment" 1>&2
    exit 1
fi


case "$BASE" in
        graalvm)
            BASE_IMAGE=lustefaniak/docker-graalvm:alpine-1.0.0-rc14.0
            ;;
        *)
            echo "Unrecongnized BASE=${BASE}"
            exit 1
esac

FULL_VERSION=$(git describe --tags)
VERSION=${FULL_VERSION//v}


echo "Building using BASE_IMAGE=$BASE_IMAGE SBT_VERSION=$SBT_VERSION SCALA_VERSION=$SCALA_VERSION VERSION=$VERSION"

docker build . --build-arg BASE_IMAGE="${BASE_IMAGE}"  --build-arg SBT_VERSION="$SBT_VERSION" --build-arg SCALA_VERSION="$SCALA_VERSION" -t "lustefaniak/sbt:${BASE}_${SBT_VERSION}_${SCALA_VERSION}_${VERSION}"
