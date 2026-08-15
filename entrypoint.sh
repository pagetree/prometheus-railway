#!/bin/sh
set -e

SCRAPE_INTERVAL="${SCRAPE_INTERVAL:-15s}"
EVALUATION_INTERVAL="${EVALUATION_INTERVAL:-15s}"
RETENTION_TIME="${RETENTION_TIME:-15d}"
LISTEN_PORT="${PORT:-9090}"

# Extra scrape targets:
# Format: "label=host:port label2=host2:port2"
# Example: "myapp=myapp.railway.internal:8080 api=api.railway.internal:3000"
SCRAPE_TARGETS="${SCRAPE_TARGETS:-}"

CONFIG_FILE="/etc/prometheus/prometheus.yml"

cat > "$CONFIG_FILE" <<EOF
global:
  scrape_interval:     ${SCRAPE_INTERVAL}
  evaluation_interval: ${EVALUATION_INTERVAL}

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:${LISTEN_PORT}']
EOF

if [ -n "$SCRAPE_TARGETS" ]; then
  for target in $SCRAPE_TARGETS; do
    JOB_NAME="${target%%=*}"
    HOST="${target#*=}"
    cat >> "$CONFIG_FILE" <<EOF

  - job_name: '${JOB_NAME}'
    static_configs:
      - targets: ['${HOST}']
EOF
  done
fi

echo "──────────────────────────────────────"
echo " Prometheus starting"
echo " Scrape interval : ${SCRAPE_INTERVAL}"
echo " Retention       : ${RETENTION_TIME}"
echo " Listen port     : ${LISTEN_PORT}"
echo " Config file     :"
cat "$CONFIG_FILE"
echo "──────────────────────────────────────"

exec /bin/prometheus \
  --config.file="$CONFIG_FILE" \
  --storage.tsdb.path=/prometheus \
  --storage.tsdb.retention.time="${RETENTION_TIME}" \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles \
  --web.listen-address="0.0.0.0:${LISTEN_PORT}"
