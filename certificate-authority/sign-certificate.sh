# Sign the certificate

INPUT_PATH=${1}
INPUT_HOSTNAME=${2}
INPUT_CSR=${INPUT_PATH}/${INPUT_HOSTNAME}.csr
OUTPUT_SIGNED=${INPUT_PATH}/${INPUT_HOSTNAME}.signed
CONTAINER_IP=$(cat /etc/hosts | grep $(hostname) | awk '{ print $1 }')
CONFIG=$TLS_DIR/openssl.cnf

{
  echo "[ req_ext ]"
  echo "subjectAltName = @alt_names"
  echo "[ alt_names ]"
  echo "IP.1 = ${DOCKER_HOST_IP}"
  echo "DNS.1 = ${CONTAINER_IP}"
  echo "DNS.2 = $(hostname)"
  echo "DNS.3 = ${DOCKER_HOST_IP}"
} >> ${CONFIG}

cat ${CONFIG}

openssl x509 -req -CA ca.cert \
  -CAkey ca.key \
  -in ${INPUT_CSR} \
  -out ${OUTPUT_SIGNED} \
  -days 365 \
  -CAcreateserial \
  -extfile openssl.cnf \
  -extensions req_ext