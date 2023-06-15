KSQL_USER=${1:-KSQL}
KSQL_USER_PASSWORD=${2:-notgonnatellyou}
KSQL_SERVICE_ID=${3:-default_}
BOOTSTRAP_SERVER=${4:-$(hostname):9092}
KSQL_OUTPUT_TOPIC_NAME_PREFIX=${5:-ksql-interactive-}


kafka-configs.sh --zookeeper znode1:2182 --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties --user KSQL --describe

# Delete User
#kafka-configs.sh --zookeeper znode1:2182 \
#--zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
#--user ${KSQL_USER} --alter --delete-config "SCRAM-SHA-512"

#kafka-configs.sh --zookeeper znode1:2182 \
#--zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
#--entity-type users --describe

# The DESCRIBE_CONFIGS operation on the CLUSTER resource type.
# Allow ksqlDB to discover the cluster:
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation DescribeConfigs --cluster

# The ALL operation on all internal TOPICS that are PREFIXED with _confluent-ksql-<ksql.service.id>.
# Allow ksqlDB to manage its own internal topics and consumer groups:
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation All --resource-pattern-type prefixed --topic _confluent-ksql-${KSQL_SERVICE_ID}
# The ALL operation on all internal GROUPS that are PREFIXED with _confluent-ksql-<ksql.service.id>.
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation All --resource-pattern-type prefixed --group _confluent-ksql-${KSQL_SERVICE_ID}

# The ALL operation on the TOPIC with LITERAL name <ksql.logging.processing.topic.name>.
# Where ksql.logging.processing.topic.name can be configured in the ksqlDB configuration and defaults to <ksql.service.id>ksql_processing_log.
# Allow ksqlDB to manage its record processing log topic, if configured:
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation All --topic ${KSQL_SERVICE_ID}ksql_processing_log

# Allow ksqlDB to read the input topics:
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation Read --topic '*'

# Allow ksqlDB to manage output topics:
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --operation All --resource-pattern-type prefixed --topic ${KSQL_OUTPUT_TOPIC_NAME_PREFIX}

# Allow ksqlDB to produce to the command topic:
# TRANSACTIONAL_ID	<ksql-service-id>	LITERAL
kafka-acls.sh --bootstrap-server ${BOOTSTRAP_SERVER} --command-config  ${KAFKA_CONF_DIR}/kafka-client.properties --add --allow-principal User:${KSQL_USER} --allow-host '*' --producer --transactional-id ${KSQL_SERVICE_ID} --topic _confluent-ksql-${KSQL_SERVICE_ID}_command_topic
