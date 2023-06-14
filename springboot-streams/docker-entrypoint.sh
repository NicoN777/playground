echo "Arguments: $@"
export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_KEY_ALIAS=$(hostname)

if [ ! -f ${SSL_TRUSTSTORE_LOCATION} ] || [ ! -f ${SSL_KEYSTORE_LOCATION} ]
then
  sh ${TLS_DIR}/ssl-tls.sh
else
  echo "keystore and trustore exist..."
fi

exec java -jar ${EXECUTABLE_JAR}