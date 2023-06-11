# All steps from ksqldb.io


ME=$(whoami)
sudo update-crypto-policies --set DEFAULT:SHA1

# Import the public key
sudo rpm --import http://ksqldb-packages.s3.amazonaws.com/rpm/0.28/archive.key
sudo touch ${KSQLDB_REPO}
{
  sudo echo '[KSQLDB]'
  sudo echo "name=KSQLDB"
  sudo echo "baseurl=http://ksqldb-packages.s3.amazonaws.com/rpm/0.28/"
  sudo echo "gpgcheck=1"
  sudo echo "gpgkey=http://ksqldb-packages.s3.amazonaws.com/rpm/0.28/archive.key"
  sudo echo "enabled=1"
} > ${KSQLDB_REPO}

# Install the package
sudo dnf install -y confluent-ksqldb
sudo update-crypto-policies --set DEFAULT
sudo chown -R ${ME}:${ME} /etc/ksqldb
sudo chown -R ${ME}:${ME} /var/lib/kafka-streams
sudo mkdir -p /usr/logs/ && sudo chown -R ${ME}:${ME} /usr/logs/


