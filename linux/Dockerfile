FROM oraclelinux:9
ARG JAVA_VERSION=11
ARG SCALA_VERSION=2.13.10
COPY enhance.sh /tmp
WORKDIR /tmp
RUN sh enhance.sh $JAVA_VERSION $SCALA_VERSION