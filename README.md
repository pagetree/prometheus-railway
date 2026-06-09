# Prometheus for Railway

One-click Prometheus deploy. **No config files. No GitHub forks.** Just set env vars and go.

[![Deploy on Railway]([![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/prometheus-grafana))

---

## What this does

Runs `prom/prometheus` with a config file **generated at startup from environment variables**. Self-scrapes by default — works immediately after deploy with zero configuration.

Add your own services to scrape by setting a single env var.

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SCRAPE_TARGETS` | _(empty)_ | Space-separated list of `label=host:port` targets to scrape |
| `SCRAPE_INTERVAL` | `15s` | How often Prometheus scrapes targets |
| `EVALUATION_INTERVAL` | `15s` | How often rules are evaluated |
| `RETENTION_TIME` | `15d` | How long to keep metrics data |
| `PORT` | `9090` | Port to listen on (Railway sets this automatically) |

---

## Adding scrape targets

Set `SCRAPE_TARGETS` in Railway's Variables tab:

```
myapp=myapp.railway.internal:8080 worker=worker.railway.internal:3000
```

Each `label=host:port` pair becomes a separate Prometheus scrape job. Use Railway's **private networking** hostnames (`.railway.internal`) so traffic stays internal.

That's it. Redeploy and Prometheus picks up the new targets.

---

## Pairing with Grafana

Deploy the companion [Grafana Railway template](https://github.com/YOUR_ORG/grafana-railway) and set its `PROMETHEUS_URL` variable to:

```
http://prometheus.railway.internal:9090
```

Grafana will have Prometheus pre-wired as the default data source on first boot.

---

## Volumes

Prometheus data is stored at `/prometheus`. Mount a Railway volume there to persist metrics across deploys.

---

## What's pre-configured

- Scrapes itself (`localhost:9090`) — visible immediately in Status → Targets
- Accepts `$PORT` from Railway so the health check works out of the box
- Minimal, readable entrypoint — inspect `entrypoint.sh` to see exactly what's generated
