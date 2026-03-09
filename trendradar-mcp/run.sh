#!/bin/sh
set -eu

if [ -d /etc/cont-init.d ]; then
  for script in /etc/cont-init.d/*; do
    [ -f "$script" ] || continue
    if [ -x "$script" ]; then
      "$script"
    else
      /bin/sh "$script"
    fi
  done
fi

if [ -f /tmp/addon_env.sh ]; then
  . /tmp/addon_env.sh
fi

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

exec python -m mcp_server.server --transport http --host 0.0.0.0 --port "${MCP_PORT:-3333}"
