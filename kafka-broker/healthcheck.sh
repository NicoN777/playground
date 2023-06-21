brokers_info=$(kafka-broker-api-versions.sh --bootstrap-server kafka-broker-1:9092 --command-config ${KAFKA_CONF_DIR}/kafka-client.properties | awk '/id/{print $1}' | sort)
echo "${brokers_info}" > ${HOME}/kafka_brokers_api_versions.txt

function get_kafka_brokers() {
  broker_ids=$(zookeeper-shell.sh znode1:2182 -zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties <<EOF
ls /brokers/ids
quit
EOF
  )
  broker_ids_delimited="$(echo "${broker_ids}" | grep '^\[.*\]$' | sed 's/.*\[\([^]]*\)\].*/\1/g' | tr -d '[:space:]')"
  echo "${broker_ids_delimited}"
}

function process_kafka_brokers() {
  IFS=', ' read -r -a brokers <<< "${1}"
  rm ${HOME}/zk_shell.txt
  for id in "${brokers[@]}"
  do
    temp=$(zookeeper-shell.sh znode1:2182 -zk-tls-config-file ${KAFKA_CONF_DIR}/zookeeper-client.properties <<EOF
get /brokers/ids/${id}
quit
EOF
)
  broker="$(echo "${temp}" | grep '^\{.*\}$')"
  endpoints="$(echo "${broker}" | jq .endpoints[0][11:])"
  internal=$(echo "${endpoints}" | tr -d '"')
  echo ${internal} >> ${HOME}/zk_shell.txt
  done
  sort ${HOME}/zk_shell.txt
}



brokers=$(get_kafka_brokers)
process_kafka_brokers ${brokers}

cmp ${HOME}/kafka_brokers_api_versions.txt ${HOME}/zk_shell.txt
exit $?
