FROM alpine:latest
ADD --chown=root:root ./app /app
RUN \
    apk add --no-cache bind-tools curl jq util-linux-misc ; \
    chmod 755 /app/digitalocean_ddns_updater.sh ; \
    chmod 400 /app/.env
WORKDIR /app
ENTRYPOINT ["/app/digitalocean_ddns_updater.sh"]
