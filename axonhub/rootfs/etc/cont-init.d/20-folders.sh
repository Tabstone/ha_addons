#!/bin/sh
set -eu

ROOT_DIR="/config"
CONFIG_FILE="${ROOT_DIR}/config.yml"
DATA_DIR="${ROOT_DIR}/data"
LOG_DIR="${ROOT_DIR}/logs"

mkdir -p "$DATA_DIR" "$LOG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
  cp /defaults/config.yml "$CONFIG_FILE"
fi

rm -f /app/config.yml
ln -s "$CONFIG_FILE" /app/config.yml

rm -rf /app/data /app/logs
ln -s "$DATA_DIR" /app/data
ln -s "$LOG_DIR" /app/logs
