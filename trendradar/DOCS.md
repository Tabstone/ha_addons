# TrendRadar

Thin Home Assistant wrapper around `wantcat/trendradar`.

## Persistent paths

This add-on keeps config and output as sibling host-visible directories:

- Config: `/homeassistant/addons_config/trendradar`
- Output: `/homeassistant/addons_config/trendradar_output`

Inside the container they are exposed as:

- `/app/config`
- `/app/output`

## First start

On first boot the add-on seeds these files into `/config` when missing:

- `config.yaml`
- `frequency_words.txt`
- `ai_analysis_prompt.txt`
- `ai_translation_prompt.txt`

## Access

- Ingress is enabled.
- Direct port access is exposed on `8080/tcp`.

## Notes

- The wrapper forces the upstream web server on and keeps it on port `8080` so Ingress always has a stable target.
- `RUN_MODE`, `CRON_SCHEDULE`, and `IMMEDIATE_RUN` follow upstream behavior.
- Extra upstream environment variables can be passed via `env_vars`.
