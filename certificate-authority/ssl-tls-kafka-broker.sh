#Author: Nicolas Nunez
# Default Variables
# Comments:
# To Authenticate with ZooKeeper with multiple Kafka Brokers running
# in different machines (as they should), we must use a certificate with the same
# Distinguished Name and list of hosts as Subject Alternate Name

COUNTRY=${1:-US}
STATE=${2:-Texas}
LOCALITY=${3:-Austin}
ORGANIZATION=${4:-Toasty}
ORGANIZATIONAL_UNIT=${5:-IT}
CN=${6:-ca.cert}


# Create a TrustStore
keytool -keystore "${TLS_DIR}/$(hostname)-truststore.jks" \
  -alias ca.cert \
  -import -file ${TLS_DIR}/ca.cert \
  -storepass ${SSL_TRUSTSTORE_PASS} -noprompt


# Create a Keystore
keytool -keystore "${TLS_DIR}/$(hostname)-keystore.jks" \
  -alias kafka-broker \
  -storepass ${SSL_KEYSTORE_PASS} \
  -validity 365 \
  -genkey -keyalg RSA \
  -keysize 2048 \
  -dname "CN=kafka-broker,O=${ORGANIZATION},OU=${ORGANIZATIONAL_UNIT},L=${LOCALITY},ST=${STATE},C=${COUNTRY}" \
  -ext SAN=DNS:kafka-broker-1,DNS:kafka-broker-2,DNS:kafka-broker3,DNS:kafka-broker-4

# Create a CSR
keytool -keystore "${TLS_DIR}/$(hostname)-keystore.jks" \
  -alias kafka-broker \
  -storepass ${SSL_KEYSTORE_PASS} \
  -certreq -ext SAN=DNS:kafka-broker-1,DNS:kafka-broker-2,DNS:kafka-broker3,DNS:kafka-broker-4 \
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
  echo "DNS.1 = kafka-broker-1"
  echo "DNS.2 = kafka-broker-2"
  echo "DNS.3 = kafka-broker-3"
  echo "DNS.4 = kafka-broker-4"
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
keytool -keystore "${TLS_DIR}/$(hostname)-keystore.jks" \
  -storepass ${SSL_KEYSTORE_PASS} \
  -alias ca.cert \
  -import -file ${TLS_DIR}/ca.cert -noprompt


# Signed:
keytool -keystore "${TLS_DIR}/$(hostname)-keystore.jks" \
  -storepass ${SSL_KEYSTORE_PASS} \
  -alias kafka-broker \
  -import -file ${TLS_DIR}/$(hostname).signed -noprompt


#Clean Up
rm ${TLS_DIR}/ca.key
rm ${TLS_DIR}/ca.cert