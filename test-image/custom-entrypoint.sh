#!/bin/bash

set -mxe

echo "Starting Lucene Util"

SHARED_PATH=/share-data
PROFILE_PATH=${SHARED_PATH}/profiles
mkdir -p -m 777 ${PROFILE_PATH}

# TODO: Somehow run custom lucene util.,

ENTRY_PID=0 #TODO
echo "Entry: ${ENTRY_PID}"
sleep 5
# TODO: Fix this
LUCENEUTIL_PID=`ps aux | grep "lucene" | tr -s ' ' | cut -d ' ' -f2`
echo "LUCENEUTIL: ${LUCENEUTIL_PID}"
# Collect lower level process stats

# TODO: bash /process-stats-collector.sh ${LUCENEUTIL_PID} ${RUN_ID} &
# Graceful shutdown poller lets other containers stop OS if necessary (so that profiles can be dumped)
# TODO: bash /graceful-shutdown-poller.sh ${LUCENEUTIL_PID} &
# Foreground original process
fg %1
