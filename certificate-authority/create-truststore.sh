keytool -keystore ${TLS_DIR}/$(hostname)-truststore.jks \
  -alias ca.cert \
  -import -file ca.cert \
  -storepass changeit -noprompt