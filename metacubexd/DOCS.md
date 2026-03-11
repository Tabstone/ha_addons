# MetaCubeXD

Thin Home Assistant wrapper around `ghcr.io/metacubex/metacubexd`.

## Shared config

This UI add-on reads the Mihomo config directory from the main add-on:

- Host: `/addon_configs/9d486770_mihomo/config`
- Container: `/config/caddy` (symlink)

Home Assistant prefixes add-on slugs with the repository ID (for example, `9d486770_`). If your install uses a different prefix, replace it in the path above.

## Access

- No Ingress (Open Web UI will use host port).
- Direct access on http://homeassistant.local:9395/.
