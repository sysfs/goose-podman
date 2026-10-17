#!/usr/bin/env bash
# Build (or update) the goose image. Usage: ./goose-build.sh [vX.Y.Z]
# Without an argument the latest GitHub release is used.

set -euo pipefail

cd "$(dirname "$0")"

version="${1:-}"
if [ -z "$version" ]; then
  version=$(curl -fsSI https://github.com/aaif-goose/goose/releases/latest \
    | tr -d '\r' | sed -n 's#^[Ll]ocation: .*/releases/tag/##p')
fi
if [ -z "$version" ]; then
  echo "Error: could not determine goose release version." >&2
  exit 1
fi

echo "Building localhost/goose:${version}..."
podman build --pull=newer \
  --build-arg "GOOSE_VERSION=${version}" \
  -t "localhost/goose:${version}" \
  -t localhost/goose:latest \
  -f Containerfile .
