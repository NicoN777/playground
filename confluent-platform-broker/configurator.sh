 kafka-configs.sh --zookeeper znode1:2182 \
  --zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties \
  --entity-type users --entity-name ${SASL_BROKER_ADMIN_USERNAME} \
  --alter --add-config "SCRAM-SHA-512=[password=${SASL_BROKER_ADMIN_PASSWORD}]"
