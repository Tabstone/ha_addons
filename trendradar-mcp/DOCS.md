# TrendRadar MCP

Thin Home Assistant wrapper around `wantcat/trendradar-mcp`.

## Shared data model

This add-on does **not** maintain its own TrendRadar dataset. It reuses the main add-on shared directories:

- Shared config: `/addon_configs/9d486770_trendradar/config`
- Shared output: `/addon_configs/9d486770_trendradar/output`

Home Assistant prefixes add-on slugs with the repository ID (for example, `9d486770_`). If your install uses a different prefix, replace it in the paths above.

Inside the container they are exposed as:

- `/app/config`
- `/app/output`

## 可视化配置编辑器

提供基于 Web 的图形化配置界面，无需手动编辑 YAML 文件，通过表单即可完成所有配置项的修改与导出。

👉 在线体验：https://sansan0.github.io/TrendRadar/

## Access

- Direct port access is exposed on `3333/tcp`.
- No Ingress is configured.

## Notes

- Install and configure the main `trendradar` add-on first.
- Extra MCP env vars can be passed through `env_vars`.
