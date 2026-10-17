#!/usr/bin/env bash
# Run goose in a container with the current directory mounted at /workspace.
# Usage: ./goose-run.sh [goose arguments]   (default: session)

set -euo pipefail

workdir=$(pwd -W 2>/dev/null || pwd)

MSYS_NO_PATHCONV=1 exec podman run --rm -it \
  -v goose-data:/goose \
  -v "${workdir}:/workspace" \
  -e GOOSE_PROVIDER \
  -e GOOSE_MODEL \
  localhost/goose:latest "$@"
