# Lucene Tests

## Overview

This repo contains a simple framework for running lucene benchmarks inside of a docker environment.

## Goals
The main goal of this project is to allow users to run highly-controlled performance tests on PoC code in 
an extremely efficient, yet configurable manner.

## Usage

The system is architected with around 2 docker-compose files: local and remote. In local mode, it will:
1. Build a custom test OpenSearch docker image based on provided Github repo and test branch
2. Run a single node cluster with the custom docker image and resource constraints.
3. Run a lightweight separate OpenSearch metric cluster for OSB to output results to (this collects all metrics in addition to final report)
4. Run the configured OSB workload and output results

In remote mode, it will just run the OSB workload against an external endpoint.

### Example usage

Before starting, you need to create a small script, `run.sh`, that contains all of the configs.
See [Parameters](#parameters) for more details.

To run end to end, 
```
./run.sh

# Stop the framework
docker compose -f compose-test.yaml down
```

### Parameters

In order to run a test, you need to configure your test environment:


| Key Name         | Description                                                                                                                                                                                                                                                                                                                           |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RUN_ID           | (String) Unique run identifier                                                                                                                                                                                                                                                                                                        |
| SHARE_DATA_PATH  | (String) File path where everything will be mounted. In this path, there should be a folder, lucene-data, which will be where lucene-data is stored. This allows for a different device to be used. In this path, you should put the necessary parameters and the necessary datasets because itll be accessible by the osb container. |
| LUCENEUTIL_REPO  | Git repository containing your luceneutil fork to build and run benchmarks |
| LUCENE_VERSION   | Version string used when building lucene |
| TEST_REPO        | Link to lucene repo. Plugin will be built from source from here.                                                                                                                                                                                                                                                                      |
| TEST_BRANCH      | Lucene branch name. Plugin will be built from source from here                                                                                                                                                                                                                                                                        |
| TEST_JVM         | Amount of JVM to be used for test container (i.e. 32g)                                                                                                                                                                                                                                                                                |
| TEST_CPU_COUNT   | Number of CPUs test container will get. (i.e. 2)                                                                                                                                                                                                                                                                                      |
| TEST_MEM_SIZE    | Amount of total memory test container will be limited at. (i.e. 4G)                                                                                                                                                                                                                                                                   |
| LUCENE_UTIL_ARGS | OSB procedure to be run                                                                                                                                                                                                                                                                                                               |

Here is an example `run.sh` for local:
```
#!/bin/bash
RUN_ID=
SHARE_DATA_PATH=
LUCENEUTIL_REPO=
TEST_REPO=
TEST_BRANCH=
LUCENE_VERSION=
TEST_JVM=
TEST_CPU_COUNT=
TEST_MEM_SIZE=
LUCENE_UTIL_ARGS=

docker compose -f compose-test.yaml up
```
