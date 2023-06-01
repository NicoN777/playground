import sys
import random
import time
from confluent_kafka import Producer
from confluent_kafka.serialization import IntegerSerializer
import argparse


def get_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog='python-kafka-producer',
                                     description="Producers data to the topic of your choice",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     add_help=True)
    parser.add_argument('-bs', '--bootstrap-servers', required=True)
    parser.add_argument('-t', '--topic', required=True)
    return parser


def conf_builder(parsed):
    conf = {'bootstrap.servers': parsed.bootstrap_servers}
    return conf


def get_producer(conf):
    producer = Producer(conf)
    cluster_metadata = producer.list_topics()
    print(f'Cluster metadata: {cluster_metadata}')
    return producer


def numbers_data_source():
    while True:
        key = random.choice((0, 1, 2, 3))
        value = random.randrange(1, 2147483647)
        yield key, value


def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))


if __name__ == '__main__':
    parser = get_argument_parser()
    parsed = parser.parse_args(sys.argv[1:])
    topic = parsed.topic
    producer = get_producer(conf_builder(parsed))
    integer_serializer = IntegerSerializer()
    for k, v in numbers_data_source():
        # Trigger any available delivery report callbacks from previous produce() calls
        producer.poll(0)
        # Asynchronously produce a message. The delivery report callback will
        # be triggered from the call to poll() above, or flush() below, when the
        # message has been successfully delivered or failed permanently.
        producer.produce(topic, key=integer_serializer(k), value=integer_serializer(v), callback=delivery_report)
        sleepers = random.choice((3, 4, 1, 5, 6))
        print(f'Sleeping for: {sleepers}')
        time.sleep(sleepers)
        # Wait for any outstanding messages to be delivered and delivery report
        # callbacks to be triggered.
        producer.flush()






