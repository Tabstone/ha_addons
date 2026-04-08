#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export AUTO_SETUP='true'
export SERVER_HOST='0.0.0.0'
export SERVER_PORT='8080'
export SERVER_MODE='release'
export TZ='Asia/Shanghai'
export RUN_MODE='standard'
export DATABASE_HOST=''
export DATABASE_PORT='5432'
export DATABASE_USER='sub2api'
export DATABASE_PASSWORD=''
export DATABASE_DBNAME='sub2api'
export DATABASE_SSLMODE='disable'
export DATABASE_MAX_OPEN_CONNS='50'
export DATABASE_MAX_IDLE_CONNS='10'
export DATABASE_CONN_MAX_LIFETIME_MINUTES='30'
export DATABASE_CONN_MAX_IDLE_TIME_MINUTES='5'
export REDIS_HOST=''
export REDIS_PORT='6379'
export REDIS_PASSWORD=''
export REDIS_DB='0'
export REDIS_POOL_SIZE='1024'
export REDIS_MIN_IDLE_CONNS='10'
export REDIS_ENABLE_TLS='false'
export ADMIN_EMAIL='admin@sub2api.local'
export ADMIN_PASSWORD=''
export JWT_SECRET=''
export TOTP_ENCRYPTION_KEY=''
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
  exit 0
fi

jq -r '
  {
    AUTO_SETUP: "true",
    SERVER_HOST: "0.0.0.0",
    SERVER_PORT: "8080",
    SERVER_MODE: "release",
    TZ: (.TZ // "Asia/Shanghai" | tostring),
    RUN_MODE: (.RUN_MODE // "standard" | tostring),
    DATABASE_HOST: (.DATABASE_HOST // "" | tostring),
    DATABASE_PORT: (.DATABASE_PORT // 5432 | tostring),
    DATABASE_USER: (.DATABASE_USER // "sub2api" | tostring),
    DATABASE_PASSWORD: (.DATABASE_PASSWORD // "" | tostring),
    DATABASE_DBNAME: (.DATABASE_DBNAME // "sub2api" | tostring),
    DATABASE_SSLMODE: (.DATABASE_SSLMODE // "disable" | tostring),
    DATABASE_MAX_OPEN_CONNS: (.DATABASE_MAX_OPEN_CONNS // 50 | tostring),
    DATABASE_MAX_IDLE_CONNS: (.DATABASE_MAX_IDLE_CONNS // 10 | tostring),
    DATABASE_CONN_MAX_LIFETIME_MINUTES: (.DATABASE_CONN_MAX_LIFETIME_MINUTES // 30 | tostring),
    DATABASE_CONN_MAX_IDLE_TIME_MINUTES: (.DATABASE_CONN_MAX_IDLE_TIME_MINUTES // 5 | tostring),
    REDIS_HOST: (.REDIS_HOST // "" | tostring),
    REDIS_PORT: (.REDIS_PORT // 6379 | tostring),
    REDIS_PASSWORD: (.REDIS_PASSWORD // "" | tostring),
    REDIS_DB: (.REDIS_DB // 0 | tostring),
    REDIS_POOL_SIZE: (.REDIS_POOL_SIZE // 1024 | tostring),
    REDIS_MIN_IDLE_CONNS: (.REDIS_MIN_IDLE_CONNS // 10 | tostring),
    REDIS_ENABLE_TLS: (.REDIS_ENABLE_TLS // false | tostring),
    ADMIN_EMAIL: (.ADMIN_EMAIL // "admin@sub2api.local" | tostring),
    ADMIN_PASSWORD: (.ADMIN_PASSWORD // "" | tostring),
    JWT_SECRET: (.JWT_SECRET // "" | tostring),
    TOTP_ENCRYPTION_KEY: (.TOTP_ENCRYPTION_KEY // "" | tostring)
  }
  | to_entries[]
  | "export \(.key)=\(.value | @sh)"
' "$OPTIONS_FILE" > "$ENV_FILE"

jq -r '
  (.env_vars // [])[]
  | select(.name != null and .name != "")
  | .name as $name
  | select(([
      "AUTO_SETUP",
      "SERVER_HOST",
      "SERVER_PORT",
      "SERVER_MODE",
      "TZ",
      "RUN_MODE",
      "DATABASE_HOST",
      "DATABASE_PORT",
      "DATABASE_USER",
      "DATABASE_PASSWORD",
      "DATABASE_DBNAME",
      "DATABASE_SSLMODE",
      "DATABASE_MAX_OPEN_CONNS",
      "DATABASE_MAX_IDLE_CONNS",
      "DATABASE_CONN_MAX_LIFETIME_MINUTES",
      "DATABASE_CONN_MAX_IDLE_TIME_MINUTES",
      "REDIS_HOST",
      "REDIS_PORT",
      "REDIS_PASSWORD",
      "REDIS_DB",
      "REDIS_POOL_SIZE",
      "REDIS_MIN_IDLE_CONNS",
      "REDIS_ENABLE_TLS",
      "ADMIN_EMAIL",
      "ADMIN_PASSWORD",
      "JWT_SECRET",
      "TOTP_ENCRYPTION_KEY"
    ] | index($name)) | not)
  | "export \($name)=\((.value // "") | tostring | @sh)"
' "$OPTIONS_FILE" >> "$ENV_FILE"
