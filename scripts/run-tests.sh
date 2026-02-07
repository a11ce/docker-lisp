#!/bin/bash
set -e

cd "$(dirname "$0")/.."

export DOCKER_BUILDKIT=1

force=""
if [ "$1" = "--force-rebuild" ]; then
  force="--force-rebuild"
fi

# Ensure builtins are built
./scripts/build-builtins.sh $force

passed=0
failed=0

for dockerfile in tests/*; do
  [ -f "$dockerfile" ] || continue
  name=$(basename "$dockerfile")

  echo -n "Testing $name... "

  # Build the test image
  docker build --platform=linux/amd64 -q -t "docker-lisp/test-$name" -f "$dockerfile" . > /dev/null

  # Run and capture output
  result=$(docker run --platform=linux/amd64 --rm "docker-lisp/test-$name")

  # Get expected value from label
  expected=$(docker inspect --format '{{ index .Config.Labels "expected" }}' "docker-lisp/test-$name")

  if [ "$result" = "$expected" ]; then
    echo "PASS"
    ((passed++))
  else
    echo "FAIL (expected '$expected', got '$result')"
    ((failed++))
  fi

  # Clean up test image
  docker rmi "docker-lisp/test-$name" > /dev/null 2>&1 || true
done

echo ""
echo "Results: $passed passed, $failed failed"

if [ $failed -gt 0 ]; then
  exit 1
fi
