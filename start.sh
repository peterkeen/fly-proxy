#!/bin/sh

set -e
ME=$(basename $0)

echo >&3 "$ME: info: starting tailscaled"

/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
echo >&3 "$ME: info: starting tailscale..."
until /app/tailscale up --authkey=${TAILSCALE_KEY} --hostname=fly-proxy --advertise-tags=tag:server,tag:fly-proxy
do
    sleep 0.1
done
echo >&3 "$ME: info: tailscale up!"

/docker-entrypoint.sh
