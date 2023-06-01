FROM python:3
ARG SCRIPT_NAME="kafka-consumer.py"
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY $SCRIPT_NAME .
ENTRYPOINT ["python", "kafka-producer.py"]
CMD ["--bootstrap-servers", "localhost:19092", "--consumer-group-id", "test", "--topics", "time-events"]