#!/bin/bash
set -e

cd "$(dirname "$0")/.."

export DOCKER_BUILDKIT=1

# Check if base already exists
if docker image inspect docker-lisp/base-racket > /dev/null 2>&1; then
  if [ "$1" != "--force-rebuild" ]; then
    echo "docker-lisp/base-racket (cached)"
    exit 0
  fi
fi

echo "Building docker-lisp/base-racket..."
docker build --platform=linux/amd64 -q -t docker-lisp/base-racket -f base-racket . > /dev/null
