# TrendRadar

Thin Home Assistant wrapper around `wantcat/trendradar`.

## Persistent paths

This add-on keeps config and output as sibling directories inside the same public add-on folder:

- Config: `/addon_configs/trendradar/config`
- Output: `/addon_configs/trendradar/output`

Inside the container they are exposed as:

- `/app/config`
- `/app/output`

## First start

On first boot the add-on creates these directories under its public add-on folder:

- `config/`
- `output/`

If the 5 core files are missing in `config/`, it seeds:

- `config.yaml`
- `frequency_words.txt`
- `ai_analysis_prompt.txt`
- `ai_translation_prompt.txt`
- `timeline.yaml`

## 可视化配置编辑器

提供基于 Web 的图形化配置界面，无需手动编辑 YAML 文件，通过表单即可完成所有配置项的修改与导出。

👉 在线体验：https://sansan0.github.io/TrendRadar/

## Access

- Ingress is enabled.
- Direct port access is exposed on `8080/tcp`.

## Notes

- The wrapper forces the upstream web server on and keeps it on port `8080` so Ingress always has a stable target.
- `RUN_MODE`, `CRON_SCHEDULE`, and `IMMEDIATE_RUN` follow upstream behavior.
- Extra upstream environment variables can be passed via `env_vars`.
