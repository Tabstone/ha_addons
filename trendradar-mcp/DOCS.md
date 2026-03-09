# TrendRadar MCP

Thin Home Assistant wrapper around `wantcat/trendradar-mcp`.

## Shared data model

This add-on does **not** maintain its own TrendRadar dataset. It reuses the main add-on shared directories:

- Shared config: `/addon_configs/trendradar/config`
- Shared output: `/addon_configs/trendradar/output`

Inside the container they are exposed as:

- `/app/config`
- `/app/output`

## Access

- Direct port access is exposed on `3333/tcp`.
- No Ingress is configured.

## Notes

- Install and configure the main `trendradar` add-on first.
- Extra MCP env vars can be passed through `env_vars`.
