# Author: Nicolas Nunez
# Description: Download Zookeeper binaries

echo "Running install.sh..."
ZOO_USER=${1}
ZOO_USER_HOME=${2}
ZOO_INSTALL_NAME=${3}
TEMP_INSTALL_DIR=${4}
ZOO_BIN="apache-${ZOO_INSTALL_NAME}-bin"
ZOO_TGZ="${ZOO_BIN}.tar.gz"
mkdir -p ${TEMP_INSTALL_DIR}
mkdir -p ${ZOO_DATA_DIR} ${ZOO_DATA_LOG_DIR} ${ZOO_DATA_LOG_DIR}
chown -R ${ZOO_USER}:${ZOO_USER} ${TEMP_INSTALL_DIR}
chmod -R 755 ${TEMP_INSTALL_DIR}
chown -R ${ZOO_USER}:${ZOO_USER} ${ZOO_DATA_BASE}
chmod -R 755 ${ZOO_DATA_BASE}
cd ${TEMP_INSTALL_DIR} && wget https://dlcdn.apache.org/zookeeper/${ZOO_INSTALL_NAME}/${ZOO_TGZ}
tar -xzf ${TEMP_INSTALL_DIR}/${ZOO_TGZ} --directory $ZOO_USER_HOME
cd $ZOO_USER_HOME
mv ${ZOO_USER_HOME}/${ZOO_BIN} ${ZOO_USER_HOME}/${ZOO_INSTALL_NAME}
chown -R ${ZOO_USER}:${ZOO_USER} ${ZOO_USER_HOME}/${ZOO_INSTALL_NAME}
chmod -R 755 ${ZOO_USER_HOME}/${ZOO_INSTALL_NAME}



