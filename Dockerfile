ARG BASE_IMAGE=lustefaniak/graalvm:11-20.2.0-1af49265af5e0a15b55ae7a78fc3640c7e8e5493
FROM ${BASE_IMAGE}

ARG SBT_VERSION=1.3.12
ENV SBT_VERSION ${SBT_VERSION}
ARG SBT_LAUNCHER_VERSION=${SBT_VERSION}
ARG SBT_LAUNCHER_URL="https://github.com/sbt/sbt/releases/download/v$SBT_LAUNCHER_VERSION/sbt-$SBT_LAUNCHER_VERSION.tgz"
ARG SCALA_VERSION=2.13.2
ENV SCALA_VERSION=${SCALA_VERSION}
ARG SBT_HOME=/usr/local/sbt
ENV SBT_HOME ${SBT_HOME}
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN apk add --no-cache curl bash bc git openssh-client jq

RUN echo "Downloading ${SBT_LAUNCHER_URL}" && curl -sL ${SBT_LAUNCHER_URL} | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && rm -rf /usr/local/lib/local-preloaded

RUN mkdir -p src/main/scala project && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && echo "object P" > project/P.scala && sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && rm -r -f src target project

WORKDIR /app
