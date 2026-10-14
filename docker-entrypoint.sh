#!/bin/sh
# Railway entrypoint for the Audiobookshelf template wrapper.
# Ensures the volume-backed config/metadata dirs exist, then execs the
# upstream CMD (node dist-server/index.js) passed as "$@" by tini.
set -x

: "${CONFIG_PATH:=/data/config}"
: "${METADATA_PATH:=/data/metadata}"

echo "ENTRYPOINT: PORT=$PORT CONFIG_PATH=$CONFIG_PATH METADATA_PATH=$METADATA_PATH args=$*"
mkdir -p "$CONFIG_PATH" "$METADATA_PATH"
ls -la /app/dist-server/index.js || true

exec "$@"
