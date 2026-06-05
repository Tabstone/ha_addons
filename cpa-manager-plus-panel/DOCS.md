# CPA Manager Plus Panel

CPA Manager Plus Panel is the Home Assistant add-on for upstream **CPA panel mode**.

This mode is different from Full Docker mode. It does not run Manager Server, does not write SQLite usage data, and does not use a Manager Server admin key. The production CPA panel mode is served by CLI Proxy API itself after CPA downloads the CPA Manager Plus panel from the configured panel repository.

## What This Add-on Does

- Downloads the upstream release `management.html` at build time.
- Serves a small helper page and the bundled `management.html` on port `18080`.
- Documents the exact CPA Panel Repository setting.

This add-on is useful as a Home Assistant-visible companion for CPA panel mode and as a quick way to inspect the bundled release panel asset. For normal use, configure CPA itself to host the panel.

## Production CPA Panel Mode

Open CPA's own configuration page and set:

```text
remote-management.panel-github-repository: https://github.com/seakee/CPA-Manager-Plus
```

or use the visual CPA configuration page:

```text
Configuration -> Remote Access and Control Panel -> Panel Repository
```

Older CPA builds may refer to the same setting as `remote-management.panel-repo`.

Keep the CPA control panel enabled. If CPA's panel auto-update is disabled, CPA downloads a new panel only when its cached `static/management.html` is missing.

Then open:

```text
http://<cpa-host>:8317/management.html
```

and log in with the CPA Management Key.

## Difference From Full Mode

Use **CPA Manager Plus Full** when you need:

- Manager Server setup and admin-key login
- encrypted CPA Management Key storage
- request monitoring and historical usage analytics
- model prices and API key aliases
- usage import/export
- server Codex inspection

Use this add-on when CPA should remain the panel host and those Manager Server-backed features are intentionally not required.

## Options

- `CPA_PANEL_REPOSITORY`: the repository URL to put into CPA's Panel Repository setting.
- `CPA_PANEL_URL`: optional direct link to your CPA-hosted panel, shown on the helper page.
- `env_vars`: advanced environment passthrough for the wrapper.

## Upgrades

The add-on version follows the same CPA Manager Plus upstream version as the Full add-on. The repository sync workflow updates this add-on together with the Full add-on when a new upstream image/release tag is available.
