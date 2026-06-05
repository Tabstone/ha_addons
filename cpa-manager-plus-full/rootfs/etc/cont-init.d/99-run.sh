#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export HTTP_ADDR='0.0.0.0:18317'
export USAGE_DATA_DIR='/config/data'
export USAGE_DB_PATH='/config/data/usage.sqlite'
export CPA_MANAGER_DATA_KEY_PATH='/config/data/data.key'
export TZ='Asia/Shanghai'
export CPA_MANAGER_ADMIN_KEY=''
export CPA_UPSTREAM_URL=''
export CPA_MANAGEMENT_KEY=''
export USAGE_COLLECTOR_MODE='auto'
export USAGE_RESP_QUEUE='usage'
export USAGE_RESP_POP_SIDE='right'
export USAGE_BATCH_SIZE='100'
export USAGE_POLL_INTERVAL_MS='500'
export USAGE_QUERY_LIMIT='50000'
export USAGE_CORS_ORIGINS='*'
export USAGE_RESP_TLS_SKIP_VERIFY='false'
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      HTTP_ADDR: "0.0.0.0:18317",
      USAGE_DATA_DIR: "/config/data",
      USAGE_DB_PATH: "/config/data/usage.sqlite",
      CPA_MANAGER_DATA_KEY_PATH: "/config/data/data.key",
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      CPA_MANAGER_ADMIN_KEY: (.CPA_MANAGER_ADMIN_KEY // "" | tostring),
      CPA_UPSTREAM_URL: (.CPA_UPSTREAM_URL // "" | tostring),
      CPA_MANAGEMENT_KEY: (.CPA_MANAGEMENT_KEY // "" | tostring),
      USAGE_COLLECTOR_MODE: (.USAGE_COLLECTOR_MODE // "auto" | tostring),
      USAGE_RESP_QUEUE: (.USAGE_RESP_QUEUE // "usage" | tostring),
      USAGE_RESP_POP_SIDE: (.USAGE_RESP_POP_SIDE // "right" | tostring),
      USAGE_BATCH_SIZE: (.USAGE_BATCH_SIZE // 100 | tostring),
      USAGE_POLL_INTERVAL_MS: (.USAGE_POLL_INTERVAL_MS // 500 | tostring),
      USAGE_QUERY_LIMIT: (.USAGE_QUERY_LIMIT // 50000 | tostring),
      USAGE_CORS_ORIGINS: (.USAGE_CORS_ORIGINS // "*" | tostring),
      USAGE_RESP_TLS_SKIP_VERIFY: (.USAGE_RESP_TLS_SKIP_VERIFY // false | tostring)
    }
    | to_entries[]
    | "export \(.key)=\(.value | @sh)"
  ' "$OPTIONS_FILE" > "$ENV_FILE"

  jq -r '
    (.env_vars // [])[]
    | select(.name != null and .name != "")
    | .name as $name
    | select(([
        "HTTP_ADDR",
        "USAGE_DATA_DIR",
        "USAGE_DB_PATH",
        "CPA_MANAGER_DATA_KEY_PATH",
        "TZ",
        "CPA_MANAGER_ADMIN_KEY",
        "CPA_UPSTREAM_URL",
        "CPA_MANAGEMENT_KEY",
        "USAGE_COLLECTOR_MODE",
        "USAGE_RESP_QUEUE",
        "USAGE_RESP_POP_SIDE",
        "USAGE_BATCH_SIZE",
        "USAGE_POLL_INTERVAL_MS",
        "USAGE_QUERY_LIMIT",
        "USAGE_CORS_ORIGINS",
        "USAGE_RESP_TLS_SKIP_VERIFY"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi
