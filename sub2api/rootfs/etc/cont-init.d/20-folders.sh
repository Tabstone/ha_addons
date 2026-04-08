#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_DATA_DIR="${ROOT_DIR}/data"

mkdir -p "$APP_DATA_DIR"

rm -rf /app/data
ln -s "$APP_DATA_DIR" /app/data
