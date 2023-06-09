FROM toastyboii/base-ol9-node:v0.0.1
ARG DOCKER_HOST_IP
ARG ZOO_USER=zookeeper
ARG ZOO_USER_UID=1000
ARG ZOO_USER_HOME=/home/$ZOO_USER
ARG ZOO_VERSION=3.8.1
ARG ZOO_INSTALL_NAME="zookeeper-"$ZOO_VERSION
ARG TEMP_INSTALL_DIR="/tmp/zookeeper"
ARG DATA_BASE_DIR="/var/lib/${ZOO_INSTALL_NAME}"
ENV ZOO_HOME="${ZOO_USER_HOME}/${ZOO_INSTALL_NAME}"
ENV ZOO_CONF_DIR=${ZOO_HOME}/conf \
    ZOO_DATA_BASE=${DATA_BASE_DIR} \
    ZOO_DATA_DIR=${DATA_BASE_DIR}/data \
    ZOO_DATA_LOG_DIR=${DATA_BASE_DIR}/datalog \
    ZOO_LOG_DIR=${DATA_BASE_DIR}/logs \
    ZOO_CLIENT_PORT=2181 \
    ZOO_SECURE_CLIENT_PORT=2182 \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60 \
    ZOO_STANDALONE_ENABLED=true \
    ZOO_ADMINSERVER_ENABLED=true \
    PATH="${PATH}:${ZOO_HOME}/bin"
ENV DOCKER_HOST_IP=$DOCKER_HOST_IP
ENV TLS_DIR="${ZOO_USER_HOME}"/tls
ENV SSL_KEYSTORE_PASS="${ZOO_KEYSTORE_PASS:-changeit}"
ENV SSL_TRUSTSTORE_PASS="${ZOO_TRUSTSTORE_PASS:-changeit}"
COPY user.sh /tmp
RUN sh /tmp/user.sh $ZOO_USER $ZOO_USER_UID
COPY install.sh /tmp
RUN sh /tmp/install.sh $ZOO_USER $ZOO_USER_HOME $ZOO_INSTALL_NAME $TEMP_INSTALL_DIR
USER $ZOO_USER
WORKDIR $ZOO_USER_HOME
RUN sudo mkdir -p ${TLS_DIR} && sudo chown -R ${ZOO_USER_UID}:${ZOO_USER_UID} ${TLS_DIR}
RUN sudo chown -R ${ZOO_USER_UID}:${ZOO_USER_UID} ${TLS_DIR}
COPY --chown=${ZOO_USER_UID}:${ZOO_USER_UID} certificate-authority ${TLS_DIR}
COPY --chown=${ZOO_USER_UID}:${ZOO_USER_UID} docker-entrypoint.sh $ZOO_USER_HOME
COPY --chown=${ZOO_USER_UID}:${ZOO_USER_UID} healthcheck.sh $ZOO_USER_HOME
RUN sudo chmod 755 ${ZOO_USER_HOME}/healthcheck.sh
ENTRYPOINT ["sh", "docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]
EXPOSE 2181 2182 2888 3888 8080


