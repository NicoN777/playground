#cd /var/lib/ca
echo "Creating TrustStore"
sh create-truststore.sh
echo "Creating KeyStore"
sh create-keystore.sh
echo "Creating CSR"
sh create-csr.sh
echo "Signing the CSR with the CA"
sh sign-certificate.sh "${TLS_DIR}" "$(hostname)"
echo "Importing signed and CA certificate"
sh import-certs.sh


