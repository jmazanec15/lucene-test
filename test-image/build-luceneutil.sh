#!/bin/bash

# Build luceneutil using the lucene sources that were built in build-lucene.sh
# Arguments:
#   $1 - Git repository for luceneutil

set -xe

LUCENEUTIL_REPO=$1

git clone --depth 1 "$LUCENEUTIL_REPO" /luceneutil
cd /luceneutil
ant jar
cd /
