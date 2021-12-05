FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.18.1_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && tar xzf ${TSFILE} --strip-components=1
COPY . ./

FROM nginx:1.19.6-alpine
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY proxy.conf /etc/nginx/conf.d/proxy.conf
COPY resolv.conf /etc/resolv.conf
COPY 40-clear-cache.sh /docker-entrypoint.d
COPY 50-start-tailscale.sh /docker-entrypoint.d
