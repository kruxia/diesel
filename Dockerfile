# --------------
# -- COMPILER --
# --------------
# 
# Compile diesel so it's available for use as a migration tool in the database

FROM rust:slim-buster as compiler
LABEL maintainer="Sean Harrison <sah@kruxia.com>"

RUN apt-get update \
    && apt-get install -y \
        # build tools
        # - ca-certificates are necessary for curl and cargo install
        ca-certificates \
        curl \
        # - cargo build diesel-cli requires gcc, libpq5
        gcc \
        libc-dev-bin \
        libpq5 \
        libpq-dev \
    && apt-get upgrade -y 

RUN cargo install diesel_cli --no-default-features --features "postgres"

# -------------
# -- RELEASE --
# -------------
# 
# Copy the diesel binary to a fresh image so it's available for use

FROM debian:buster-slim as release
LABEL maintainer="Sean Harrison <sah@kruxia.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

COPY --from=compiler /usr/local/cargo/bin/diesel /usr/local/bin/diesel
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
