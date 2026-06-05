#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export TZ='Asia/Shanghai'
export NODE_ENV='production'
export CRON_SCHEDULE='0 7 * * *'
export RUN_ON_START='true'
export SKIP_RANDOM_SLEEP='false'
export MIN_SLEEP_MINUTES='5'
export MAX_SLEEP_MINUTES='50'
export STUCK_PROCESS_TIMEOUT_HOURS='8'
export CONFIG_CLUSTERS='1'
export CONFIG_GLOBAL_TIMEOUT='30sec'
export CONFIG_DEBUG_LOGS='false'
export CONFIG_ERROR_DIAGNOSTICS='false'
export CONFIG_DISCORD_ENABLED='false'
export CONFIG_DISCORD_URL=''
export CONFIG_NTFY_ENABLED='false'
export CONFIG_NTFY_URL=''
export CONFIG_NTFY_TOPIC=''
export CONFIG_NTFY_TOKEN=''
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      NODE_ENV: "production",
      CRON_SCHEDULE: (.CRON_SCHEDULE // "0 7 * * *" | tostring),
      RUN_ON_START: ((if has("RUN_ON_START") then .RUN_ON_START else true end) | tostring),
      SKIP_RANDOM_SLEEP: (.SKIP_RANDOM_SLEEP // false | tostring),
      MIN_SLEEP_MINUTES: (.MIN_SLEEP_MINUTES // 5 | tostring),
      MAX_SLEEP_MINUTES: (.MAX_SLEEP_MINUTES // 50 | tostring),
      STUCK_PROCESS_TIMEOUT_HOURS: (.STUCK_PROCESS_TIMEOUT_HOURS // 8 | tostring),
      ACCOUNT_1_EMAIL: (.ACCOUNT_1_EMAIL // "" | tostring),
      ACCOUNT_1_PASSWORD: (.ACCOUNT_1_PASSWORD // "" | tostring),
      ACCOUNT_1_TOTP_SECRET: (.ACCOUNT_1_TOTP_SECRET // "" | tostring),
      ACCOUNT_1_RECOVERY_EMAIL: (.ACCOUNT_1_RECOVERY_EMAIL // "" | tostring),
      ACCOUNT_1_GEO_LOCALE: (.ACCOUNT_1_GEO_LOCALE // "auto" | tostring),
      ACCOUNT_1_LANG_CODE: (.ACCOUNT_1_LANG_CODE // "en" | tostring),
      ACCOUNT_2_EMAIL: (.ACCOUNT_2_EMAIL // "" | tostring),
      ACCOUNT_2_PASSWORD: (.ACCOUNT_2_PASSWORD // "" | tostring),
      CONFIG_CLUSTERS: (.CONFIG_CLUSTERS // 1 | tostring),
      CONFIG_GLOBAL_TIMEOUT: (.CONFIG_GLOBAL_TIMEOUT // "30sec" | tostring),
      CONFIG_DEBUG_LOGS: (.CONFIG_DEBUG_LOGS // false | tostring),
      CONFIG_ERROR_DIAGNOSTICS: (.CONFIG_ERROR_DIAGNOSTICS // false | tostring),
      CONFIG_DISCORD_ENABLED: (.CONFIG_DISCORD_ENABLED // false | tostring),
      CONFIG_DISCORD_URL: (.CONFIG_DISCORD_URL // "" | tostring),
      CONFIG_NTFY_ENABLED: (.CONFIG_NTFY_ENABLED // false | tostring),
      CONFIG_NTFY_URL: (.CONFIG_NTFY_URL // "" | tostring),
      CONFIG_NTFY_TOPIC: (.CONFIG_NTFY_TOPIC // "" | tostring),
      CONFIG_NTFY_TOKEN: (.CONFIG_NTFY_TOKEN // "" | tostring)
    }
    | to_entries[]
    | select(.value != "")
    | "export \(.key)=\(.value | @sh)"
  ' "$OPTIONS_FILE" > "$ENV_FILE"

  jq -r '
    (.env_vars // [])[]
    | select(.name != null and .name != "")
    | .name as $name
    | select(([
        "TZ",
        "NODE_ENV",
        "CRON_SCHEDULE",
        "RUN_ON_START",
        "SKIP_RANDOM_SLEEP",
        "MIN_SLEEP_MINUTES",
        "MAX_SLEEP_MINUTES",
        "STUCK_PROCESS_TIMEOUT_HOURS",
        "ACCOUNT_1_EMAIL",
        "ACCOUNT_1_PASSWORD",
        "ACCOUNT_1_TOTP_SECRET",
        "ACCOUNT_1_RECOVERY_EMAIL",
        "ACCOUNT_1_GEO_LOCALE",
        "ACCOUNT_1_LANG_CODE",
        "ACCOUNT_2_EMAIL",
        "ACCOUNT_2_PASSWORD",
        "CONFIG_CLUSTERS",
        "CONFIG_GLOBAL_TIMEOUT",
        "CONFIG_DEBUG_LOGS",
        "CONFIG_ERROR_DIAGNOSTICS",
        "CONFIG_DISCORD_ENABLED",
        "CONFIG_DISCORD_URL",
        "CONFIG_NTFY_ENABLED",
        "CONFIG_NTFY_URL",
        "CONFIG_NTFY_TOPIC",
        "CONFIG_NTFY_TOKEN"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi
