# Sign the certificate
INPUT_PATH=${1}
INPUT_HOSTNAME=${2}
INPUT_CSR=${INPUT_PATH}/${INPUT_HOSTNAME}.csr
OUTPUT_SIGNED=${INPUT_PATH}/${INPUT_HOSTNAME}.signed
openssl x509 -req -CA /var/lib/ca/ca.cert \
  -CAkey /var/lib/ca/ca.key \
  -in ${INPUT_CSR} \
  -out ${OUTPUT_SIGNED} \
  -days 365 \
  -CAcreateserial \
  -extfile /var/lib/ca/openssl.cnf \
  -extensions req_ext