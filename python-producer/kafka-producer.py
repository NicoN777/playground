import sys
import random
import time
from confluent_kafka import Producer
from confluent_kafka.serialization import IntegerSerializer
import argparse
import glob
import os
import avro.schema
from avro.io import DatumReader
from avro.datafile import DataFileReader
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


def get_producer(conf):
    producer = Producer(conf)
    cluster_metadata = producer.list_topics()
    print(f'Cluster metadata: {cluster_metadata}')
    return producer


def parse_schemas(schema_definition_path=None):
    if not schema_definition_path:
        cur_dir = os.getcwd()
        schema_dir = 'schema/avro'
        schema_definition_path = os.path.join(cur_dir, schema_dir)

    pattern = '*.avsc'
    schema_map = {}
    for filename in glob.glob(f'{schema_definition_path}/{pattern}'):
        print(filename)
        base_name = os.path.basename(filename)
        base = base_name.split('.')[0]
        with open(filename, 'rb') as fin:
            schema = avro.schema.parse(fin.read())
            print(f'Read schema with type: {schema.type} and name: {schema.name}')
            schema_map[schema.name] = {
                'schema': schema,
                'read_path': f'{schema_definition_path}/{base}.avro',
                'write_path': f'{schema_definition_path}/{base}.avro'
            }
    return schema_map


def read_orders(schema):
    with open(schema['read_path'], 'rb') as fin:
        reader = DataFileReader(fin, DatumReader())
        for order in reader:
            yield order['customer_id'], order


def generate_orders(schema):
    path = os.getcwd()
    filename = os.path.join(path, 'mock-order-data-v1.json')
    with open(filename) as fin:
        orders = json.load(fin)
        with open(schema['write_path'], 'wb') as fout:
            writer = DataFileWriter(fout, DatumWriter(), schema['schema'])
            for order in orders:
                order['create_date'] = int(order['create_date'])
                order['currency'] = 'USD'
                # print(order)
                writer.append(order)
            writer.close()


def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))


def produce_order_events(producer, topic):
    schemas = parse_schemas()
    integer_serializer = IntegerSerializer()
    for k,v in read_orders(schemas['Order']):
        # Trigger any available delivery report callbacks from previous produce() calls
        producer.poll(0)
        # Asynchronously produce a message. The delivery report callback will
        # be triggered from the call to poll() above, or flush() below, when the
        # message has been successfully delivered or failed permanently.
        value = json.dumps(v).encode('utf-8')
        producer.produce(topic, key=integer_serializer(k), value=value, callback=delivery_report)
    producer.flush()

if __name__ == '__main__':
    parser = get_argument_parser()
    parsed = parser.parse_args(sys.argv[1:])
    topic = parsed.topic
    config = conf_builder(parsed)
    producer = get_producer(conf_builder(parsed))
    produce_order_events(producer, topic)







