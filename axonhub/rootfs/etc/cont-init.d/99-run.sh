#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export TZ='Asia/Shanghai'
export AXONHUB_SERVER_HOST='0.0.0.0'
export AXONHUB_SERVER_PORT='8090'
export AXONHUB_DB_DIALECT='sqlite3'
export AXONHUB_DB_DSN='file:/config/data/axonhub.db?cache=shared&_fk=1&_pragma=journal_mode(WAL)'
export AXONHUB_LOG_OUTPUT='stdio'
export AXONHUB_LOG_FILE_PATH='/config/logs/axonhub.log'
export AXONHUB_SERVER_DISABLE_SSL_VERIFY='false'
export AXONHUB_SERVER_API_AUTH_ALLOW_NO_AUTH='false'
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      AXONHUB_SERVER_HOST: (.AXONHUB_SERVER_HOST // "0.0.0.0" | tostring),
      AXONHUB_SERVER_PORT: (.AXONHUB_SERVER_PORT // 8090 | tostring),
      AXONHUB_DB_DIALECT: (.AXONHUB_DB_DIALECT // "sqlite3" | tostring),
      AXONHUB_DB_DSN: (.AXONHUB_DB_DSN // "file:/config/data/axonhub.db?cache=shared&_fk=1&_pragma=journal_mode(WAL)" | tostring),
      AXONHUB_LOG_OUTPUT: (.AXONHUB_LOG_OUTPUT // "stdio" | tostring),
      AXONHUB_LOG_FILE_PATH: (.AXONHUB_LOG_FILE_PATH // "/config/logs/axonhub.log" | tostring),
      AXONHUB_SERVER_DISABLE_SSL_VERIFY: (.AXONHUB_SERVER_DISABLE_SSL_VERIFY // false | tostring),
      AXONHUB_SERVER_API_AUTH_ALLOW_NO_AUTH: (.AXONHUB_SERVER_API_AUTH_ALLOW_NO_AUTH // false | tostring)
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
        "AXONHUB_SERVER_HOST",
        "AXONHUB_SERVER_PORT",
        "AXONHUB_DB_DIALECT",
        "AXONHUB_DB_DSN",
        "AXONHUB_LOG_OUTPUT",
        "AXONHUB_LOG_FILE_PATH",
        "AXONHUB_SERVER_DISABLE_SSL_VERIFY",
        "AXONHUB_SERVER_API_AUTH_ALLOW_NO_AUTH"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi
