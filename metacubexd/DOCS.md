# MetaCubeXD

Thin Home Assistant wrapper around `ghcr.io/metacubex/metacubexd`.

## Shared config

This UI add-on reads the Mihomo config directory from the main add-on:

- Host: `/addon_configs/<实际 add-on slug>/config`
- Container: `/config/caddy` (symlink)

Home Assistant prefixes add-on slugs with the repository ID (for example, `9d486770_`). Replace `<实际 add-on slug>` with the full slug shown in your Home Assistant add-on list.

## Access

- No Ingress (Open Web UI will use host port).
- Direct access on http://homeassistant.local:9395/.
