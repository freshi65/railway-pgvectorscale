#!/bin/bash
set -e

PGDATA="/home/postgres/pgdata/data"

# Fix permissions
mkdir -p "$PGDATA"
chown -R postgres:postgres /home/postgres/pgdata

# Initialize if needed
if [ ! -s "$PGDATA/PG_VERSION" ]; then
    su postgres -c "/usr/lib/postgresql/17/bin/initdb -D $PGDATA"
    
    # Configure pg_hba.conf for connections (IPv4 + IPv6)
    cat > "$PGDATA/pg_hba.conf" <<EOF
local   all             all                                     trust
host    all             all             127.0.0.1/32            md5
host    all             all             0.0.0.0/0               md5
host    all             all             ::0/0                   md5
EOF
    
    # Configure postgresql.conf
    echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"
    
    # Start temporarily to create user/db
    su postgres -c "/usr/lib/postgresql/17/bin/pg_ctl -D $PGDATA start"
    su postgres -c "psql -c \"ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';\""
    su postgres -c "psql -c \"CREATE DATABASE ${POSTGRES_DB:-railway};\""
    su postgres -c "/usr/lib/postgresql/17/bin/pg_ctl -D $PGDATA stop"
fi

# Start postgres
exec su postgres -c "/usr/lib/postgresql/17/bin/postgres -D $PGDATA"