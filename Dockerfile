#
# SBT image based on Oracle JRE 8
# Based on https://github.com/1science/docker-sbt

FROM 1science/java:oracle-jre-8
MAINTAINER Lukas Stefaniak <lustefaniak@gmail.com>

ENV SBT_VERSION 0.13.11
ENV SCALA_VERSION 2.11.8
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

# Install sbt
RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

RUN sbt 'set scalaVersion:="'${SCALA_VERSION}'"' compile && rm -r target && rm -r project

WORKDIR /app
