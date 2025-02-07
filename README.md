# OpenSearch Single Node KNN Experiments

## Overview

This repo contains a simple framework for running single node OpenSearch experiments for the k-NN plugin, using 
[Docker compose](https://docs.docker.com/compose/) and [OpenSearch Benchmarks](https://opensearch.org/docs/latest/benchmark/).

## Goals
The main goal of this project is to allow users to run highly-controlled performance tests on PoC code in 
an extremely efficient, yet configurable manner.

## Usage

The system is architected with a single [docker-compose file](compose.yaml). It has 2 profiles: local and remote. In local mode, it will:
1. Build a custom test OpenSearch docker image based on provided Github repo and test branch
2. Run a single node cluster with the custom docker image and resource constraints.
3. Run a lightweight separate OpenSearch metric cluster for OSB to output results to (this collects all metrics in addition to final report)
4. Run the configured OSB workload and output results

In remote mode, it will just run the OSB workload against an external endpoint.

### Example usage

Before starting, you need to create an environment variable file, test.env, that contains all of the configs. 
See [Parameters](#parameters) for more details. 

To run end to end, 
```
docker compose --env-file test.env -f compose.yaml --profile local up

# Stop the framework
docker compose --env-file test.env -f compose.yaml --profile local down
```

If you want to just execute against a remote cluster,
```
docker compose --env-file test.env -f compose.yaml --profile remote up

# Stop the framework
docker compose --env-file test.env -f compose.yaml --profile remote down
```

### Parameters

In order to run a test, you need to configure your test environment:


| Key Name           | Profiles     | Description                                                                                                                                                                                                                                                                                                                   |
|--------------------|:-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RUN_ID             | local,remote | (String) Unique run identifier                                                                                                                                                                                                                                                                                                |
| SHARE_DATA_PATH    | local,remote | (String) File path where everything will be mounted. In this path, there should be a folder, os-data, which will be where os-data is stored. This allows for a different device to be used. In this path, you should put the necessary parameters and the necessary datasets because itll be accessible by the osb container. |
| OSB_WORKLOADS_REPO | local,remote | Repo containing custom OSB workloads. If you want to add custom extensions, etc, fork the workloads, add them to main branch, and push. By default, it will be the default workloads                                                                                                                                          |
| ENDPOINT           | remote       | Remote endpoint to test against. Should include port, if necessary.                                                                                                                                                                                                                                                           |
| OPENSEARCH_VERSION | local        | Version of OpenSearch to use (i.e. 3.0.0 or 2.15.0)                                                                                                                                                                                                                                                                           |
| TEST_REPO          | local        | Link to k-NN repo. Plugin will be built from source from here. (i.e. https://github.com/opensearch-project/k-NN.git)                                                                                                                                                                                                          |
| TEST_BRANCH        | local        | k-NN branch name. Plugin will be built from source from here                                                                                                                                                                                                                                                                  |
| TEST_JVM           | local        | Amount of JVM to be used for test container (i.e. 32g)                                                                                                                                                                                                                                                                        |
| TEST_CPU_COUNT     | local        | Number of CPUs test container will get. (i.e. 2)                                                                                                                                                                                                                                                                              |
| TEST_MEM_SIZE      | local        | Amount of total memory test container will be limited at. (i.e. 4G)                                                                                                                                                                                                                                                           |
| METRICS_JVM        | local        | Amount of JVM to be used for metrics container (i.e. 1g)                                                                                                                                                                                                                                                                      |
| METRICS_CPU_COUNT  | local        | Number of CPUs metrics container will get. (i.e. 2)                                                                                                                                                                                                                                                                           |
| METRICS_MEM_SIZE   | local        | Amount of total memory metrics container will be limited at. (i.e. 4G)                                                                                                                                                                                                                                                        |
| OSB_PROCEDURE      | local,remote | OSB procedure to be run                                                                                                                                                                                                                                                                                                       |
| OSB_PARAMS         | local,remote | OSB params to be used (include .json extension)                                                                                                                                                                                                                                                                               |
| OSB_CPU_COUNT      | local,remote | Number of CPUs OSB gets (i.e 2)                                                                                                                                                                                                                                                                                               |
| OSB_MEM_SIZE       | local,remote | Amount of memory OSB gets (i.e. 4g)                                                                                                                                                                                                                                                                                           |

Here is an example `test.env` for local:
```
RUN_ID=coherev2-10m-on_disk-32x
SHARE_DATA_PATH=/share-data
OSB_WORKLOADS_REPO=https://github.com/jmazanec15/opensearch-benchmark-workloads
OPENSEARCH_VERSION=2.19.0
TEST_REPO=https://github.com/opensearch-project/k-NN.git
TEST_BRANCH=2.19
TEST_JVM=30517M
TEST_CPU_COUNT=8
TEST_MEM_SIZE=45232M
METRICS_JVM=1G
METRICS_CPU_COUNT=2
METRICS_MEM_SIZE=4G
OSB_PROCEDURE=derived-source-test
OSB_PARAMS=/share-data/osb/params.json
OSB_CPU_COUNT=5
OSB_MEM_SIZE=16G
```

Here is an example `test.env` for remote:
```
RUN_ID=coherev2-10m-on_disk-32x
SHARE_DATA_PATH=/share-data
OSB_WORKLOADS_REPO=https://github.com/jmazanec15/opensearch-benchmark-workloads
ENDPOINT="localhost:9200"
OSB_PROCEDURE=derived-source-test
OSB_PARAMS=/share-data/osb/params.json
OSB_CPU_COUNT=5
OSB_MEM_SIZE=16G
```


### Configuring OSB

For this framework, we want to avoid adding OpenSearch Benchmark custom code. Instead, you should fork the 
[workloads repo](https://github.com/opensearch-project/opensearch-benchmark-workloads), make your custom changes, and set it via the ${OSB_WORKLOADS_REPO} parameter.

## Results

OSB will output its results to the "${SHARE_DATA}/results" path. In it, there will be a csv file that contains the OSB report. 
