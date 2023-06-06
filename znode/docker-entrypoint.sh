echo "I am the docker-entrypoint.sh"
echo "This is my env"
env

echo "Arguments: $@"


sh ${TLS_DIR}/ssl-tls.sh

CONFIG=$ZOO_CONF_DIR/zoo.cfg
{
  echo "clientPort=$ZOO_CLIENT_PORT"
  echo "secureClientPort=$ZOO_SECURE_CLIENT_PORT"
  echo "dataDir=$ZOO_DATA_DIR"
  echo "serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory"
  echo "clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty"
  echo "authProvider.x509=org.apache.zookeeper.server.auth.X509AuthenticationProvider"
  echo "ssl.keyStore.location="${TLS_DIR}/$(hostname)-keystore.jks""
  echo "ssl.keyStore.password=${ZOO_KEYSTORE_PASS}"
  echo "ssl.trustStore.location="${TLS_DIR}/$(hostname)-truststore.jks""
  echo "ssl.trustStore.password=${ZOO_TRUSTSTORE_PASS}"
  echo "dataLogDir=$ZOO_DATA_LOG_DIR"
  echo "tickTime=$ZOO_TICK_TIME"
  echo "initLimit=$ZOO_INIT_LIMIT"
  echo "syncLimit=$ZOO_SYNC_LIMIT"
  echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT"
  echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL"
  echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS"
  echo "standaloneEnabled=$ZOO_STANDALONE_ENABLED"
  echo "admin.enableServer=$ZOO_ADMINSERVER_ENABLED"
} >> ${CONFIG}

if [[ -z $ZOO_SERVERS ]];
then
  ZOO_SERVERS="server.1=localhost:2888:3888;2181"
fi

for server in $ZOO_SERVERS;
do
    echo "$server" >> "$CONFIG"
done

if [[ -n $ZOO_4LW_COMMANDS_WHITELIST ]];
then
  echo "4lw.commands.whitelist=$ZOO_4LW_COMMANDS_WHITELIST" >> "$CONFIG"
fi

for cfg_extra_entry in $ZOO_CFG_EXTRA;
do
  echo "$cfg_extra_entry" >> "$CONFIG"
done

# Write myid only if it doesn't exist
if [[ ! -f "$ZOO_DATA_DIR/myid" ]];
then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi

echo "Configuration file ${CONFIG}:"
cat ${CONFIG}
echo "Executing ${@}"
exec "$@"
