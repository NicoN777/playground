# Author: Nicolas Nunez
# Description: Download Kafka binaries and setup

SCALA_VERSION=${1}
KAFKA_VERSION=${2}
KAFKA_FULL="kafka_${SCALA_VERSION}-${KAFKA_VERSION}"
KAFKA_TGZ="${KAFKA_FULL}.tgz"

wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_TGZ}
tar -xvzf ${KAFKA_TGZ}
sudo mkdir -p $KAFKA_LOG_DIRS
sudo chown -R ${KAFKA_USER_UID}:${KAFKA_USER_UID} $KAFKA_LOG_DIRS
echo "export KAFKA_HOME=${HOME}/${KAFKA_FULL}" >> ${HOME}/.bash_profile
echo 'PATH=${PATH}:${KAFKA_HOME}/bin' >> ${HOME}/.bash_profile
source ${HOME}/.bash_profile
