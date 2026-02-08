# Hytale Server Docker

Docker setup for running a Hytale dedicated server.

## Prerequisites
- Download the `hytale-downloader` from [Hytale's website](https://downloader.hytale.com/hytale-downloader.zip).
- Place the downloaded file in the `docker/` directory.

## Quick Start

```bash
# Build and start
docker-compose up -d

# Attach to console for authentication
docker attach hytale-server
# Then run: /auth login
# Detach with: Ctrl+P, Ctrl+Q

# View logs
docker-compose logs -f
```

## Files

- `docker/` - Build context with Dockerfile, entrypoint script, and downloader
- `docker-compose.yml` - Container orchestration

## Authentication

1. Attach to container: `docker attach hytale-server`
2. Run `/auth login` in console
3. Open the provided URL in browser
4. Detach with `Ctrl+P, Ctrl+Q` (don't use Ctrl+C)

## Configuration

Edit `docker-compose.yml` to adjust:
- `MAX_MEMORY` - Java heap size (default: 4G)
- Port mapping (default: 5520/udp)

## Network

Ensure UDP port 5520 is open on your firewall:
```bash
sudo ufw allow 5520/udp
```
