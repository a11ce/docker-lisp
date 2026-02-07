#!/bin/bash
set -e

cd "$(dirname "$0")/.."

export DOCKER_BUILDKIT=1

usage() {
  echo "Usage: $0 [options] <dockerfile>"
  echo ""
  echo "Options:"
  echo "  -t, --tag NAME    Tag for the image (default: docker-lisp/<filename>)"
  echo "  -h, --help        Show this help"
  echo ""
  echo "Examples:"
  echo "  $0 builtins/atom-p"
  echo "  $0 -t my-program my-program.dockerfile"
}

tag=""
dockerfile=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--tag)
      tag="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      dockerfile="$1"
      shift
      ;;
  esac
done

if [ -z "$dockerfile" ]; then
  usage
  exit 1
fi

if [ -z "$tag" ]; then
  tag="docker-lisp/$(basename "$dockerfile")"
fi

echo "Building $tag..."
docker build --platform=linux/amd64 -q -t "$tag" -f "$dockerfile" . > /dev/null
echo "Done!"
