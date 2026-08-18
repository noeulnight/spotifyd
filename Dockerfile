FROM debian:bullseye-slim

ARG UPSTREAM_RELEASE_CHECK=manual

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl libasound2 \
    && echo "Checking upstream release: ${UPSTREAM_RELEASE_CHECK}" \
    && cd /tmp \
    && curl -fLO https://github.com/Spotifyd/spotifyd/releases/latest/download/spotifyd-linux-aarch64-slim.tar.gz \
    && curl -fLO https://github.com/Spotifyd/spotifyd/releases/latest/download/spotifyd-linux-aarch64-slim.sha512 \
    && sha512sum -c spotifyd-linux-aarch64-slim.sha512 \
    && tar -xzf spotifyd-linux-aarch64-slim.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/spotifyd \
    && rm -rf /var/lib/apt/lists/* /tmp/spotifyd-linux-aarch64-slim.*

ENTRYPOINT ["spotifyd", "--no-daemon"]
