#!/bin/sh
set -eu

SHARED_DIR="/addon_configs/mihomo/config"
TARGET_DIR="/config"

mkdir -p "$SHARED_DIR" "$TARGET_DIR"

rm -rf /config/caddy
ln -s "$SHARED_DIR" /config/caddy
