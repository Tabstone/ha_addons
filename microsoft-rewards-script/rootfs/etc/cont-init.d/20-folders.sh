#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_DIR="/usr/src/microsoft-rewards-script"
CONFIG_DIR="${ROOT_DIR}/config"
SESSIONS_DIR="${ROOT_DIR}/sessions"

mkdir -p "$CONFIG_DIR" "$SESSIONS_DIR"

rm -rf "${APP_DIR}/dist/config" "${APP_DIR}/dist/browser/sessions"
mkdir -p "${APP_DIR}/dist/browser"
ln -s "$CONFIG_DIR" "${APP_DIR}/dist/config"
ln -s "$SESSIONS_DIR" "${APP_DIR}/dist/browser/sessions"
