ARG BASE_IMAGE=lustefaniak/graalvm:11-20.2.0-da3a89f4b20c1098726188961b3ea20aa28191aa
FROM ${BASE_IMAGE}

ARG SBT_VERSION=1.4.2
ENV SBT_VERSION ${SBT_VERSION}
ARG SBT_LAUNCHER_VERSION=${SBT_VERSION}
ARG SBT_LAUNCHER_URL="https://github.com/sbt/sbt/releases/download/v$SBT_LAUNCHER_VERSION/sbt-$SBT_LAUNCHER_VERSION.tgz"
ARG SCALA_VERSION=2.13.3
ENV SCALA_VERSION=${SCALA_VERSION}
ARG SBT_HOME=/usr/local/sbt
ENV SBT_HOME ${SBT_HOME}
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN echo "Downloading launcher ${SBT_LAUNCHER_VERSION} from ${SBT_LAUNCHER_URL}" && curl -sL ${SBT_LAUNCHER_URL} | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && rm -rf /usr/local/lib/local-preloaded

RUN mkdir -p /tmp/sbt-precompile/src/main/scala /tmp/sbt-precompile/project && cd /tmp/sbt-precompile && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && echo "object P" > project/P.scala && SBT_OPTS="-Xmx2G -Duser.timezone=GMT" sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && cd / && rm -r -f /tmp/sbt-precompile

WORKDIR /app
