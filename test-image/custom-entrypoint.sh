#!/bin/bash

set -mxe

echo "Starting Opensearch"

SHARED_PATH=/share-data
PROFILE_PATH=${SHARED_PATH}/profiles
mkdir -p -m 777 ${PROFILE_PATH}

./opensearch-docker-entrypoint.sh opensearch &
ENTRY_PID=$!
echo "Entry: ${ENTRY_PID}"
sleep 5
OS_PID=`ps aux | grep "[o]rg.opensearch.bootstrap.OpenSearch" | tr -s ' ' | cut -d ' ' -f2`
echo "OS: ${OS_PID}"
# Collect lower level process stats
bash /process-stats-collector.sh ${OS_PID} ${RUN_ID} &
# Graceful shutdown poller lets other containers stop OS if necessary (so that profiles can be dumped)
bash /graceful-shutdown-poller.sh ${OS_PID} &
# Foreground original process
fg %1
