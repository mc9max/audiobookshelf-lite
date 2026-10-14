#!/bin/sh
# Railway entrypoint for the Audiobookshelf template wrapper.
# Ensures the volume-backed config/metadata dirs exist, then execs the
# upstream CMD (node dist-server/index.js) passed as "$@" by tini.
set -x

: "${CONFIG_PATH:=/data/config}"
: "${METADATA_PATH:=/data/metadata}"

echo "ENTRYPOINT: PORT=$PORT CONFIG_PATH=$CONFIG_PATH METADATA_PATH=$METADATA_PATH"
mkdir -p "$CONFIG_PATH" "$METADATA_PATH"

# Exec the upstream server directly (do not rely on inherited CMD — Railway
# may clear it). Pinned to the upstream image's start command for v2.37.1.
exec node /app/dist-server/index.js
