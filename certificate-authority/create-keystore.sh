# Create a Keystore
keytool -keystore ${HOME}/$(hostname)-keystore.jks \
  -alias $(hostname) \
  -storepass changeit \
  -validity 365 \
  -genkey -keyalg RSA \
  -keysize 2048 \
  -dname "CN=$(hostname),O=Toasty,OU=IT,L=Austin,ST=Texas,C=US"

