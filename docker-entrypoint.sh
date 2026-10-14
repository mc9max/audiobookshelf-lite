#!/bin/sh
# Railway entrypoint for the Audiobookshelf template wrapper.
# Ensures the volume-backed config/metadata dirs exist, then execs the
# upstream CMD (node dist-server/index.js) passed as "$@" by tini.
set -e

: "${CONFIG_PATH:=/data/config}"
: "${METADATA_PATH:=/data/metadata}"

mkdir -p "$CONFIG_PATH" "$METADATA_PATH"

exec "$@"
