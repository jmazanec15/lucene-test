#!/bin/bash

set -xe

export JAVA_HOME=/opt/java/openjdk-23
echo ${JAVA_HOME}
REPO_ENDPOINT=$1
REPO_BRANCH=$2
LUCENE_VERSION=$3
git clone -b $REPO_BRANCH $REPO_ENDPOINT TODO
cd k-NN
ARCH=$(arch)
if [ "$ARCH" = "x86_64" ]; then
    ARCHITECTURE=x64
else
    ARCHITECTURE=arm64
fi

bash scripts/build.sh -v ${LUCENE_VERSION} -s true -a ${ARCHITECTURE}
