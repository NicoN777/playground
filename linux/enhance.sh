#!/bin/bash
#Author: Nicolas Nunez
#Make system "usable"

JAVA_VERSION=${1}
SCALA_VERSION=${2}
SCALA_RPM="scala-${SCALA_VERSION}.rpm"
dnf update -y
dnf install -y sudo ncurses which unzip man wget tar gcc make expect python3-pip python3-devel libpq-devel libaio hostname
dnf install -y java-${JAVA_VERSION}-openjdk-devel.aarch64
wget https://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_RPM}
dnf install -y ${SCALA_RPM}