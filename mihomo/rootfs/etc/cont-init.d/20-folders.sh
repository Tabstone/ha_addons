#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_CONFIG_DIR="${ROOT_DIR}/config"

mkdir -p "$APP_CONFIG_DIR" /root/.config

if [ -d /data ] && [ -f /data/config.yaml ] && [ ! -f "$APP_CONFIG_DIR/config.yaml" ]; then
  mv /data/config.yaml "$APP_CONFIG_DIR/config.yaml"
fi

if [ -d /root/.config/mihomo ] && [ ! -L /root/.config/mihomo ]; then
  for item in /root/.config/mihomo/*; do
    [ -e "$item" ] || continue
    if [ ! -e "$APP_CONFIG_DIR/$(basename "$item")" ]; then
      mv "$item" "$APP_CONFIG_DIR/"
    fi
  done
fi

if [ ! -f "$APP_CONFIG_DIR/config.yaml" ] && [ -f "/defaults/config.yaml" ]; then
  cp "/defaults/config.yaml" "$APP_CONFIG_DIR/config.yaml"
fi

rm -rf /root/.config/mihomo
ln -s "$APP_CONFIG_DIR" /root/.config/mihomo
