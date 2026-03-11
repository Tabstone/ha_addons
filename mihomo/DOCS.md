# Mihomo

Thin Home Assistant wrapper around `metacubex/mihomo`.

## Persistent paths

This add-on keeps its config in the add-on public folder:

- Host: `/addon_configs/<实际 add-on slug>/config`
- Container: `/root/.config/mihomo`

Home Assistant prefixes add-on slugs with the repository ID (for example, `9d486770_`). Replace `<实际 add-on slug>` with the full slug shown in your Home Assistant add-on list.

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
