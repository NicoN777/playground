mkdir certificate-authority
cp ../certificate-authority/ca.key ../certificate-authority/ca.cert ../certificate-authority/ssl-tls-kafka-broker.sh certificate-authority
DOCKER_HOST_IP=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
docker build --build-arg DOCKER_HOST_IP=${DOCKER_HOST_IP} --tag toastyboii/kafka-broker:v0.0.1 .
rm -rf certificate-authority