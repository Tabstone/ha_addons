#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export HOST='0.0.0.0'
export PORT='4000'
export DATA_DIR='/app/data'
export TZ='Asia/Shanghai'
export AUTH_TOKEN=''
export PROXY_TOKEN=''
export ACCOUNT_CREDENTIAL_SECRET=''
export CHECKIN_CRON='0 8 * * *'
export BALANCE_REFRESH_CRON='0 * * * *'
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      HOST: "0.0.0.0",
      PORT: "4000",
      DATA_DIR: "/app/data",
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      AUTH_TOKEN: (.AUTH_TOKEN // "" | tostring),
      PROXY_TOKEN: (.PROXY_TOKEN // "" | tostring),
      ACCOUNT_CREDENTIAL_SECRET: (.ACCOUNT_CREDENTIAL_SECRET // "" | tostring),
      CHECKIN_CRON: (.CHECKIN_CRON // "0 8 * * *" | tostring),
      BALANCE_REFRESH_CRON: (.BALANCE_REFRESH_CRON // "0 * * * *" | tostring)
    }
    | to_entries[]
    | "export \(.key)=\(.value | @sh)"
  ' "$OPTIONS_FILE" > "$ENV_FILE"

  jq -r '
    (.env_vars // [])[]
    | select(.name != null and .name != "")
    | .name as $name
    | select(([
        "HOST",
        "PORT",
        "DATA_DIR",
        "TZ",
        "AUTH_TOKEN",
        "PROXY_TOKEN",
        "ACCOUNT_CREDENTIAL_SECRET",
        "CHECKIN_CRON",
        "BALANCE_REFRESH_CRON"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi

. "$ENV_FILE"

if [ -z "${ACCOUNT_CREDENTIAL_SECRET:-}" ] && [ -n "${AUTH_TOKEN:-}" ]; then
  printf "export ACCOUNT_CREDENTIAL_SECRET=%s\n" "$(printf "%s" "$AUTH_TOKEN" | jq -Rr @sh)" >> "$ENV_FILE"
fi
