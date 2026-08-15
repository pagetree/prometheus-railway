# Prometheus for Railway

One-click Prometheus deploy. No config files. No GitHub forks. Set env vars and go.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/prometheus-grafana)

Full stack template: [Prometheus + Grafana](https://railway.com/deploy/prometheus-grafana)

---

## What this does

Runs `prom/prometheus` with a config file generated at startup from environment variables. Self scrapes by default so it works immediately after deploy.

Add your own services to scrape with a single env var.

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `9090` | Keep this set to `9090` so private networking and Grafana wiring stay correct |
| `SCRAPE_TARGETS` | _(empty)_ | Space separated list of `label=host:port` targets to scrape |
| `SCRAPE_INTERVAL` | `15s` | How often Prometheus scrapes targets |
| `EVALUATION_INTERVAL` | `15s` | How often rules are evaluated |
| `RETENTION_TIME` | `15d` | How long to keep metrics data |

---

## Adding scrape targets

Set `SCRAPE_TARGETS` in Railway Variables:

```
myapp=myapp.railway.internal:8080 worker=worker.railway.internal:3000
```

Each `label=host:port` pair becomes a separate scrape job. Prefer Railway private hostnames (`.railway.internal`).

Redeploy and Prometheus picks up the new targets.

---

## Pairing with Grafana

Use the combined template above, or deploy Grafana beside this service in the same Railway project.

On Grafana, set:

```
PROMETHEUS_URL=http://${{prometheus-railway.RAILWAY_PRIVATE_DOMAIN}}:${{prometheus-railway.PORT}}
```

That resolves to something like:

```
http://prometheus-railway.railway.internal:9090
```

Grafana provisions Prometheus as the default datasource on boot.

---

## Volumes

Store metrics under `/prometheus`. Attach a Railway volume at that path. Do not use a Dockerfile `VOLUME` instruction. Railway rejects those.

---

## Health check

Railway health check path: `/-/healthy`

---

## What's pre-configured

- Self scrape on `localhost:$PORT`
- Listens on `0.0.0.0:$PORT`
- Config generated from env vars in `entrypoint.sh`
