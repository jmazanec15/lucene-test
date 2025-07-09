#!/bin/bash

set -mxe

cd /luceneutil-src

./gradlew runKnnPerfTest
