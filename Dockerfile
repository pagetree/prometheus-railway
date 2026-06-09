FROM prom/prometheus:latest

# Switch to root to install bash and set up files
USER root

RUN apk add --no-cache bash gettext

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Prometheus data dir
VOLUME ["/prometheus"]

EXPOSE 9090

ENTRYPOINT ["/entrypoint.sh"]
