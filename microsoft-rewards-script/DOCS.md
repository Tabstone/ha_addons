# Microsoft Rewards Script

This add-on wraps the upstream `ghcr.io/thenetsky/microsoft-rewards-script`
container for Home Assistant. It runs as a background cron service and does not
provide a web UI.

## Persistence

- `/config/config` maps to upstream `dist/config`.
- `/config/sessions` maps to upstream `dist/browser/sessions`.

The upstream entrypoint creates `config.json` and `accounts.json` under
`/config/config`. Browser sessions are stored under `/config/sessions`.

## Required Account Setup

At minimum, set `ACCOUNT_1_EMAIL` and `ACCOUNT_1_PASSWORD` before starting the
add-on. Optional TOTP, recovery email, geo locale, and language code fields are
also exposed for account 1.

Account 2 has email and password options. More accounts and advanced account
fields can be supplied with `env_vars`, for example `ACCOUNT_3_EMAIL` or
`ACCOUNT_2_TOTP_SECRET`.

## Scheduling

The default schedule is `0 7 * * *`. `RUN_ON_START` starts one immediate
background run when the add-on starts. `SKIP_RANDOM_SLEEP`, `MIN_SLEEP_MINUTES`,
and `MAX_SLEEP_MINUTES` control the randomized delay before scheduled runs.

## Configuration

Common settings are exposed as add-on options. Advanced upstream `CONFIG_*`
settings can be passed through `env_vars`; names must use normal environment
variable syntax.

The upstream entrypoint applies `CONFIG_*` values at every startup, so add-on
options take precedence over `/config/config/config.json`.

## Upstream

- Project: https://github.com/hex-ci/Microsoft-Rewards-Script
- Container: `ghcr.io/thenetsky/microsoft-rewards-script`
