FROM alpine:latest
RUN apk add --no-cache bind-tools curl jq util-linux-misc ; \
    mkdir /app
ADD . /app
WORKDIR /app
ENTRYPOINT ["/app/digitalocean_ddns_updater.sh"]
