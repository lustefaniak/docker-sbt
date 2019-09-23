ARG BASE_IMAGE=lustefaniak/docker-graalvm:alpine-19.2.0.1
FROM ${BASE_IMAGE}

ARG SBT_VERSION=1.3.2
ENV SBT_VERSION ${SBT_VERSION}
ARG SBT_LAUNCHER_VERSION=${SBT_VERSION}
ARG SCALA_VERSION=2.12.10
ENV SCALA_VERSION=${SCALA_VERSION}
ARG SBT_HOME=/usr/local/sbt
ENV SBT_HOME ${SBT_HOME}
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN apk add --no-cache curl bash bc git openssh

RUN curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_LAUNCHER_VERSION/sbt-$SBT_LAUNCHER_VERSION.tgz" | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && mkdir $HOME/.sbt && mv /usr/local/lib/local-preloaded $HOME/.sbt/preloaded

RUN mkdir -p src/main/scala project && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && rm -r -f src target project

WORKDIR /app
