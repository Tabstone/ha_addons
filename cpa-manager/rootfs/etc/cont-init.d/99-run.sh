#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export HTTP_ADDR='0.0.0.0:18317'
export USAGE_DATA_DIR='/config/data'
export USAGE_DB_PATH='/config/data/usage.sqlite'
export TZ='Asia/Shanghai'
export CPA_UPSTREAM_URL=''
export CPA_MANAGEMENT_KEY=''
export USAGE_COLLECTOR_MODE='auto'
export USAGE_CORS_ORIGINS='*'
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
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      CPA_UPSTREAM_URL: (.CPA_UPSTREAM_URL // "" | tostring),
      CPA_MANAGEMENT_KEY: (.CPA_MANAGEMENT_KEY // "" | tostring),
      USAGE_COLLECTOR_MODE: (.USAGE_COLLECTOR_MODE // "auto" | tostring),
      USAGE_CORS_ORIGINS: (.USAGE_CORS_ORIGINS // "*" | tostring)
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
        "TZ",
        "CPA_UPSTREAM_URL",
        "CPA_MANAGEMENT_KEY",
        "USAGE_COLLECTOR_MODE",
        "USAGE_CORS_ORIGINS"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi
