#!/bin/bash

# Build a custom version of Lucene from a given repository and branch.
set -xe

export JAVA_HOME=/opt/java/openjdk-23

REPO_ENDPOINT=$1
REPO_BRANCH=$2

git clone --depth 1 -b "$REPO_BRANCH" "$REPO_ENDPOINT" /lucene
cd /lucene
./gradlew publishToMavenLocal -x test
cd /
