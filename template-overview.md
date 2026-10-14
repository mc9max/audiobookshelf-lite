# Deploy and Host Audiobookshelf with Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/audiobookshelf-2)

Audiobookshelf is the open-source self-hosted audiobook and podcast server: organize your audiobook collection with rich metadata, sync listening progress across the web player and mobile apps, subscribe to podcasts with automatic downloads, and transcode on the fly with bundled ffmpeg.

## About Hosting Audiobookshelf

This template deploys Audiobookshelf as a single Railway service from a pinned upstream image (`ghcr.io/advplyr/audiobookshelf` v2.37.1). The app is a Node.js server with an embedded SQLite database — no external database service needed. A 1 GB Railway volume mounted at `/data` holds the database (`/data/config`) and covers/cache (`/data/metadata`), so libraries, users, and progress survive redeploys and restarts. Railway assigns a public HTTPS URL on deploy; open it at the `/audiobookshelf` path (e.g. `https://<your-domain>/audiobookshelf`) and run the web-based initial setup to create your admin user.

## Why Deploy

- **Always-on by nature.** Podcast auto-downloads, library scans, and scheduled tasks run around the clock — the service earns its keep.
- **Real compute burn.** On-the-fly ffmpeg transcoding and audio processing give this template a genuinely worker-heavy profile.
- **Zero database to manage.** SQLite is embedded; the template wires nothing external and costs nothing extra.
- **Zero-variable deploy.** The form is empty — port, paths, and defaults are all baked into the wrapper.

## Common Use Cases

- **Audiobook library** — author/series organization, bookmarks, and per-user progress tracking.
- **Podcast server** — RSS subscriptions with automatic episode downloads.
- **Family sharing** — separate users and progress on one server.
- **Mobile listening** — progress syncs between the web player and the iOS/Android apps.

## Dependencies for Audiobookshelf Hosting

- **Railway account** (Hobby or higher recommended for always-on; ~150–300 MB RAM at rest, more while transcoding).
- **1 GB volume** at `/data` (provisioned automatically by the template).
- **Your audio files** — add libraries after setup via the web UI (upload or point at mounted media).
- **Upstream image** `ghcr.io/advplyr/audiobookshelf:2.37.1`, pinned by digest (GPL-3.0 licensed).

### Deployment Dependencies

- Source repository `https://github.com/mc9max/audiobookshelf-lite` (Dockerfile wrapper, pinned digest, runs as root so the SQLite database writes to the root-owned volume; config/metadata redirected to `/data`).
- Railway-provided `PORT` (default 8080) — the app follows it natively (`options.port || process.env.PORT || 3333` in upstream source); no variables to configure.
- [Railway health checks](https://docs.railway.com/guides/healthchecks) on `/`.
- [Template best practices](https://docs.railway.com/templates/best-practices)
