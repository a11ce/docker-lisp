#!/bin/bash
set -e

cd "$(dirname "$0")/.."

export DOCKER_BUILDKIT=1

force=""
if [ "$1" = "--force-rebuild" ]; then
  force="--force-rebuild"
fi

# Ensure base is built
./scripts/build-base.sh $force

echo "Building builtins..."
for dockerfile in builtins/*; do
  [ -f "$dockerfile" ] || continue
  name=$(basename "$dockerfile")

  # Skip if already built (unless --force-rebuild)
  if [ -z "$force" ] && docker image inspect "docker-lisp/$name" > /dev/null 2>&1; then
    echo "  $name (cached)"
    continue
  fi

  echo "  $name"
  docker build --platform=linux/amd64 -q -t "docker-lisp/$name" -f "$dockerfile" . > /dev/null
done

echo "Done!"
