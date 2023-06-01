echo "I am the docker-entrypoint.sh"
echo "This is my env"
env

echo "Arguments: $@"

exec kafka-server-start.sh \
  ${KAFKA_HOME}/config/server.properties \
  --override zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT} \
  --override zookeeper.connection.timeout.ms=${KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS} \
  --override broker.id=${KAFKA_BROKER_ID} \
  --override listeners=${KAFKA_LISTENERS} \
  --override advertised.listeners=${KAFKA_ADVERTISED_LISTENERS} \
  --override listener.security.protocol.map=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP} \
  --override inter.broker.listener.name=${KAFKA_INTER_BROKER_LISTENER_NAME} \
  --override log.dirs=${KAFKA_LOG_DIRS}
