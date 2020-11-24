ARG BASE_IMAGE=lustefaniak/graalvm:11-20.3.0
FROM ${BASE_IMAGE}
ARG SCALA_VERSION=2.13.4
ARG SBT_VERSION=1.4.4

RUN curl -fLo /tmp/cs https://git.io/coursier-cli-linux && \
    chmod +x /tmp/cs && \
    /tmp/cs setup --yes --env --install-dir /usr/local/bin/ && \
    rm /tmp/cs

RUN apt-get update \
    && apt-get install -y --no-install-recommends git openssh-client jq \
    && rm -rf /var/lib/apt/lists/*

ARG PLATFORM_DEPS="echo No platform dependencies"
RUN sh -c "${PLATFORM_DEPS}"

RUN mkdir -p /tmp/sbt-precompile/src/main/scala /tmp/sbt-precompile/project && cd /tmp/sbt-precompile && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && echo "object P" > project/P.scala && SBT_OPTS="-Xmx2G -Duser.timezone=GMT" sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && cd / && rm -r -f /tmp/sbt-precompile

ENTRYPOINT ["/usr/local/bin/sbt"]

WORKDIR /app