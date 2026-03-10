# MetaCubeXD

Thin Home Assistant wrapper around `ghcr.io/metacubex/metacubexd`.

## Shared config

This UI add-on reads the Mihomo config directory from the main add-on:

- Host: `/addon_configs/mihomo/config`
- Container: `/config/caddy` (symlink)

## Access

- No Ingress.
- Direct access on `http://<homeassistant>:9097`.
