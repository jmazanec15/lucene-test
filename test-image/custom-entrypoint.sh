#!/bin/bash

set -mxe

echo "Starting Opensearch"
./opensearch-docker-entrypoint.sh opensearch &
ENTRY_PID=$!
echo "Entry: ${ENTRY_PID}"
sleep 5
OS_PID=`ps aux | grep "[o]rg.opensearch.bootstrap.OpenSearch" | tr -s ' ' | cut -d ' ' -f2`
echo "OS: ${OS_PID}"

# Foreground original process
fg %1
