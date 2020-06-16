FROM postgres:11.5
COPY ca/server.key /var/lib/postgresql/server.key
COPY ca/server.crt /var/lib/postgresql/server.crt
RUN chown postgres /var/lib/postgresql/server.key && \
    chmod 600 /var/lib/postgresql/server.key