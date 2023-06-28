MASTER_URL=${1}
echo "This is the master URL I (as a Worker) will connect to: ${MASTER_URL}"
sh ${SPARK_HOME}/sbin/start-worker.sh $MASTER_URL
tail -f /dev/null