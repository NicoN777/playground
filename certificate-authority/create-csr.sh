# Create a CSR
keytool -keystore ${TLS_DIR}/$(hostname)-keystore.jks \
  -alias $(hostname) \
  -storepass changeit \
  -certreq -ext SAN=DNS:$(hostname) \
  -file ${TLS_DIR}/$(hostname).csr