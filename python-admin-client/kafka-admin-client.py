from confluent_kafka.admin import AdminClient, NewTopic
import argparse
import os
import sys


def check_env():
    required_env_vars = ['SASL_USERNAME', 'SASL_PASSWORD', 'TLS_DIR']
    if not all([_ in os.environ for _ in required_env_vars]):
        print(f'All {required} must be set')
        sys.exit(1)
    return True

def get_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog='python-kafka-producer',
                                     description="Producers data to the topic of your choice",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     add_help=True)
    parser.add_argument('-bs', '--bootstrap-servers', required=True)
    parser.add_argument('-t', '--topics-to-create', action='extend', nargs="+", type=str)
    return parser


def config_builder(parsed):
    hostname = os.popen("hostname").read().replace('\n', '')
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


def get_admin_client(conf):
    admin_client = AdminClient(conf)
    cluster_metadata = admin_client.list_topics()
    print(f'Cluster metadata: {cluster_metadata}')
    return admin_client


def create_topics(admin_client, topics):
    cluster_metadata = admin_client.list_topics()
    brokers = cluster_metadata.brokers
    partitions = len(brokers)
    replication_factor = len(brokers)
    new_topics = list(NewTopic(topic=topic_name, num_partitions=partitions, replication_factor=replication_factor) for topic_name in topics)
    create_topics_result = admin_client.create_topics(new_topics=new_topics)
    print(create_topics_result)


if __name__ == '__main__':
    if check_env():
        parser = get_argument_parser()
        parsed = parser.parse_args(sys.argv[1:])
        config = config_builder(parsed)
        admin_client = get_admin_client(config)
        if parsed.topics_to_create:
            print('Creating topics...')
            create_topics(admin_client, parsed.topics_to_create)








