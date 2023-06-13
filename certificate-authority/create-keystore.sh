# Create a Keystore
COUNTRY=${1:-US}
STATE=${2:-Texas}
LOCALITY=${3:-Austin}
ORGANIZATION=${4:-Toasty}
ORGANIZATIONAL_UNIT=${5:-IT}
CN=${6:-ca.cert}

keytool -keystore ${TLS_DIR}/$(hostname)-keystore.jks \
  -alias $(hostname) \
  -storepass ${SSL_KEYSTORE_PASS} \
  -validity 365 \
  -genkey -keyalg RSA \
  -keysize 2048 \
  -dname "CN=$(hostname),O=${ORGANIZATION},OU=${ORGANIZATIONAL_UNIT},L=${LOCALITY},ST=${STATE},C=${COUNTRY}" \
  -ext SAN=DNS:$(hostname)


keytool -importkeystore \
    -srckeystore ${TLS_DIR}/$(hostname)-keystore.jks \
    -srckeypass ${SSL_KEYSTORE_PASS} \
    -destkeystore ${TLS_DIR}/$(hostname)-keystore.p12 \
    -deststoretype PKCS12 \
    -srcalias $(hostname) \
    -deststorepass ${SSL_KEYSTORE_PASS} \
    -destkeypass ${SSL_KEY_PASS:-changeit}

openssl pkcs12 -in ${TLS_DIR}/$(hostname)-keystore.p12 -nokeys -out ${TLS_DIR}/$(hostname).pem
openssl pkcs12 -in ${TLS_DIR}/$(hostname)-keystore.p12 -nodes -nocerts -out ${TLS_DIR}/$(hostname).key

