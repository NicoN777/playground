# Create a Keystore
COUNTRY=${1:-US}
STATE=${2:-Texas}
LOCALITY=${3:-Austin}
ORGANIZATION=${4:-Toasty}
ORGANIZATIONAL_UNIT=${5:-IT}
CN=${6:-ca.cert}

keytool -keystore ${TLS_DIR}/$(hostname)-keystore.jks \
  -alias $(hostname) \
  -storepass changeit \
  -validity 365 \
  -genkey -keyalg RSA \
  -keysize 2048 \
  -dname "CN=$(hostname),O=${ORGANIZATION},OU=${ORGANIZATIONAL_UNIT},L=${LOCALITY},ST=${STATE},C=${COUNTRY}" \
  -ext SAN=DNS:$(hostname)

