# SOP to run tests

## Prereqs

sudo yum install gcc-c++ tmux git docker -y
sudo sysctl -w vm.max_map_count=262144

sudo service docker start
sudo usermod -a -G docker ec2-user
sudo sysctl kernel.perf_event_paranoid=1
sudo sysctl kernel.kptr_restrict=0


## Build docker image
docker build --no-cache \
  --build-arg TEST_REPO=https://github.com/jmazanec15/lucene \
  --build-arg TEST_BRANCH=main \
  --build-arg LUCENEUTIL_REPO=https://github.com/jmazanec15/luceneutil \
  --build-arg LUCENEUTIL_BRANCH=jack-dev \
  -f ./Dockerfile.testbuild \
  -t lucene-test:latest \
  .

## Run experiments with relevant args



## Start metrics monitoring
echo "Waiting for Lucene process to start..."
while true; do
  LUCENE_PID=$(ps aux | grep KnnGraph | grep -v grep | awk '{print $2}')
  if [ -n "$LUCENE_PID" ]; then
    echo "Found Lucene process with PID: $LUCENE_PID"
    bash process-stats-collector.sh ${LUCENE_PID} test-2
    break
  fi
  echo "Waiting for Lucene process..."
  sleep 1
done

## Run experiments with relevant args
MEM_IN_GB=""
BP_FLAG="false"
docker run --cpus="12" -m ${MEM_IN_GB}g --rm lucene-test:latest --bp=${BP_FLAG}

## Collect Results
....



