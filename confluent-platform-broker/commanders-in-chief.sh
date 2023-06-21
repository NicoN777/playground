# Kafka Commands Cheat Sheet
# All assume KAFKA_HOME is set and available in PATH

#Create some topics
kafka-topics --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --create --topic user-registration-events --partitions 5 --replication-factor 5
kafka-topics --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --create --topic order-events --partitions 5 --replication-factor 5
kafka-topics --bootstrap-server $(hostname):9092  --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --delete --topic order-event

kafka-topics --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --list
kafka-topics --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --alter --topic user-registration-events --partitions 4
kafka-topics --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --alter --topic order-events --partitions 5 --replication-factor 5

# Partition reassignment
kafka-reassign-partitions --bootstrap-server $(hostname):9092 --broker-list kafka-broker-1,kafka-broker-2,kafka-broker-3,kafka-broker-4,kafka-broker-5 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --generate --topics-to-move-json-file reassignment.json
kafka-reassign-partitions --bootstrap-server $(hostname):9092 --broker-list 1,2,3,4,5 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --generate --topics-to-move-json-file reassignment.json
kafka-reassign-partitions --bootstrap-server $(hostname):9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties --reassignment-json-file reassignment-proposed.json  --execute

# Streams Reset
#kafka.tools.StreamsResetter
kafka-streams-application-reset --bootstrap-server $(hostname):9092 --config-file ${KAFKA_CONF_DIR}/kafka-client.properties --application-id docker-streams