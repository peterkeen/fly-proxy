#!/bin/sh

set -e

/docker-entrypoint.sh

nginx -g "daemon off;"
