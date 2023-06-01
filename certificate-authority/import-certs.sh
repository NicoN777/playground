# Import CA and signed certificate to keystore
# CA:
keytool -keystore ${HOME}/$(hostname)-keystore.jks \
  -storepass changeit \
  -alias CARoot \
  -import -file /var/lib/ca/ca.cert

# Signed:
keytool -keystore ${HOME}/$(hostname)-keystore.jks \
  -storepass changeit \
  -alias $(hostname) -import -file ${HOME}/$(hostname).signed