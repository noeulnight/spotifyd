# spotifyd Docker

A minimal ARM64 Docker image for running [spotifyd](https://github.com/Spotifyd/spotifyd)
on a Raspberry Pi. The image downloads the latest official ARM64 slim release and verifies
its published SHA-512 checksum during the build.

The GitHub Actions workflow checks for a new upstream release every Sunday at 00:00 UTC and
publishes the resulting image to `ghcr.io/noeulnight/spotifyd:latest`.

## Usage

Copy the example configuration and adjust the ALSA device using the output of `aplay -l`:

```bash
cp spotifyd.conf.example spotifyd.conf
```

Add the service to your Compose file:

```yaml
services:
  spotifyd:
    image: ghcr.io/noeulnight/spotifyd:latest
    container_name: spotifyd
    restart: unless-stopped
    network_mode: host
    devices:
      - /dev/snd:/dev/snd
    volumes:
      - ./spotifyd.conf:/etc/spotifyd.conf:ro
      - spotifyd-cache:/data
    command: ["--config-path", "/etc/spotifyd.conf"]

volumes:
  spotifyd-cache:
```

Start the service:

```bash
docker compose up -d
docker compose logs -f spotifyd
```

The device appears in the Spotify app as a Spotify Connect target. Initial discovery requires
the app and Raspberry Pi to be on the same LAN; no Spotify password is stored in Compose.

## Configuration

- `network_mode: host` enables mDNS and Zeroconf discovery.
- `/dev/snd` gives spotifyd access to the host ALSA output.
- `/data` persists Spotify credentials across container restarts.
- The example uses `hw:2,0`; change it to match the target system.
