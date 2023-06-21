import sys
from confluent_kafka import Producer
from confluent_kafka.serialization import IntegerSerializer, SerializationContext, MessageField
from confluent_kafka.schema_registry.avro import AvroSerializer
from confluent_kafka.schema_registry import SchemaRegistryClient

import argparse
import glob
import os
import avro.schema
import json

def get_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog='python-kafka-producer',
                                     description="Producers data to the topic of your choice",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     add_help=True)
    parser.add_argument('-bs', '--bootstrap-servers', required=True)
    parser.add_argument('-t', '--topic', required=True)
    return parser


def conf_builder(parsed):
    hostname = os.uname()[1]

    conf = {
        'bootstrap.servers': parsed.bootstrap_servers,
        'security.protocol': 'sasl_ssl',
        'ssl.ca.location': f"{os.getenv('TLS_DIR')}/ca.cert",
        'ssl.certificate.location': f"{os.getenv('TLS_DIR')}/{hostname}.pem",
        'ssl.key.location': f"{os.getenv('TLS_DIR')}/{hostname}.key",
        'sasl.mechanism': 'SCRAM-SHA-512',
        'sasl.username': f"{os.getenv('SASL_USERNAME')}",
        'sasl.password': f"{os.getenv('SASL_PASSWORD')}"
        }
    return conf

def schema_registry_conf():
    hostname = os.uname()[1]
    schema_registry_url = f"{os.getenv('SCHEMA_REGISTRY_URL')}"
    sr_config = {
        'url': schema_registry_url,
        'ssl.ca.location': f"{os.getenv('TLS_DIR')}/ca.cert",
        'ssl.certificate.location': f"{os.getenv('TLS_DIR')}/{hostname}.pem",
        'ssl.key.location': f"{os.getenv('TLS_DIR')}/{hostname}.key"
    }
    return sr_config

def get_schema_registry_client():
    schema_registry_client = SchemaRegistryClient(schema_registry_conf())
    return schema_registry_client

def get_producer(conf):
    producer = Producer(conf)
    cluster_metadata = producer.list_topics()
    print(f'Cluster metadata: {cluster_metadata}')
    return producer


def read_orders():
    path = os.getcwd()
    filename = os.path.join(path, 'mock-order-data-v1.json')
    with open(filename) as fin:
        orders = json.load(fin)
        for order in orders:
            order['create_date'] = int(order['create_date'])
            order['currency'] = 'USD'
            yield order['customer_id'], order


def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))


def get_schema(schema_registry_client, subject_name):
    subject_name_versions = schema_registry_client.get_versions(subject_name)
    latest = schema_registry_client.get_latest_version(subject_name)
    id = latest.schema_id
    subject = latest.subject
    version = latest.version
    schema = latest.schema
    schema_type = schema.schema_type
    print(f'Schema -> id: {id}, subject: {subject}, version: {version}, schema: {schema}, type: {schema_type}')
    schema_str = schema.schema_str
    print(f'Schema Str: {schema_str}')
    return schema

def produce_order_events(schema_registry_client, producer, topic):
    schema = get_schema(schema_registry_client, 'order')
    integer_serializer = IntegerSerializer()
    avro_serializer = AvroSerializer(schema_registry_client, schema.schema_str)
    for k,v in read_orders():
        # Trigger any available delivery report callbacks from previous produce() calls
        producer.poll(0)
        # Asynchronously produce a message. The delivery report callback will
        # be triggered from the call to poll() above, or flush() below, when the
        # message has been successfully delivered or failed permanently.
        key = integer_serializer(k)
        value = avro_serializer(v, SerializationContext(topic, MessageField.VALUE))
        producer.produce(topic, key=key, value=value, on_delivery=delivery_report)
    producer.flush()

if __name__ == '__main__':
    parser = get_argument_parser()
    parsed = parser.parse_args(sys.argv[1:])
    topic = parsed.topic
    schema_registry_client = get_schema_registry_client()
    config = conf_builder(parsed)
    producer = get_producer(conf_builder(parsed))
    produce_order_events(schema_registry_client, producer, topic)








