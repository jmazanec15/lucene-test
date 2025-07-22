#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------
# Helper to drop the page cache (needs privileged or SYS_ADMIN)
drop_cache() {
  echo "→ Dropping page cache …"
  sync                     # flush dirty pages
  echo 3 > /proc/sys/vm/drop_caches
  echo "✓ Cache cleared"
}

BP_FLAG="true"
while [[ $# -gt 0 ]]; do
  case $1 in
    --bp=*)
      BP_FLAG="${1#*=}"
      shift
      ;;
    *)
      # Unknown option
      shift
      ;;
  esac
done
echo "BP_FLAG is ${BP_FLAG}"
# ------------------------------------------------------------------
# Phase 0: setup
echo "=== Phase 0: setup ==="
cd /luceneutil-src
python src/python/initial_setup.py

# Phase 1: KNN perf
echo "=== Phase 1: perf ==="
./gradlew runKnnPerfTest  -Pbp=${BP_FLAG}  -PjvmSize=8g

echo "🔥 All phases finished successfully."
