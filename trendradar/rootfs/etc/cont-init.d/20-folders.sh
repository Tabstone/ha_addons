#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_CONFIG_DIR="${ROOT_DIR}/config"
APP_OUTPUT_DIR="${ROOT_DIR}/output"

mkdir -p "$APP_CONFIG_DIR" "$APP_OUTPUT_DIR"

for file in config.yaml frequency_words.txt ai_analysis_prompt.txt ai_translation_prompt.txt timeline.yaml; do
  if [ -f "$ROOT_DIR/$file" ] && [ ! -f "$APP_CONFIG_DIR/$file" ]; then
    mv "$ROOT_DIR/$file" "$APP_CONFIG_DIR/$file"
  fi
  if [ ! -f "$APP_CONFIG_DIR/$file" ] && [ -f "/defaults/$file" ]; then
    cp "/defaults/$file" "$APP_CONFIG_DIR/$file"
  fi
done

rm -rf /app/config /app/output
ln -s "$APP_CONFIG_DIR" /app/config
ln -s "$APP_OUTPUT_DIR" /app/output
