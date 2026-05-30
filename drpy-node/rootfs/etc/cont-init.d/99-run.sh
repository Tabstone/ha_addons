#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

write_defaults() {
  cat > "$ENV_FILE" <<'EOF'
export TZ='Asia/Shanghai'
export ROOT='/app'
export NODE_PATH='/config'
export NODE_ENV='development'
export VIRTUAL_ENV='/app/.venv'
export PHP_PATH='php'
export PYTHON_PATH=''
export LOG_WITH_FILE='0'
export LOG_LEVEL='info'
export API_AUTH_NAME='admin'
export API_AUTH_CODE='drpys'
export API_PWD='dzyyds'
export COOKIE_AUTH_CODE='drpys'
export CLIPBOARD_SECURITY_CODE='drpys'
export ENABLE_TASKER='0'
export TASKER_INTERVAL='0'
export ENABLE_TERMINAL='1'
export READ_ONLY_MODE='0'
export CAT_DEBUG='1'
EOF
}

if [ ! -f "$OPTIONS_FILE" ]; then
  write_defaults
else
  jq -r '
    {
      TZ: (.TZ // "Asia/Shanghai" | tostring),
      ROOT: "/app",
      NODE_PATH: "/config",
      NODE_ENV: (.NODE_ENV // "development" | tostring),
      VIRTUAL_ENV: "/app/.venv",
      PHP_PATH: "php",
      PYTHON_PATH: "",
      LOG_WITH_FILE: (.LOG_WITH_FILE // 0 | tostring),
      LOG_LEVEL: (.LOG_LEVEL // "info" | tostring),
      API_AUTH_NAME: (.API_AUTH_NAME // "admin" | tostring),
      API_AUTH_CODE: (.API_AUTH_CODE // "drpys" | tostring),
      API_PWD: (.API_PWD // "dzyyds" | tostring),
      COOKIE_AUTH_CODE: (.COOKIE_AUTH_CODE // "drpys" | tostring),
      CLIPBOARD_SECURITY_CODE: (.CLIPBOARD_SECURITY_CODE // "drpys" | tostring),
      ENABLE_TASKER: (.ENABLE_TASKER // 0 | tostring),
      TASKER_INTERVAL: (.TASKER_INTERVAL // 0 | tostring),
      ENABLE_TERMINAL: (.ENABLE_TERMINAL // 1 | tostring),
      READ_ONLY_MODE: (.READ_ONLY_MODE // 0 | tostring),
      CAT_DEBUG: (.CAT_DEBUG // 1 | tostring)
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
        "ROOT",
        "NODE_PATH",
        "NODE_ENV",
        "VIRTUAL_ENV",
        "PHP_PATH",
        "PYTHON_PATH",
        "LOG_WITH_FILE",
        "LOG_LEVEL",
        "API_AUTH_NAME",
        "API_AUTH_CODE",
        "API_PWD",
        "COOKIE_AUTH_CODE",
        "CLIPBOARD_SECURITY_CODE",
        "ENABLE_TASKER",
        "TASKER_INTERVAL",
        "ENABLE_TERMINAL",
        "READ_ONLY_MODE",
        "CAT_DEBUG"
      ] | index($name)) | not)
    | "export \($name)=\((.value // "") | tostring | @sh)"
  ' "$OPTIONS_FILE" >> "$ENV_FILE"
fi
