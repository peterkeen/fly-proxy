#!/bin/sh

/usr/sbin/tailscaled --state=mem: --socket=/var/run/tailscale/tailscaled.sock &
/usr/bin/tailscale up --authkey=${TS_OAUTH_CLIENT_SECRET} --advertise-tags=tag:fly-proxy
