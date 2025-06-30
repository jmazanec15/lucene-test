#!/bin/bash

set -mxe

echo "Starting Lucene Util"

SHARED_PATH=/share-data
PROFILE_PATH=${SHARED_PATH}/profiles
mkdir -p -m 777 ${PROFILE_PATH}

cd /luceneutil
ant run -Dargs="${LUCENE_UTIL_ARGS}" &
ENTRY_PID=$!

sleep 5

bash /process-stats-collector.sh ${ENTRY_PID} ${RUN_ID} &

fg %1
