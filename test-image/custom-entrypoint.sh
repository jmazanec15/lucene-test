#!/bin/bash

set -mxe

cd /luceneutil-src
python src/python/initial_setup.py
./gradlew runKnnPerfTest
