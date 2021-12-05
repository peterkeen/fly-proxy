#!/bin/bash

set -euo pipefail

/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
until /app/tailscale up --authkey=${TAILSCALE_KEY} --hostname=fly-proxy
do
    sleep 0.1
done
