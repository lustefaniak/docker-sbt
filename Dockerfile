ARG BASE_IMAGE=lustefaniak/graalvm:11-20.3.0
FROM ${BASE_IMAGE}
ARG SCALA_VERSION=2.13.4
ARG SBT_VERSION=1.4.4
ARG SBT_LAUNCHER_VERSION=${SBT_VERSION}
ARG SBT_LAUNCHER_URL="https://github.com/sbt/sbt/releases/download/v$SBT_LAUNCHER_VERSION/sbt-$SBT_LAUNCHER_VERSION.tgz"

RUN curl --retry 3 -fLo /tmp/cs https://git.io/coursier-cli-linux && \
    chmod +x /tmp/cs && \
    /tmp/cs setup --yes --env --install-dir /usr/local/bin/ && \
    rm /tmp/cs

RUN echo "Downloading launcher ${SBT_LAUNCHER_VERSION} from ${SBT_LAUNCHER_URL}" && curl -sL ${SBT_LAUNCHER_URL} | gunzip | tar -x -C /tmp/ && rm -r /usr/local && mv /tmp/sbt /usr/local && rm -rf /usr/local/lib/local-preloaded

RUN apt-get update \
    && apt-get install -y --no-install-recommends git openssh-client jq \
    && rm -rf /var/lib/apt/lists/*

ARG PLATFORM_DEPS="echo No platform dependencies"
RUN sh -c "${PLATFORM_DEPS}"

RUN mkdir -p /tmp/sbt-precompile/src/main/scala /tmp/sbt-precompile/project && cd /tmp/sbt-precompile && echo sbt.version=${SBT_VERSION} > project/build.properties && echo "object A" > src/main/scala/A.scala && echo "object P" > project/P.scala && SBT_OPTS="-Xmx2G -Duser.timezone=GMT" sbt 'set scalaVersion:="'${SCALA_VERSION}'"' ';compile;scalaVersion;sbtVersion' && cd / && rm -r -f /tmp/sbt-precompile

CMD ["/usr/local/bin/sbt"]

WORKDIR /app