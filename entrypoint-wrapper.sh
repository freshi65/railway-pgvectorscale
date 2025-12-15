#!/bin/bash
set -e

# Fix permissions on the mounted volume (runs as root)
mkdir -p /home/postgres/pgdata/data
chown -R postgres:postgres /home/postgres/pgdata

# Switch to postgres user and run original entrypoint
exec gosu postgres /usr/local/bin/docker-entrypoint.sh "$@"