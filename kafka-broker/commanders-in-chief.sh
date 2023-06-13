# Kafka Commands Cheat Sheet
# All assume KAFKA_HOME is set and available in PATH

kafka-topics.sh --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --list
kafka-topics.sh --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --alter --topic user-registration-events --partitions 4

# Partition reassignment
kafka-reassign-partitions.sh --bootstrap-server $(hostname):9092 --broker-list kafka-broker-1,kafka-broker-2,kafka-broker-3,kafka-broker-4 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --generate --topics-to-move-json-file reassignment.json
kafka-reassign-partitions.sh --bootstrap-server $(hostname):9092 --broker-list 1,2,3,4 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --generate --topics-to-move-json-file reassignment.json
kafka-reassign-partitions.sh --bootstrap-server $(hostname):9092 --reassignment-json-file increase-replication-factor.json  --execute

# Streams Reset
#kafka.tools.StreamsResetter
kafka-streams-application-reset.sh --bootstrap-server $(hostname):9092 --config-file ${KAFKA_CONF_DIR}/kafka-client.properties --application-id docker-streams