#!/bin/bash

set -x

# Parse some arguments
export RUN_ID="$RUN_ID"
export PROCEDURE="$OSB_PROCEDURE"
export PARAMS_FILE="$OSB_PARAMS"

# Just sleep for a minute initially in order to let other containers come up healthily
sleep 60

# Confirm access to metrics cluster
echo "Confirming access to metrics cluster..."
curl metrics:9202

# Confirm access to test cluster
echo "Confirming access to test cluster..."
curl test:9200

SHARED_PATH=/share-data
RESULTS_PATH=${SHARED_PATH}/results

mkdir -p -m 777 ${RESULTS_PATH}

# Initialize OSB so benchmark.ini gets created and patch benchmark.ini
if [ ! -f "/opensearch-benchmark/.benchmark/benchmark.ini" ]; then
  echo "Initializing OSB..."
  mkdir -p -m 777 ~/.benchmark
  cp /benchmark.ini.patch ~/.benchmark/benchmark.ini
  opensearch-benchmark execute-test > /dev/null 2>&1
  cat ~/.benchmark/benchmark.ini
fi


# Run OSB and write output to a particular file in results
echo "Running OSB..."
export ENDPOINT=test:9200
opensearch-benchmark execute-test \
    --target-hosts $ENDPOINT \
    --workload vectorsearch \
    --workload-params ${PARAMS_FILE} \
    --pipeline benchmark-only \
    --test-procedure=${PROCEDURE} \
    --kill-running-processes \
    --results-format=csv \
    --results-file=${RESULTS_PATH}/osb-results-${RUN_ID}.csv | tee /tmp/output.txt

cat /opensearch-benchmark/.benchmark/benchmarks/workloads/default/vectorsearch/workload.json
cp /opensearch-benchmark/.benchmark/logs/benchmark.log /share-data
