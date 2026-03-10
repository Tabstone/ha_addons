#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
ENV_FILE="/tmp/addon_env.sh"

: > "$ENV_FILE"

if [ -f "$OPTIONS_FILE" ]; then
  # TZ with default
  TZ=$(jq -r '.TZ // "Asia/Shanghai"' "$OPTIONS_FILE")
  echo "export TZ='${TZ}'" >> "$ENV_FILE"

  # Process env_vars array
  ENV_COUNT=$(jq -r '.env_vars | length' "$OPTIONS_FILE" 2>/dev/null || echo "0")
  i=0
  while [ "$i" -lt "$ENV_COUNT" ]; do
    NAME=$(jq -r ".env_vars[$i].name // empty" "$OPTIONS_FILE")
    VALUE=$(jq -r ".env_vars[$i].value // empty" "$OPTIONS_FILE")
    if [ -n "$NAME" ]; then
      # Escape single quotes in value
      ESCAPED_VALUE=$(printf '%s' "$VALUE" | sed "s/'/'\\\\''/g")
      echo "export ${NAME}='${ESCAPED_VALUE}'" >> "$ENV_FILE"
    fi
    i=$((i + 1))
  done
else
  echo "export TZ='Asia/Shanghai'" >> "$ENV_FILE"
fi
