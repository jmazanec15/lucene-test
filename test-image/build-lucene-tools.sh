#!/usr/bin/env bash
# build-lucene-knn.sh
# Usage:
#   ./build-lucene-knn.sh TEST_REPO TEST_BRANCH LUCENEUTIL_REPO LUCENEUTIL_BRANCH
# Example:
#   ./build-lucene-knn.sh \
#     https://github.com/myorg/test.git main \
#     https://github.com/myorg/luceneutil.git main

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 TEST_REPO TEST_BRANCH LUCENEUTIL_REPO LUCENEUTIL_BRANCH" >&2
  exit 1
fi

TEST_REPO=$1
TEST_BRANCH=$2
LUCENEUTIL_REPO=$3
LUCENEUTIL_BRANCH=$4

echo "ℹ️  Cloning ${TEST_REPO}@${TEST_BRANCH}"
git clone --depth 1 --branch "${TEST_BRANCH}" "${TEST_REPO}" test-src

echo "▶️  Building test JAR"
pushd test-src >/dev/null
./gradlew --no-daemon jar
popd >/dev/null

echo "ℹ️  Cloning ${LUCENEUTIL_REPO}@${LUCENEUTIL_BRANCH}"
git clone --depth 1 --branch "${LUCENEUTIL_BRANCH}" "${LUCENEUTIL_REPO}" luceneutil-src

echo "▶️  Compiling luceneutil KNN task"
pushd luceneutil-src >/dev/null

# These settings have been generated automatically on the first run.
rm -rf  gradle.properties
echo "external.lucene.repo=/test-src" >> gradle.properties
echo "lucene.version=11.0.0" >> gradle.properties

./gradlew --no-daemon compileKnn
popd >/dev/null

echo "✅  Done"
