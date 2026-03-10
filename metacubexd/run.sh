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

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

exec /entrypoint.sh
