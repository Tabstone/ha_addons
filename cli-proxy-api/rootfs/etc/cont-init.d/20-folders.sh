#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_CONFIG_DIR="${ROOT_DIR}/config"
APP_AUTH_DIR="${ROOT_DIR}/auth-dir"

mkdir -p "$APP_CONFIG_DIR" "$APP_AUTH_DIR"

# Seed default config if missing
if [ ! -f "$APP_CONFIG_DIR/config.yaml" ] && [ -f "/defaults/config.yaml" ]; then
  cp "/defaults/config.yaml" "$APP_CONFIG_DIR/config.yaml"
fi

# Symlink config file to where upstream expects it
rm -f /CLIProxyAPI/config.yaml
ln -s "$APP_CONFIG_DIR/config.yaml" /CLIProxyAPI/config.yaml

# Symlink auth-dir to where upstream expects it (~/.cli-proxy-api)
rm -rf /root/.cli-proxy-api
ln -s "$APP_AUTH_DIR" /root/.cli-proxy-api
