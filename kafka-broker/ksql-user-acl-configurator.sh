 KSQL_USER=${1:-KSQL}
 KSQL_USER_PASSWORD=${2:-notgonnatellyou}
 KSQL_SERVICE_ID=${3:-default_}
 BOOTSTRAP_SERVER=${4:-kafka-broker-1:9092}
 KSQL_OUTPUT_TOPIC_NAME_PREFIX=${5:-ksql-interactive-}

 # Run this in a Kafka Broker
 kafka-configs.sh --zookeeper znode1:2182 \
  --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
  --entity-type users --entity-name ${KSQL_USER} \
  --alter --add-config "SCRAM-SHA-512=[password=${KSQL_USER_PASSWORD}]"



kafka-configs.sh --zookeeper znode1:2182 --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties --user KSQL --describe

# Delete User
#kafka-configs.sh --zookeeper znode1:2182 \
#--zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
#--user ${KSQL_USER} --alter --delete-config "SCRAM-SHA-512"

#kafka-configs.sh --zookeeper znode1:2182 \
#--zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
#--entity-type users --describe

# Allow ksqlDB to discover the cluster:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation DescribeConfigs --cluster
# Allow ksqlDB to read the input topics:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation Read --resource-pattern-type prefixed --topic *
# Allow ksqlDB to manage output topics:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation All --resource-pattern-type prefixed --topic ${KSQL_OUTPUT_TOPIC_NAME_PREFIX}
# Allow ksqlDB to manage its own internal topics and consumer groups:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation All --resource-pattern-type prefixed --topic _confluent-ksql-${KSQL_SERVICE_ID} --group _confluent-ksql-${KSQL_SERVICE_ID}
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation All --topic '*' --group '*'
# Allow ksqlDB to manage its record processing log topic, if configured:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --operation All --topic ${KSQL_SERVICE_ID}ksql_processing_log
# Allow ksqlDB to produce to the command topic:
kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host * --producer --transactional-id ksql-${KSQL_SERVICE_ID} --topic _confluent-ksql-${KSQL_SERVICE_ID}_command_topic



kafka-acls.sh --bootstrap-server=${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation All --topic '*' --group '*'