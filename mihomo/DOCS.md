# Mihomo

Thin Home Assistant wrapper around `metacubex/mihomo`.

## Persistent paths

This add-on keeps its config in the add-on public folder:

- Host: `/addon_configs/9d486770_mihomo/config`
- Container: `/root/.config/mihomo`

Home Assistant prefixes add-on slugs with the repository ID (for example, `9d486770_`). If your install uses a different prefix, replace it in the path above.

Inside the add-on, the wrapper links `/root/.config/mihomo` to `/config/config`.

## First start

If `config.yaml` is missing, the add-on seeds it from the bundled defaults.

## Access

- No Ingress.
- Ports exposed:
  - `7890/tcp` mixed port
  - `7890/udp` mixed port (UDP)
  - `9090/tcp` external controller

## Notes

- The add-on runs with host networking and TUN device access, matching upstream docker-compose requirements.
