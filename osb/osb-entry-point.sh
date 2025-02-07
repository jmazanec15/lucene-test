#!/bin/bash

set -x

DEFAULT_ENDPOINT="test:9200"

# Parse some arguments
export RUN_ID="$RUN_ID"
export PROCEDURE="$OSB_PROCEDURE"
export PARAMS_FILE="$OSB_PARAMS"
export TEST_ENDPOINT=${ENDPOINT:-"${DEFAULT_ENDPOINT}"}
export WORKLOAD_REPO=${OSB_WORKLOADS_REPO}
export IS_LOCAL=1
if [ -n "$ENDPOINT" ]; then
  IS_LOCAL=0
fi

# Just sleep for a minute initially in order to let other containers come up healthily
if [ ${IS_LOCAL} ]; then
  sleep 60
fi

# Confirm access to metrics cluster
if [ ${IS_LOCAL} ]; then
  echo "Confirming access to metrics cluster..."
  curl metrics:9202
fi

# Confirm access to test cluster
echo "Confirming access to test cluster..."
curl ${TEST_ENDPOINT}

SHARED_PATH=/share-data
RESULTS_PATH=${SHARED_PATH}/results

mkdir -p -m 777 ${RESULTS_PATH}

# Initialize OSB so benchmark.ini gets created and patch benchmark.ini
if [ ! -f "/opensearch-benchmark/.benchmark/benchmark.ini" ]; then
  echo "Initializing OSB..."
  mkdir -p -m 777 ~/.benchmark
  cp /benchmark.ini.patch ~/.benchmark/benchmark.ini
  if [ ${IS_LOCAL} ]; then
    # Get rid of data store
    sed -i 's/\(datastore\.type\).*/\1 =/' ~/.benchmark/benchmark.ini
    sed -i 's/\(datastore\.host\).*/\1 =/' ~/.benchmark/benchmark.ini
    sed -i 's/\(datastore\.port\).*/\1 =/' ~/.benchmark/benchmark.ini
    sed -i 's/\(datastore\.secure\).*/\1 =/' ~/.benchmark/benchmark.ini
    sed -i 's/\(datastore\.user\).*/\1 =/' ~/.benchmark/benchmark.ini
    sed -i 's/\(datastore\.password\).*/\1 =/' ~/.benchmark/benchmark.ini
  fi

  if [ -n WORKLOAD_REPO ]; then
      echo "" >> ~/.benchmark/benchmark.ini
      echo "[workloads]" >> ~/.benchmark/benchmark.ini
      echo "default.url = ${WORKLOAD_REPO}" >> ~/.benchmark/benchmark.ini
  fi

  cat ~/.benchmark/benchmark.ini

  opensearch-benchmark execute-test > /dev/null 2>&1
fi

# Run OSB and write output to a particular file in results
echo "Running OSB..."
opensearch-benchmark execute-test \
    --target-hosts ${TEST_ENDPOINT} \
    --workload vectorsearch \
    --workload-params ${PARAMS_FILE} \
    --pipeline benchmark-only \
    --test-procedure=${PROCEDURE} \
    --kill-running-processes \
    --results-format=csv \
    --results-file=${RESULTS_PATH}/osb-results-${RUN_ID}.csv | tee /tmp/output.txt
