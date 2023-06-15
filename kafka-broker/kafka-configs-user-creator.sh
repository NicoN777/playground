 USER=${1:-kafka-user}
 PASSWORD=${2:-th1s1s4p4ssw0rd}
echo "Creating user with the following:\ username=${USER} password=${PASSWORD}"
 # Run this in a Kafka Broker
 kafka-configs.sh --zookeeper znode1:2182 \
  --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
  --entity-type users --entity-name ${USER} \
  --alter --add-config "SCRAM-SHA-512=[password=${PASSWORD}]"