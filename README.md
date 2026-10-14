# Audiobookshelf on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/audiobookshelf-2?utm_campaign=audiobookshelf-lite)

Self-hosted audiobook and podcast server. Audiobookshelf turns your audiobook collection into a beautiful streaming library — track progress across devices, manage podcasts with auto-downloads, and transcode on the fly. One click deploys it on Railway with zero configuration.

Upstream: [advplyr/audiobookshelf](https://github.com/advplyr/audiobookshelf) (GPL-3.0). This repo is a thin deployment wrapper around the pinned upstream image `ghcr.io/advplyr/audiobookshelf:2.37.1`; no application code is modified.

## Deploy and Host

Click **Deploy on Railway** above. The deploy form is empty — there is nothing to configure. Railway provisions a 1 GB volume, starts the service, and assigns a public HTTPS URL. Open the URL and complete the web-based initial setup to create your admin user, then add your first library.

## Why Deploy

- **Your library, everywhere.** Stream audiobooks to the web player or the iOS/Android apps with progress synced across devices.
- **Podcasts included.** Subscribe to RSS feeds with automatic episode downloads — a worker-heavy workload that keeps the service productively busy.
- **On-the-fly transcoding.** Bundled ffmpeg converts formats per device without pre-processing your files.
- **Zero database to manage.** Embedded SQLite lives on the Railway volume; no external database service needed.

## Common Use Cases

- **Audiobook library** — organize by author/series with rich metadata, bookmarks, and per-user progress.
- **Podcast server** — auto-download episodes and stream them anywhere.
- **Family sharing** — separate users, separate progress, one server.
- **Offline-first listening** — the mobile apps cache downloads for commutes and flights.

### Deployment Dependencies

- **Railway account** (Hobby or higher recommended for always-on; ~150–300 MB RAM at rest, more while transcoding).
- **1 GB volume** at `/data` (provisioned automatically by the template) holding the SQLite database (`/data/config`) and covers/cache (`/data/metadata`).
- **Upstream image** `ghcr.io/advplyr/audiobookshelf:2.37.1`, pinned by digest (GPL-3.0 licensed).
- Railway-provided `PORT` (default 8080) — the app follows it natively; health check on `/`.

## Details

- **Runtime:** Node.js (upstream image), runs as root so the SQLite database writes cleanly to the root-owned Railway volume.
- **Port:** whatever Railway injects via `PORT` (verified in upstream source: `options.port || process.env.PORT || 3333`).
- **Persistence:** everything lives under the `/data` volume; redeploys and restarts keep libraries, users, and progress.
- **Public URL:** Railway assigns one automatically on deploy (`Settings → Networking → Generate Domain` if needed).
