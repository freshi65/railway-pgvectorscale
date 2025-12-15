FROM timescale/timescaledb-ha:pg17

USER root

# Create init script to fix permissions at runtime
COPY init-permissions.sh /docker-entrypoint-initdb.d/000-init-permissions.sh
RUN chmod +x /docker-entrypoint-initdb.d/000-init-permissions.sh

# Fix ownership of pgdata directory
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]