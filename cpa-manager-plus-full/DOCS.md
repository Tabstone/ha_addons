# CPA Manager Plus Full

CPA Manager Plus Full is the Home Assistant add-on for upstream **Full Docker mode**.

This mode runs the CPA Manager Plus Manager Server and serves the built-in panel at `/management.html`. It is the mode to choose when you want server-side request monitoring, SQLite-backed historical usage, model pricing, API key aliases, import/export, collector status, and server Codex inspection.

## What It Runs

- Upstream image: `seakee/cpa-manager-plus`
- Manager Server port: `18317`
- Panel entry: `/management.html`
- SQLite data: `/config/data/usage.sqlite`
- Data encryption key: `/config/data/data.key`

The add-on does not include CLI Proxy API itself. Run CPA separately, then bind this Manager Server to that CPA during first setup.

## First Start

Open the add-on web UI:

```text
http://homeassistant.local:18317/management.html
```

or use Home Assistant ingress.

If `CPA_MANAGER_ADMIN_KEY` is empty, the upstream service generates a `cmp_admin_...` admin key and prints it once in the add-on log. Save that key. You need it for first setup and later logins.

During setup, enter:

- the Manager Server admin key
- your CPA URL, for example `http://homeassistant.local:8317` or another reachable CPA endpoint
- the CPA Management Key
- whether request monitoring should be enabled

If you fill `CPA_MANAGER_ADMIN_KEY`, `CPA_UPSTREAM_URL`, and `CPA_MANAGEMENT_KEY` in the add-on options, the upstream service can start in an environment-managed mode.

## Persistence

The add-on persists all Manager Server data under:

```text
/addon_configs/<actual add-on slug>/data/
  usage.sqlite
  usage.sqlite-wal
  usage.sqlite-shm
  data.key
```

Back up the whole `data/` directory, not just `usage.sqlite`. The `data.key` file is required to decrypt the stored CPA Management Key.

## Configuration Boundary

CPA configuration still belongs to CLI Proxy API. CPA Manager Plus stores only Manager Server state: the bound CPA URL, encrypted CPA Management Key, request monitoring settings, collector mode, model prices, aliases, and usage history.

Changing the CPA URL after setup requires intentionally resetting or migrating Manager Server data. Updating the CPA Management Key for the same CPA can be done from the panel.

## Options

- `CPA_MANAGER_ADMIN_KEY`: optional stable Manager Server admin key. Leave empty to let upstream generate one in the log.
- `CPA_UPSTREAM_URL`: optional CPA base URL for unattended startup.
- `CPA_MANAGEMENT_KEY`: optional CPA Management Key for unattended startup.
- `USAGE_COLLECTOR_MODE`: `auto`, `subscribe`, `http`, or `resp`.
- `USAGE_POLL_INTERVAL_MS`: idle polling interval for HTTP/RESP pop collection.
- `USAGE_CORS_ORIGINS`: CORS origins for compatibility endpoints.
- `USAGE_RESP_TLS_SKIP_VERIFY`: skip TLS verification for RESP access when needed.
- `env_vars`: pass advanced upstream environment variables that are not explicitly modeled.

## Difference From CPA Panel Mode

Use this add-on when you want the full Manager Server feature set. Use **CPA Manager Plus Panel** only when CPA itself should host the panel and you do not want Manager Server analytics.

## Upgrades

This add-on follows upstream Docker image tags. The repository sync workflow updates `build.yaml`, `config.yaml.version`, and `CHANGELOG.md` when a new upstream version is available.
