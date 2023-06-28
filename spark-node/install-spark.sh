# Author: Nicolas Nunez
# Description: Download Spark binaries and setup

SCALA_VERSION=${1}
SPARK_VERSION=${2}
HADOOP_VERSION=${3}
SPARK_FULL="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}"
SPARK_TGZ="${SPARK_FULL}.tgz"

wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}.tgz
tar -xvzf ${SPARK_TGZ}
sudo mv ${SPARK_FULL} "spark-${SPARK_VERSION}"
sudo mkdir -p $SPARK_LOG_DIRS
sudo chown -R ${SPARK_USER_UID}:${SPARK_USER_UID} $SPARK_LOG_DIRS
echo "export SPARK_HOME=${HOME}/${SPARK_FULL}" >> ${HOME}/.bash_profile
echo 'PATH=${PATH}:${SPARK_HOME}/bin' >> ${HOME}/.bash_profile
source ${HOME}/.bash_profile
