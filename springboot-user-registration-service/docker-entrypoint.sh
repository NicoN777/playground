echo "Arguments: $@"
export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_KEY_ALIAS=$(hostname)
export PRODUCER_CLIENT_ID="producer-$(hostname)"
sh ${TLS_DIR}/ssl-tls.sh

exec java -jar ${EXECUTABLE_JAR}