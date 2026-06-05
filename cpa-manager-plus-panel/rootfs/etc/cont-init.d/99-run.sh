#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"
INDEX_FILE="/www/index.html"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export TZ='Asia/Shanghai'
export CPA_PANEL_REPOSITORY='https://github.com/seakee/CPA-Manager-Plus'
export CPA_PANEL_URL=''
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      CPA_PANEL_REPOSITORY: (.CPA_PANEL_REPOSITORY // "https://github.com/seakee/CPA-Manager-Plus" | tostring),
      CPA_PANEL_URL: (.CPA_PANEL_URL // "" | tostring)
    }
    | to_entries[]
    | "export \(.key)=\(.value | @sh)"
  ' "$OPTIONS_FILE" > "$ENV_FILE"

  jq -r '
    (.env_vars // [])[]
    | select(.name != null and .name != "")
    | .name as $name
    | select(([
        "TZ",
        "CPA_PANEL_REPOSITORY",
        "CPA_PANEL_URL"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi

. "$ENV_FILE"

cat > "$INDEX_FILE" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>CPA Manager Plus Panel Mode</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; color: #17202a; background: #f7f9fb; }
    main { max-width: 880px; margin: 0 auto; padding: 40px 24px; }
    h1 { font-size: 30px; margin: 0 0 12px; }
    h2 { font-size: 18px; margin-top: 28px; }
    p, li { line-height: 1.65; }
    code { background: #e8eef5; border-radius: 4px; padding: 2px 5px; }
    a.button { display: inline-block; margin: 12px 12px 0 0; padding: 10px 14px; border-radius: 6px; background: #1d4ed8; color: white; text-decoration: none; }
    a.secondary { background: #475569; }
    .panel { background: white; border: 1px solid #d9e2ec; border-radius: 8px; padding: 18px; }
  </style>
</head>
<body>
  <main>
    <h1>CPA Manager Plus Panel Mode</h1>
    <p>This add-on serves the CPA Manager Plus release <code>management.html</code> asset and documents CPA panel mode. It does not run Manager Server and does not store SQLite analytics.</p>
    <p>
      <a class="button" href="/management.html">Open bundled management.html</a>
      <a class="button secondary" href="${CPA_PANEL_URL:-/management.html}">Open configured CPA panel URL</a>
    </p>
    <div class="panel">
      <h2>Production CPA panel mode</h2>
      <p>Open your CLI Proxy API management configuration and set the panel repository to:</p>
      <p><code>${CPA_PANEL_REPOSITORY}</code></p>
      <p>Then open CPA's own panel endpoint, normally <code>http://&lt;cpa-host&gt;:8317/management.html</code>, and log in with the CPA Management Key.</p>
    </div>
    <h2>Mode boundary</h2>
    <ul>
      <li>CPA panel mode keeps using CPA as the HTTP origin.</li>
      <li>It does not use Manager Server, the admin key, or <code>/data/usage.sqlite</code>.</li>
      <li>Request monitoring, model pricing, API key aliases, import/export, and server Codex inspection require the Full add-on.</li>
    </ul>
  </main>
</body>
</html>
EOF
