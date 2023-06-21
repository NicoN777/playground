# Author: Nicolas Nunez
# Description: Download Confluent Platform binaries and setup

CONFLUENT_PLATFORM_VERSION_MAJOR=${1}
CONFLUENT_PLATFORM_VERSION_MINOR=${2}
CONFLUENT_PLATFORM_VERSION_PATCH=${3}
CONFLUENT_PLATFORM_FULL=${4}
CONFLUENT_TGZ="${CONFLUENT_PLATFORM_FULL}.tar.gz"

curl -O https://packages.confluent.io/archive/${CONFLUENT_PLATFORM_VERSION_MAJOR}.${CONFLUENT_PLATFORM_VERSION_MINOR}/${CONFLUENT_PLATFORM_FULL}.tar.gz
tar xzf ${CONFLUENT_TGZ}
sudo mkdir -p $KAFKA_LOG_DIRS
sudo chown -R ${CONFLUENT_USER_UID}:${CONFLUENT_USER_UID} $KAFKA_LOG_DIRS
echo "export CONFLUENT_HOME=${HOME}/${CONFLUENT_PLATFORM_FULL}" >> ${HOME}/.bash_profile
echo 'PATH=${PATH}:${CONFLUENT_HOME}/bin' >> ${HOME}/.bash_profile
source ${HOME}/.bash_profile
