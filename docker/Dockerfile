FROM eclipse-temurin:25-jre

LABEL maintainer="Hytale Server Docker"
LABEL description="Hytale dedicated server with auto-update support"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create directories and user
RUN mkdir -p /opt/hytale-downloader /server \
    && groupadd -r hytale \
    && useradd -r -g hytale -d /server -s /usr/sbin/nologin hytale

# Copy the downloader binary
COPY hytale-downloader /opt/hytale-downloader/hytale-downloader
RUN echo "5dc7945e9d9603baf9b1f0dc6d18df3d61bdba38f2e5805c87b9e2c481315eaa  /opt/hytale-downloader/hytale-downloader" | sha256sum -c -
RUN chmod +x /opt/hytale-downloader/hytale-downloader

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create server directory structure
RUN mkdir -p /server/game \
    && chown -R hytale:hytale /server /opt/hytale-downloader

# Expose UDP port (QUIC protocol)
EXPOSE 5520/udp

# Set working directory
WORKDIR /server

# Drop root
USER hytale

# Health check (process-based, avoids UDP false positives)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "HytaleServer.jar" >/dev/null || exit 1

# Run entrypoint
ENTRYPOINT ["/entrypoint.sh"]
