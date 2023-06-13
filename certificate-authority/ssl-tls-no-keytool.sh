
COUNTRY=${1:-US}
STATE=${2:-Texas}
LOCALITY=${3:-Austin}
ORGANIZATION=${4:-Toasty}
ORGANIZATIONAL_UNIT=${5:-IT}
CN=${6:-ca.cert}


# Create Key
openssl genrsa -out ${TLS_DIR}/$(hostname).key 2048

# openssl configuration
CONTAINER_IP=$(cat /etc/hosts | grep $(hostname) | awk '{ print $1 }')
CONFIG=$TLS_DIR/openssl.cnf
{
  echo "[req]"
  echo "distinguished_name = req_distinguished_name"
  echo "req_extensions = req_ext"
  echo "prompt = no"

  echo "[req_distinguished_name]"
  echo "C   = ${COUNTRY}"
  echo "ST  = ${STATE}"
  echo "L   = ${LOCALITY}"
  echo "O   = ${ORGANIZATION}"
  echo "OU  = ${ORGANIZATIONAL_UNIT}"
  echo "CN  = $(hostname)"

  echo "[req_ext]"
  echo "subjectAltName = @alt_names"
  echo "[ alt_names ]"
  echo "IP.1 = ${DOCKER_HOST_IP}"
  echo "IP.2 = ${CONTAINER_IP}"
  echo "DNS.1 = $(hostname)"
} > ${CONFIG}
cat ${CONFIG}

# Create the CSR
openssl req -new -key ${TLS_DIR}/$(hostname).key \
  -out ${TLS_DIR}/$(hostname).csr \
  -config ${CONFIG}

# Sign the Certificate
openssl x509 -req -CA ${TLS_DIR}/ca.cert \
  -CAkey ${TLS_DIR}/ca.key \
  -in "${TLS_DIR}/$(hostname).csr" \
  -out "${TLS_DIR}/$(hostname).pem" \
  -days 365 \
  -CAcreateserial \
  -extfile ${TLS_DIR}/openssl.cnf \
  -extensions req_ext

# Clean Up
rm ${TLS_DIR}/ca.key