# goose in Podman

Runs the [goose](https://github.com/aaif-goose/goose) CLI in a Podman container, using the official
prebuilt Linux release binary (adapted from the
[goose-in-Docker tutorial](https://goose-docs.ai/docs/tutorials/goose-in-docker)).

## Build and update

```bash
./goose-build.sh          # latest release
./goose-build.sh v1.55.0  # specific release
```

Tags `localhost/goose:<version>` and `localhost/goose:latest`. Rerun it to update goose and the
`debian:bookworm-slim` base image (`--pull=newer`); unchanged layers and downloads are cached.
Older version tags are kept for rollback; remove them with `podman image rm localhost/goose:<version>`.

## Run

```bash
./goose-run.sh configure   # first time: choose provider, model and API key
./goose-run.sh             # start a session in the current directory
./goose-run.sh run --text "your instructions here"
```

The current directory is mounted at `/workspace`. Config, secrets and sessions persist in the
`goose-data` volume (`GOOSE_PATH_ROOT=/goose`). The keyring is disabled, so `configure` stores API
keys in a secrets file in that volume. `GOOSE_PROVIDER` and `GOOSE_MODEL` are passed through from the
host when set.

## TLS-inspecting proxies

Put the proxy's root CA as PEM `*.crt` files in `certs/` (git-ignored); they are added to the image
trust store. The Podman machine must also trust the CA to pull the base image:

```bash
podman machine ssh "sudo tee /etc/pki/ca-trust/source/anchors/corporate-ca.crt >/dev/null && sudo update-ca-trust" < certs/<ca>.crt
```
