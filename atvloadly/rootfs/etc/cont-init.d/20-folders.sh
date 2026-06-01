#!/bin/sh
set -eu

ROOT_DIR="/config"

mkdir -p \
  "$ROOT_DIR/lockdown" \
  "$ROOT_DIR/PlumeImpactor" \
  "$ROOT_DIR/PlumeImpactor/pairing_files" \
  "$ROOT_DIR/logs" \
  /data \
  /root/.config

if [ -f /data/config.yaml ] && [ ! -f "$ROOT_DIR/config.yaml" ]; then
  cp /data/config.yaml "$ROOT_DIR/config.yaml"
fi
if [ -f /keep/config.yaml ] && [ ! -f "$ROOT_DIR/config.yaml" ]; then
  cp /keep/config.yaml "$ROOT_DIR/config.yaml"
fi
if [ ! -f "$ROOT_DIR/app.log" ]; then
  touch "$ROOT_DIR/app.log"
fi

for name in config.yaml app.log lockdown PlumeImpactor logs; do
  rm -rf "/data/$name"
  ln -s "$ROOT_DIR/$name" "/data/$name"
done

rm -rf /var/lib/lockdown
ln -s "$ROOT_DIR/lockdown" /var/lib/lockdown

rm -rf /root/.config/PlumeImpactor
ln -s "$ROOT_DIR/PlumeImpactor" /root/.config/PlumeImpactor
