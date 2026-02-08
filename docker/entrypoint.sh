#!/bin/sh
set -e

DOWNLOADER="/opt/hytale-downloader/hytale-downloader"
SERVER_DIR="/server"

echo "=========================================="
echo "  Hytale Server Docker"
echo "=========================================="

echo "Checking for updates..."
cd "$SERVER_DIR"

if [ ! -d "$SERVER_DIR/Server" ] || [ "${FORCE_UPDATE:-false}" = "true" ]; then
    echo "Downloading Hytale server..."
    rm -f "$SERVER_DIR/game.zip"
    $DOWNLOADER -download-path "$SERVER_DIR/game.zip"
    
    echo "Extracting..."
    unzip -q -o "$SERVER_DIR/game.zip" -d "$SERVER_DIR/"
    rm -f "$SERVER_DIR/game.zip"
    
    echo "Server files ready"
fi

if [ ! -f "$SERVER_DIR/Server/HytaleServer.jar" ]; then
    echo "ERROR: HytaleServer.jar not found!"
    echo "Contents of $SERVER_DIR:"
    ls -la "$SERVER_DIR" || true
    exit 1
fi

cd "$SERVER_DIR/Server"

# Remove incompatible AOT cache if present
[ -f "HytaleServer.aot" ] && rm -f "HytaleServer.aot"

JVM_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=200"
[ -n "${MAX_MEMORY:-}" ] && JVM_OPTS="$JVM_OPTS -Xmx$MAX_MEMORY" || JVM_OPTS="$JVM_OPTS -Xmx4G"

SERVER_OPTS="--assets ../Assets.zip --bind 0.0.0.0:5520"
[ -n "${EXTRA_ARGS:-}" ] && SERVER_OPTS="$SERVER_OPTS $EXTRA_ARGS"

echo "Starting server..."
exec java $JVM_OPTS -jar HytaleServer.jar $SERVER_OPTS
