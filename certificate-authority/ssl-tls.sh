#Author: Nicolas Nunez
# Default Variables

COUNTRY=${1:-US}
STATE=${2:-Texas}
LOCALITY=${3:-Austin}
ORGANIZATION=${4:-Toasty}
ORGANIZATIONAL_UNIT=${5:-IT}
CN=${6:-ca.cert}


# Create a TrustStore
keytool -keystore ${SSL_TRUSTSTORE_LOCATION} \
  -alias ca.cert \
  -import -file ${TLS_DIR}/ca.cert \
  -storepass ${SSL_TRUSTSTORE_PASS} -noprompt


# Create a Keystore
keytool -keystore ${SSL_KEYSTORE_LOCATION} \
  -alias $(hostname) \
  -storepass ${SSL_KEYSTORE_PASS} \
  -validity 365 \
  -genkey -keyalg RSA \
  -keysize 2048 \
  -dname "CN=$(hostname),O=${ORGANIZATION},OU=${ORGANIZATIONAL_UNIT},L=${LOCALITY},ST=${STATE},C=${COUNTRY}" \
  -ext SAN=DNS:$(hostname)

# Create a CSR
keytool -keystore ${SSL_KEYSTORE_LOCATION} \
  -alias $(hostname) \
  -storepass ${SSL_KEYSTORE_PASS} \
  -certreq -ext SAN=DNS:$(hostname) \
  -file ${TLS_DIR}/$(hostname).csr

# Sign the Certificate
CONTAINER_IP=$(cat /etc/hosts | grep $(hostname) | awk '{ print $1 }')
CONFIG=$TLS_DIR/openssl.cnf
{
  echo "[ req_ext ]"
  echo "subjectAltName = @alt_names"
  echo "[ alt_names ]"
  echo "IP.1 = ${DOCKER_HOST_IP}"
  echo "IP.2 = ${CONTAINER_IP}"
  echo "DNS.1 = $(hostname)"
} > ${CONFIG}
cat ${CONFIG}

openssl x509 -req -CA ${TLS_DIR}/ca.cert \
  -CAkey ${TLS_DIR}/ca.key \
  -in "${TLS_DIR}/$(hostname).csr" \
  -out "${TLS_DIR}/$(hostname).signed" \
  -days 365 \
  -CAcreateserial \
  -extfile ${TLS_DIR}/openssl.cnf \
  -extensions req_ext

# Import CA and signed certificate to keystore
# CA:
keytool -keystore ${SSL_KEYSTORE_LOCATION} \
  -storepass ${SSL_KEYSTORE_PASS} \
  -alias ca.cert \
  -import -file ${TLS_DIR}/ca.cert -noprompt


# Signed:
keytool -keystore ${SSL_KEYSTORE_LOCATION} \
  -storepass ${SSL_KEYSTORE_PASS} \
  -alias $(hostname) \
  -import -file ${TLS_DIR}/$(hostname).signed -noprompt

# For clients that don't support Java Keystores
#keytool -importkeystore \
#    -srckeystore ${TLS_DIR}/$(hostname)-keystore.jks \
#    -srckeypass ${SSL_KEYSTORE_PASS} \
#    -destkeystore ${TLS_DIR}/$(hostname)-keystore.p12 \
#    -deststoretype PKCS12 \
#    -srcalias $(hostname) \
#    -deststorepass ${SSL_KEYSTORE_PASS} \
#    -destkeypass ${SSL_KEY_PASS:-changeit}
#
#openssl pkcs12 -in ${TLS_DIR}/$(hostname)-keystore.p12 -nokeys -out ${TLS_DIR}/$(hostname).pem
#openssl pkcs12 -in ${TLS_DIR}/$(hostname)-keystore.p12 -nodes -nocerts -out ${TLS_DIR}/$(hostname).key

#Clean Up
rm ${TLS_DIR}/ca.key
rm ${TLS_DIR}/ca.cert