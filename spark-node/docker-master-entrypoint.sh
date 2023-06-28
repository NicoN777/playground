

echo "Arguments: $@"
EXTRA_OPTION=${1}




SPARK_WORKERS_CONF = "${SPARK_HOME}/conf/workers"
{
  echo "#"
  echo "# Licensed to the Apache Software Foundation (ASF) under one or more"
  echo "# contributor license agreements.  See the NOTICE file distributed with"
  echo "# this work for additional information regarding copyright ownership."
  echo "# The ASF licenses this file to You under the Apache License, Version 2.0"
  echo "# (the \"License\"); you may not use this file except in compliance with"
  echo "# the License.  You may obtain a copy of the License at"
  echo "#"
  echo "#    http://www.apache.org/licenses/LICENSE-2.0"
  echo "#"
  echo "# Unless required by applicable law or agreed to in writing, software"
  echo "# distributed under the License is distributed on an \"AS IS\" BASIS,"
  echo "# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."
  echo "# See the License for the specific language governing permissions and"
  echo "# limitations under the License."
  echo "#"
  echo "# A Spark Worker will be started on each of the machines listed below."
  echo "#localhost"
  echo "spark-worker-node-1"
  echo "spark-worker-node-2"
  echo "spark-worker-node-3"
  echo "spark-worker-node-4"
  echo "spark-worker-node-5"
} > ${SPARK_WORKERS_CONF}

sh ${SPARK_HOME}/sbin/start-master.sh
tail -f /dev/null



