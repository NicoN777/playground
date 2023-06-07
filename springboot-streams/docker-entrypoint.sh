echo "I am the docker-entrypoint.sh"
echo "This is my env"
env

echo "Arguments: $@"
export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_KEY_ALIAS=$(hostname)
sh ${TLS_DIR}/ssl-tls.sh

exec java -jar ${EXECUTABLE_JAR}