# Deploy and Host

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/new/template/homepage)

> **Canonical code:** `homepage` — deploy URL: https://railway.com/new/template/homepage

![OG Image](https://raw.githubusercontent.com/INAPP-Mobile/railway-homepage/main/og-image.svg)

Homepage is a modern, highly-configurable self-hosted application dashboard with 100+ service integrations. Deploy it on Railway in minutes to turn your stack into a beautiful start page.

## About Hosting

Homepage runs as a single container with a persistent Railway volume for config (`/app/config`). Railway provides the compute, TLS at the edge, and a public URL. The service restarts automatically on failures via Railway's built-in health check. No external database or cache is needed — everything runs in one container.

## Why Deploy

- **100+ service integrations** — Plex, Sonarr, Radarr, Grafana, GitHub, Docker, Kubernetes, Home Assistant, Uptime Kuma, and many more widgets with live status.
- **Zero external dependencies** — Single container with a persistent volume. No PostgreSQL, no Redis, no sidecars.
- **Drag-and-drop layout** — Widgetized cards, collapsible groups, search bar with keyboard shortcuts, and per-user settings.
- **Themeable UI** — Dark, light, neon, glassmorphism, and more. Custom backgrounds supported.
- **Persistent config** — All settings survive redeploys via the Railway volume mount.
- **Ships with sensible defaults** — Dark theme, Railway PORT binding, English locale — ready out of the box.

## Common Use Cases

- **Personal dashboard** — Aggregate all your self-hosted services into one beautiful start page.
- **Team operations hub** — Share a dashboard with your team showing CI/CD status, monitoring, and deployment links.
- **Homelab control center** — Monitor and access all your homelab services from a single pane of glass.
- **New tab replacement** — Set Homepage as your browser's new tab page for instant access to everything.
- **Status board** — Display live service status on a dedicated monitor or kiosk.

## Dependencies for Homepage

### Deployment Dependencies

Homepage requires no external dependencies on Railway. It runs as a standalone Next.js server with a persistent Railway volume for configuration files. No database, cache, or third-party services are needed.

---

[![Homepage](https://img.shields.io/badge/Homepage-v1.13.2-1e3a8a?logo=homepagecommunity)](https://github.com/gethomepage/homepage)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/gethomepage/homepage/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/gethomepage/homepage?style=social)](https://github.com/gethomepage/homepage)

## 🚀 One-Click Deploy

Click the button above to deploy **Homepage** to Railway instantly. The build uses our pinned, reproducible Dockerfile (Homepage v1.13.2).

## 📋 Description

**Homepage** is a modern, highly-configurable self-hosted application dashboard with **100+ service integrations**. It turns your Railway stack into a beautiful start page featuring live status, monitoring widgets, bookmarks, and custom service cards — everything you need at a glance when you open a new tab.

This template ships a **production-ready single-container deployment**:

- ✅ Pinned upstream (Homepage `v1.13.2`, released June 9 2026)
- ✅ Auto-injected persistent Railway volume for `/app/config`
- ✅ Sensible defaults — dark theme, Railway PORT binding, language `en`
- ✅ Healthcheck endpoint tuned for Railway's monitoring
- ✅ Non-root runtime (upstream image convention preserved)
- ✅ Env-var-driven config — no manual file editing required (but supported)
- ✅ GitHub Actions security lint on every PR

### ✨ Features

- **100+ service integrations**: Plex, Sonarr, Radarr, Grafana, GitHub, Docker, Home Assistant, Uptime Kuma, and many more — [full list](https://gethomepage.dev/widgets/).
- **Drag-and-drop layout** with widgetized cards, collapsible groups, search bar, and per-user settings.
- **Live status** synced every 30s — click any service to open its web UI.
- **Themeable** — dark, light, neon, glassmorphism and others. Custom backgrounds supported.
- **Persistent config** survives every Railway redeploy via volume mount.
- **No external dependencies** — single container, no database or cache required.

### 🖼️ Screenshots

*(The Publisher stage normally captures 3 screenshots of the live deployment and inserts them here. For this offline build, see the preview image above.)*

## 🏗️ Architecture

```
Railway Container
  ├── Homepage (Next.js) → :$PORT, healthcheck GET /
  └── Persistent Volume → /app/config (settings, services, bookmarks, widgets, icons)
```

Single web service. One Railway volume. No database, no Redis, no extra sidecars. Healthcheck: GET / → 200 OK. Restart: ON_FAILURE (5 retries). HTTPS at Railway edge (TLS automatic).

## 🔧 Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `PORT` | no | `8080` | Container port. Railway injects this automatically; Homepage (Next.js) honors it. |
| `HOMEPAGE_ALLOWED_HOSTS` | **yes** | `*` | Comma-separated hosts allowed to serve Homepage (required by Homepage v1.0+). Railway serves from a dynamic `*.railway.app` domain, so `*` disables the host check. For tighter security set your real domain(s), e.g. `mydash.railway.app`. Without this, requests are rejected with a "Disallowed Host" error. |
| `HOMEPAGE_VAR_DEFAULT_THEME` | no | `dark` | UI theme on first load (`dark`, `light`, `neon`, `glassmorphism`, …). Applied only if your config YAML uses the `{{HOMEPAGE_VAR_DEFAULT_THEME}}` placeholder. |
| `HOMEPAGE_VAR_TITLE` | no | *(empty)* | Optional: title shown in the browser tab. Applied only if config YAML uses `{{HOMEPAGE_VAR_TITLE}}`. |
| `HOMEPAGE_VAR_LANGUAGE` | no | *(empty)* | UI language code (e.g., `en`, `fr`, `de`). Applied only if config YAML uses `{{HOMEPAGE_VAR_LANGUAGE}}`. |

> `HOMEPAGE_VAR_*` tokens substitute into your config YAML `{{HOMEPAGE_VAR_XXX}}` placeholders on container start. With an empty `/app/config` they have no visible effect until a matching `settings.yaml` is added. There is **no** `HOMEPAGE_PORT` or `LOG_LEVEL` env var in Homepage — port binding is handled by Railway's injected `PORT`.

## 🧩 Configuring your dashboard

Homepage reads YAML config files from the persistent volume at `/app/config`.

### Option A — Visual editor (recommended)

Deploy, open the live URL, click ⚙️ to customize, and click Save. Config persists to the Railway volume automatically.

### Option B — File-based config

If you prefer YAML, clone the repo, edit `config/settings.yaml`, and redeploy. The volume at `/app/config` loads your files on start. Reference: <https://github.com/gethomepage/homepage/tree/main/kubernetes>

## 🛠️ Local Development

```bash
git clone https://github.com/INAPP-Mobile/railway-homepage.git && cd railway-homepage
cp .env.example .env && $EDITOR .env
docker build -t railway-homepage .
docker run -d --name homepage -p 3000:3000 -v "$(pwd)/config:/app/config" --env-file .env railway-homepage
curl -sf http://localhost:3000/ | head -20
```

Open <http://localhost:3000> in your browser.

## 🧪 Testing

```bash
docker build -t railway-homepage .
docker run --rm -p 3000:3000 railway-homepage & sleep 10
curl -sf http://localhost:3000/ && echo OK
```

## 🐛 Troubleshooting

| Issue | Solution |
|---|---|
| Container exits immediately | Check Railway logs — usually a malformed `HOMEPAGE_VAR_*`. |
| Theme/Widgets reset on redeploy | Confirm `/app/config` volume is still mounted. |
| Health checks failing | Raise `start-period` in `railway.json`; first-build cold cache may take longer. |
| Port already in use | Railway auto-routes via the injected `PORT`; no `HOMEPAGE_PORT` override exists. |
| "Disallowed Host" error | Set `HOMEPAGE_ALLOWED_HOSTS` to include your Railway domain (or `*` to disable the check). |

For upstream-specific issues, consult <https://github.com/gethomepage/homepage/issues>.

## 🔄 Updating

This template pins Homepage to `v1.13.2`. To upgrade:

1. Edit the `FROM` line in `Dockerfile` to a newer tag (e.g. `v1.14.0`).
2. Rebuild — Railway auto-detects a Dockerfile change.
3. Confirm the new version against the [release notes](https://github.com/gethomepage/homepage/releases).

A GitHub Actions workflow (`.github/workflows/publish-lint.yml`) prevents publishing regressions.

## 📄 License

Homepage upstream is [MIT-licensed](https://github.com/gethomepage/homepage/blob/main/LICENSE). Template by [INAPP-Mobile](https://github.com/INAPP-Mobile). Issues/PRs: <https://github.com/INAPP-Mobile/railway-homepage>.
