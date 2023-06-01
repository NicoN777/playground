cd /var/lib/ca
sh create-keystore.sh
sh create-csr.sh
sh sign-certificate.sh "${HOME}" "$(hostname)"
sh import-certs.sh
sh create-truststore.sh
cd ${HOME}