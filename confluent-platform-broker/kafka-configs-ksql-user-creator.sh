 KSQL_USER=${1:-KSQL}
 KSQL_USER_PASSWORD=${2:-notgonnatellyou}
 KSQL_SERVICE_ID=${3:-default_}
 BOOTSTRAP_SERVER=${4:-$(hostname):9092}
 KSQL_OUTPUT_TOPIC_NAME_PREFIX=${5:-ksql-interactive-}

 # Run this in a Kafka Broker
 kafka-configs --zookeeper znode1:2182 \
  --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
  --entity-type users --entity-name ${KSQL_USER} \
  --alter --add-config "SCRAM-SHA-512=[password=${KSQL_USER_PASSWORD}]"



