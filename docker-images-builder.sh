# Author: Nicolas Nunez
# Date: 06/12/2023
# Description: Helper script to build all Docker images to get this little demo application running
# Comments: Is it the best approach? TBD
# Inspired by: H-E-B Brownies

# This directory
PROJECT_ROOT=$(pwd)

# Oracle Linux 9 (Base of Most (if not all) other Docker Images)
cd linux && sh docker-image-builder.sh && cd $PROJECT_ROOT

# Apache ZooKeeper znode
cd znode && sh docker-image-builder.sh && cd $PROJECT_ROOT

# Apache Kafka Broker
cd kafka-broker && sh docker-image-builder.sh && cd $PROJECT_ROOT

# Confluent Platform Broker
cd confluent-platform-broker && sh docker-image-builder.sh && cd $PROJECT_ROOT

# Python Admin Client
cd python-admin-client && sh docker-image-builder.sh && cd $PROJECT_ROOT

# KSQLDB
cd ksql-node && sh docker-image-builder.sh && cd $PROJECT_ROOT

# SpringBoot Streams
cd springboot-streams && sh docker-image-builder.sh && cd $PROJECT_ROOT

# SpringBoot WebFlux User Registration Service
cd springboot-user-registration-service && sh docker-image-builder.sh && cd $PROJECT_ROOT
