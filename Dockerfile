#
# SBT image based on Oracle JRE 8
# Based on https://github.com/1science/docker-sbt

FROM 1science/java:oracle-jre-8
MAINTAINER Lukas Stefaniak <lustefaniak@gmail.com>

ENV SBT_VERSION 0.13.16
ENV SCALA_VERSION 2.12.3
ENV SCALA_2_10_VERSION 2.10.6
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin
ENV JAVA_OPTS -Xmx2g

# Install sbt
RUN curl -sL "https://cocl.us/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && mkdir $HOME/.sbt && mv /usr/local/lib/local-preloaded $HOME/.sbt/preloaded

RUN mkdir -p src/main/scala && echo "object A" > src/main/scala/A.scala && sbt 'set scalaVersion:="'${SCALA_2_10_VERSION}'"' compile && sbt 'set scalaVersion:="'${SCALA_VERSION}'"' compile && rm -r -f src target project

WORKDIR /app
