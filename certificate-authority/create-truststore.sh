keytool -keystore ${HOME}/$(hostname)-truststore.jks \
  -alias CARoot \
  -import -file /var/lib/ca/ca.cert \
  -storepass changeit