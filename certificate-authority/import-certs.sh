# Import CA and signed certificate to keystore
# CA:
keytool -keystore ${TLS_DIR}/$(hostname)-keystore.jks \
  -storepass changeit \
  -alias ca.cert \
  -import -file ca.cert -noprompt


# Signed:
keytool -keystore ${TLS_DIR}/$(hostname)-keystore.jks \
  -storepass changeit \
  -alias $(hostname) \
  -import -file ${TLS_DIR}/$(hostname).signed -noprompt