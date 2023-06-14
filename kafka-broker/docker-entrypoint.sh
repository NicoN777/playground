echo "Arguments: $@"
EXTRA_OPTION=${1}

export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-truststore.jks
export SSL_KEY_ALIAS=$(hostname)
if [ ! -f ${SSL_TRUSTSTORE_LOCATION} ] || [ ! -f ${SSL_KEYSTORE_LOCATION} ]
then
  sh ${TLS_DIR}/ssl-tls-kafka-broker.sh
else
  echo "keystore and trustore exist..."
fi


ZOOKEEPER_CLIENT_CONFIG=${KAFKA_CONF_DIR}/zookeeper-client.properties
{
  echo "zookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty"
  echo "zookeeper.ssl.client.enable=true"
  echo "zookeeper.ssl.protocol=TLSv1.2"
  echo "zookeeper.ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "zookeeper.ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "zookeeper.ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "zookeeper.ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "zookeeper.ssl.key.password=${SSL_KEYSTORE_PASS}"
  echo "zookeeper.ssl.clientAuth=need"
} > ${ZOOKEEPER_CLIENT_CONFIG}

KAFKA_CLIENT_CONFIG=${KAFKA_CONF_DIR}/kafka-client.properties
{
  echo "sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${SASL_BROKER_ADMIN_USERNAME}\" password=\"${SASL_BROKER_ADMIN_PASSWORD}\";"
  echo "security.protocol=SASL_SSL"
  echo "sasl.mechanism=SCRAM-SHA-512"
  echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.key.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
} > ${KAFKA_CLIENT_CONFIG}

if [ ${EXTRA_OPTION} == "configurator" ]
then
  echo "Running kafka-configs..."
  sh ${HOME}/configurator.sh
  echo "User and ACL Creation for KSQL user..."
  sh ${HOME}/ksql-user-acl-configurator.sh
fi


JAAS_CONFIG="${KAFKA_CONF_DIR}"/$(hostname)-jaas.conf
{
  echo "KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
     username=\"${SASL_BROKER_ADMIN_USERNAME}\"
     password=\"${SASL_BROKER_ADMIN_PASSWORD}\";
  };"
} > ${JAAS_CONFIG}

SERVER_PROPERTIES="${KAFKA_CONF_DIR}/$(hostname).properties"
{
  echo "########################## ZooKeeper Propeties #############################"
  echo "zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}"
  echo "zookeeper.set.acl=true"
  echo "zookeeper.ssl.protocol=TLSv1.2"
  echo "zookeeper.ssl.client.enable=true"
  echo "zookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty"
  echo "zookeeper.ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "zookeeper.ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "zookeeper.ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}
  echo "zookeeper.ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "zookeeper.ssl.clientAuth=need"

  echo "########################### Broker Propeties ##############################"
  echo "broker.id=${KAFKA_BROKER_ID}"
  echo "listeners=${KAFKA_LISTENERS}"
  echo "advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}"
  echo "listener.security.protocol.map=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP}"
  echo "inter.broker.listener.name=${KAFKA_INTER_BROKER_LISTENER_NAME}"
  echo "log.dirs=${KAFKA_LOG_DIRS}"

  echo "####################### Broker Security Properties ##########################"
  echo "authorizer.class.name=kafka.security.authorizer.AclAuthorizer"
  echo "ssl.client.auth=${KAFKA_SSL_CLIENT_AUTH}"
  echo "ssl.protocol=TLSv1.2"
  echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.key.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "sasl.enabled.mechanisms=SCRAM-SHA-512"
  echo "sasl.mechanism.inter.broker.protocol=SCRAM-SHA-512"
  echo "listener.name.sasl_ssl.scram-sha-512.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${SASL_BROKER_ADMIN_USERNAME}\" password=\"${SASL_BROKER_ADMIN_PASSWORD}\";"
  echo "super.users=User:${SASL_BROKER_ADMIN_USERNAME}"
} > ${SERVER_PROPERTIES}

cat ${SERVER_PROPERTIES}

export KAFKA_OPTS="-Djava.security.auth.login.config=${JAAS_CONFIG}"
echo ${KAFKA_OPTS}
exec kafka-server-start.sh ${SERVER_PROPERTIES}