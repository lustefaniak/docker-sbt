ARG BASE_IMAGE=lustefaniak/graalvm:11-20.2.0-d09b66f38a61439502b9d82359565e079eb5bdeb

FROM alpine:3.12.1 AS build
ARG SBT_VERSION=1.4.2
ARG SBT_LAUNCHER_VERSION=${SBT_VERSION}
ARG SBT_LAUNCHER_URL="https://github.com/sbt/sbt/releases/download/v$SBT_LAUNCHER_VERSION/sbt-$SBT_LAUNCHER_VERSION.tgz"
ARG SCALA_VERSION=2.13.3

RUN apk add --no-cache curl

RUN echo "Downloading launcher ${SBT_LAUNCHER_VERSION} from ${SBT_LAUNCHER_URL}" && curl -sL ${SBT_LAUNCHER_URL} | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && rm -rf /usr/local/lib/local-preloaded

RUN ls -al /usr/local/
RUN ls -al /usr/local/bin
RUN ls -al /usr/local/conf

FROM ${BASE_IMAGE}
ENV SBT_VERSION ${SBT_VERSION}
ENV SCALA_VERSION=${SCALA_VERSION}
ENV PATH ${PATH}:/usr/local/sbt

COPY --from=build /usr/local /usr

ARG PLATFORM_DEPS="echo No platform dependencies"
RUN sh -c "${PLATFORM_DEPS}"

RUN mkdir -p /tmp/sbt-precompile/src/main/scala /tmp/sbt-precompile/project && cd /tmp/sbt-precompile && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && echo "object P" > project/P.scala && SBT_OPTS="-Xmx2G -Duser.timezone=GMT" sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && cd / && rm -r -f /tmp/sbt-precompile

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/sbt"]