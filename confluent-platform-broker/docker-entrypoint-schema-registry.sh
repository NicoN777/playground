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


# ZooKeeper Client Properties
export ZOOKEEPER_CLIENT_CONFIG=${KAFKA_CONF_DIR}/zookeeper-client.properties
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

# Kafka Client Properties
export KAFKA_CLIENT_CONFIG=${KAFKA_CONF_DIR}/kafka-client.properties
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

# JAAS Configuration
JAAS_CONFIG="${KAFKA_CONF_DIR}"/$(hostname)-jaas.conf
{
  echo "KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
     username=\"${SASL_BROKER_ADMIN_USERNAME}\"
     password=\"${SASL_BROKER_ADMIN_PASSWORD}\";
  };"
} > ${JAAS_CONFIG}


# Kafka Server Properties
export SERVER_PROPERTIES="${KAFKA_CONF_DIR}/$(hostname).properties"
{
  echo "########################## ZooKeeper Propeties #############################"
  echo "zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}"
  echo "zookeeper.set.acl=true"
  echo "zookeeper.ssl.protocol=TLSv1.2"
  echo "zookeeper.ssl.client.enable=true"
  echo "zookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty"
  echo "zookeeper.ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "zookeeper.ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "zookeeper.ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
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
  echo "ssl.client.authentication=${SSL_CLIENT_AUTHENTICATION}"
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

  echo "############################### Confluent ###################################"
  echo "confluent.telemetry.enabled=false"
} > ${SERVER_PROPERTIES}

cat ${SERVER_PROPERTIES}

# Kakfa Rest Properties
export KAFKA_REST_PROPERTIES=${KAFKA_REST_CONF_DIR}/kafka-rest.properties
{
  echo "id=kafka-rest-server-${REST_SERVER_ID}"
  echo "schema.registry.url=https://$(hostname):8081"

  echo "########################## ZooKeeper Propeties #############################"
  echo "zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}"
  echo "zookeeper.set.acl=true"
  echo "zookeeper.ssl.protocol=TLSv1.2"
  echo "zookeeper.ssl.client.enable=true"
  echo "zookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty"
  echo "zookeeper.ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "zookeeper.ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "zookeeper.ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "zookeeper.ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "zookeeper.ssl.clientAuth=need"

  echo "bootstrap.servers=${BOOTSTRAP_SERVERS:-SASL_SSL://kafka-broker-1:9092}"
  echo "client.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${SASL_BROKER_ADMIN_USERNAME}\" password=\"${SASL_BROKER_ADMIN_PASSWORD}\";"
  echo "client.security.protocol=SASL_SSL"
  echo "client.sasl.mechanism=SCRAM-SHA-512"
  echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.key.password=${SSL_KEY_PASS}"
  echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "ssl.client.authentication=NONE"
} > ${KAFKA_REST_PROPERTIES}

export SCHEMA_REGISTRY_PROPERTIES=${SCHEMA_REGISTRY_CONF_DIR}/schema-registry.properties
# Schema Registry Properties
{
  echo "host.name=$(hostname)"
  echo "listeners=https://0.0.0.0:8081"
  echo "inter.instance.protocol=https"

  echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.key.password=${SSL_KEY_PASS}"
  echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "#ssl.principal.mapping.rules="
  echo "#ssl.client.authentication=REQUIRED"
  echo "ssl.client.authentication=NONE"

  echo "kafkastore.bootstrap.servers=${BOOTSTRAP_SERVERS:-SASL_SSL://kafka-broker-1:9092}"
  echo "kafkastore.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${SASL_BROKER_ADMIN_USERNAME}\" password=\"${SASL_BROKER_ADMIN_PASSWORD}\";"
  echo "kafkastore.security.protocol=SASL_SSL"
  echo "kafkastore.sasl.mechanism=SCRAM-SHA-512"
  echo "kafkastore.ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "kafkastore.ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "kafkastore.ssl.key.password=${SSL_KEY_PASS}"
  echo "kafkastore.ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "kafkastore.ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  echo "kafkastore.ssl.client.authentication=NONE"

  # The name of the topic to store schemas in
  echo "kafkastore.topic=_schemas"

  # If true, API requests that fail will include extra debugging information, including stack traces
  echo "debug=false"

  echo "metadata.encoder.secret=REPLACE_ME_WITH_HIGH_ENTROPY_STRING"
} > ${SCHEMA_REGISTRY_PROPERTIES}

exec schema-registry-start ${SCHEMA_REGISTRY_PROPERTIES}