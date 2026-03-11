#!/bin/sh
set -eu

BASE_SLUG="mihomo"
ADDON_CONFIG_DIR=""

if [ -d "/addon_configs/${BASE_SLUG}" ]; then
  ADDON_CONFIG_DIR="/addon_configs/${BASE_SLUG}"
else
  for dir in /addon_configs/*_"${BASE_SLUG}"; do
    if [ -d "$dir" ]; then
      if [ -n "$ADDON_CONFIG_DIR" ]; then
        echo "Multiple add-on config directories found for ${BASE_SLUG} under /addon_configs. Please install/start the main add-on." >&2
        exit 1
      fi
      ADDON_CONFIG_DIR="$dir"
    fi
  done
fi

if [ -z "$ADDON_CONFIG_DIR" ]; then
  echo "Unable to find add-on config directory for ${BASE_SLUG} under /addon_configs. Please install/start the main add-on." >&2
  exit 1
fi

SHARED_DIR="${ADDON_CONFIG_DIR}/config"
TARGET_DIR="/config"

mkdir -p "$SHARED_DIR" "$TARGET_DIR"

rm -rf /config/caddy
ln -s "$SHARED_DIR" /config/caddy
