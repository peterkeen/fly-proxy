FROM alpine:latest as builder
WORKDIR /app
COPY . ./

FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.18.1_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && tar xzf ${TSFILE} --strip-components=1
COPY . ./

FROM nginx:1.19.6-alpine
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

COPY --from=builder /app/proxy.conf /etc/nginx/conf.d/proxy.conf
COPY --from=builder /app/resolv.conf /etc/resolv.conf
COPY --from=builder /app/block.conf /etc/nginx/block.conf
COPY --from=builder /app/40-clear-cache.sh /docker-entrypoint.d
COPY --from=builder /app/start.sh /app/start.sh

COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

CMD ["/app/start.sh"]
