# syntax=docker/dockerfile:1
# =============================================================================
# Railway Template: Audiobookshelf  (v1)
# Upstream: https://github.com/advplyr/audiobookshelf  (GPL-3.0)
# Image:    ghcr.io/advplyr/audiobookshelf:2.37.1@sha256:581d68b2a6fc7ebf58d81c878a9f387cbbc0d88ac9d37b298b9cee10168af85b
#           (pinned 2026-10-14 — upstream v2.37.1, released 2026-09-29)
# =============================================================================
# Why this wrapper:
#   * Upstream runs as root already (no USER directive in its Dockerfile), so
#     it can write to Railway's root-owned volumes without changes.
#   * All state (SQLite DB under CONFIG_PATH, covers/cache under
#     METADATA_PATH) is redirected onto a single Railway volume mounted at
#     /data: CONFIG_PATH=/data/config, METADATA_PATH=/data/metadata
#     (upstream defaults are /config and /metadata). The entrypoint creates
#     both dirs on every boot so first-run and restarts never hit a missing
#     directory.
#   * Port: upstream reads process.env.PORT (index.js:
#     `options.port || process.env.PORT || 3333`). Railway injects its own
#     PORT at runtime (default 8080), which overrides the image's
#     ENV PORT=80 — never hardcode PORT in the wrapper.
#   * No in-container HEALTHCHECK (base has no curl/wget) — Railway's
#     external healthcheck (healthcheckPath="/") runs instead.
#   * First boot serves the web-based initial setup (create the admin user);
#     fully usable behind Railway's proxy. No variables to configure.
FROM ghcr.io/advplyr/audiobookshelf:2.37.1@sha256:581d68b2a6fc7ebf58d81c878a9f387cbbc0d88ac9d37b298b9cee10168af85b

USER root

#   * Upstream serves the client under ROUTER_BASE_PATH "/audiobookshelf"
#     (default) — the client bundle has that base path baked in, so it MUST
#     NOT be overridden: setting ROUTER_BASE_PATH=/ makes the HTML shell
#     load but every /audiobookshelf/_nuxt/* asset 404s (page stuck on
#     "Loading..."). The app lives at https://<domain>/audiobookshelf and
#     the healthcheck hits that path.
ENV CONFIG_PATH=/data/config
ENV METADATA_PATH=/data/metadata

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/railway-entrypoint.sh

# Keep tini as PID 1 (inherited ENTRYPOINT ["tini", "--"]) and run our
# entrypoint, which prepares the volume dirs then execs the upstream CMD.
ENTRYPOINT ["tini", "--", "/usr/local/bin/railway-entrypoint.sh"]

EXPOSE 8080

LABEL org.opencontainers.image.source="https://github.com/mc9max/audiobookshelf-lite"
LABEL org.opencontainers.image.description="Audiobookshelf Railway template"
