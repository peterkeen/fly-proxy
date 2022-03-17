FROM alpine:latest as builder
WORKDIR /app
COPY . ./

FROM nginx:1.19.6-alpine
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

COPY --from=builder /app/proxy.conf /etc/nginx/conf.d/proxy.conf
COPY --from=builder /app/resolv.conf /etc/resolv.conf
COPY --from=builder /app/block.conf /etc/nginx/block.conf
COPY --from=builder /app/40-clear-cache.sh /docker-entrypoint.d
COPY --from=builder /app/start.sh /app/start.sh

CMD ["/app/start.sh"]
