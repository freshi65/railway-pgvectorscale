FROM timescale/timescaledb-ha:pg17

USER root

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]