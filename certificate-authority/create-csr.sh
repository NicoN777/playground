# Create a CSR
keytool -keystore ${HOME}/$(hostname)-keystore.jks \
  -alias $(hostname) \
  -storepass changeit \
  -certreq -file ${HOME}/$(hostname).csr