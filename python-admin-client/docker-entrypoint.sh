echo "Arguments: $@"
export SSL_KEYSTORE_LOCATION=${TLS_DIR}/$(hostname)-keystore.jks
export SSL_TRUSTSTORE_LOCATION=${TLS_DIR}/$(hostname)-truststore.jks
export SSL_KEY_ALIAS=$(hostname)
sh ${TLS_DIR}/ssl-tls-no-keytool.sh



TO_EXEC="python ${EXECUTABLE_SCRIPT} ${@}"
exec ${TO_EXEC}

#tail -f /dev/null