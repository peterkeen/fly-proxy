FROM alpine:latest as builder
WORKDIR /app
COPY . ./

FROM nginx:stable-alpine
RUN apk add --no-cache ca-certificates iptables ip6tables tailscale && rm -rf /var/cache/apk/*

COPY --from=builder /app/proxy.conf /etc/nginx/conf.d/proxy.conf
COPY --from=builder /app/resolv.conf /etc/resolv.conf
COPY --from=builder /app/block.conf /etc/nginx/block.conf
COPY --from=builder /app/00-start-tailscale.sh /docker-entrypoint.d
COPY --from=builder /app/40-clear-cache.sh /docker-entrypoint.d
