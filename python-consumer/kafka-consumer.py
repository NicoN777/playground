import sys
import confluent_kafka
import argparse


def get_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog='python-kafka-consumer',
                                     description="Consumes from the topic of your choice",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     add_help=True)
    parser.add_argument('-bs', '--bootstrap-servers', required=True)
    parser.add_argument('-cgid', '--consumer-group-id', required=True)
    parser.add_argument('-t', '--topics', action='extend', nargs="+", type=str, required=True)
    parser.add_argument('-aor', '--auto-offset-reset', default='earliest')

    return parser


def commit_callback(error, topic_partitions):
    if error:
        print(error)
    else:
        for topic_partition in topic_partitions:
            print(topic_partition)


def conf_builder(parsed):
    conf = {
        'bootstrap.servers': parsed.bootstrap_servers,
        'session.timeout.ms': 6000,
        'group.id': parsed.consumer_group_id,
        'on_commit': commit_callback,
        'auto.offset.reset': 'earliest'
    }

    return conf


def get_consumer(conf):
    consumer = confluent_kafka.Consumer(conf)
    cluster_metadata = consumer.list_topics()
    print(f'Cluster metadata: {cluster_metadata}')
    return consumer


if __name__ == '__main__':
    parser = get_argument_parser()
    parsed = parser.parse_args(sys.argv[1:])
    consumer = get_consumer(conf_builder(parsed))
    consumer.subscribe(parsed.topics)
    try:
        while True:
            record = consumer.poll(1.0)
            if not record:
                pass
            elif record.error():
                print('There was an error')
            else:
                topic, key, value = record.topic(), record.key().decode('utf-8') if record.key() else 'No Key', record.value().decode('utf-8')
                print(f'Topic: {topic}, Key: {key}, Value: {value}')
    except KeyboardInterrupt:
        print('Goodbye!')
    finally:
        consumer.close()



