FROM docker.io/library/debian:bookworm-slim

# Release tag to install, e.g. v1.55.0 (set by goose-build.sh).
ARG GOOSE_VERSION

RUN --mount=type=cache,id=goose-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=goose-apt-lists,target=/var/lib/apt/lists,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git libdbus-1-3 libxcb1

# Optional extra CAs (e.g. for a TLS-inspecting proxy): place *.crt files in certs/.
COPY certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN --mount=type=cache,id=goose-downloads,target=/var/cache/goose \
    test -n "$GOOSE_VERSION" \
 && archive="/var/cache/goose/goose-${GOOSE_VERSION}-$(uname -m)-unknown-linux-gnu.tar.gz" \
 && if [ ! -s "$archive" ]; then \
      curl -fsSL -o "$archive.part" \
        "https://github.com/aaif-goose/goose/releases/download/${GOOSE_VERSION}/goose-$(uname -m)-unknown-linux-gnu.tar.gz" \
      && mv "$archive.part" "$archive"; \
    fi \
 && tar -xzf "$archive" -C /usr/local/bin ./goose \
 && goose --version

# All goose config, secrets and sessions live under one mountable directory.
ENV GOOSE_PATH_ROOT=/goose \
    GOOSE_DISABLE_KEYRING=1

WORKDIR /workspace
ENTRYPOINT ["goose"]
CMD ["session"]
