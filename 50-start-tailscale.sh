#!/bin/bash

set -euxo pipefail
ME=$(basename $0)


echo >&3 "$ME: info: starting tailscaled"

/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
echo >&3 "$ME: info: starting tailscale..."
until /app/tailscale up --authkey=${TAILSCALE_KEY} --hostname=fly-proxy
do
    sleep 0.1
done
echo >&3 "$ME: info: tailscale up!"
