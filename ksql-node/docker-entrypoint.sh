echo "Arguments: $@"


export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_KEY_ALIAS=$(hostname)
if [ ! -f ${SSL_TRUSTSTORE_LOCATION} ] || [ ! -f ${SSL_KEYSTORE_LOCATION} ]
then
  sh ${TLS_DIR}/ssl-tls.sh
else
  echo "keystore and trustore exist..."
fi



KAFKA_CLIENT_CONFIG=${KSQL_CONF_DIR}/kafka-client.properties
{
  echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.key.password=${SSL_KEYSTORE_PASS}"
  echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
} > ${KAFKA_CLIENT_CONFIG}


KSQL_SERVER_CONFIG=${KSQL_CONF_DIR}/$(hostname)-server.properties
sudo touch ${KSQL_SERVER_CONFIG}
sudo chown $(whoami):$(whoami) $KSQL_SERVER_CONFIG
{
  sudo echo "bootstrap.servers=${BOOTSTRAP_SERVERS:-localhost:9092}"
  sudo echo "listeners=https://$(hostname):8088"
  sudo echo "ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION}"
  sudo echo "ssl.truststore.password=${SSL_TRUSTSTORE_PASS}"
  sudo echo "ssl.keystore.location=${SSL_KEYSTORE_LOCATION}"
  sudo echo "ssl.keystore.password=${SSL_KEYSTORE_PASS}"
  sudo echo "ssl.key.password=${SSL_KEYSTORE_PASS}"
  sudo echo "sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${SASL_USERNAME}\" password=\"${SASL_PASSWORD}\";"
  sudo echo "security.protocol=SASL_SSL"
  sudo echo "sasl.mechanism=SCRAM-SHA-512"
  sudo echo "ssl.client.authentication=REQUIRED"
  sudo echo "confluent.support.metrics.enable=false"
  sudo echo "ksql.output.topic.name.prefix=${KSQL_OUTPUT_TOPIC_NAME_PREFIX}"
  sudo echo "ksql.logging.processing.topic.auto.create=true"
  sudo echo "ksql.logging.processing.stream.auto.create=true"
  sudo echo "compression.type=snappy"
} > $KSQL_SERVER_CONFIG

ksql-server-start ${KSQL_SERVER_CONFIG}


