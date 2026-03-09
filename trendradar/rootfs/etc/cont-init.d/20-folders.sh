#!/bin/sh
set -eu

CONFIG_DIR="/config"
HOST_CONFIG_DIR="/homeassistant/addons_config/trendradar"
HOST_OUTPUT_DIR="/homeassistant/addons_config/trendradar_output"
OLD_OUTPUT_DIR="${HOST_CONFIG_DIR}/output"

mkdir -p "$CONFIG_DIR" "$HOST_CONFIG_DIR" "$HOST_OUTPUT_DIR"

if [ -d /data/config ] && [ ! -f "$CONFIG_DIR/config.yaml" ]; then
  cp -a /data/config/. "$CONFIG_DIR/"
fi

if [ -d /data/output ] && [ -z "$(ls -A "$HOST_OUTPUT_DIR" 2>/dev/null)" ]; then
  cp -a /data/output/. "$HOST_OUTPUT_DIR/"
fi

if [ -d "$OLD_OUTPUT_DIR" ] && [ -z "$(ls -A "$HOST_OUTPUT_DIR" 2>/dev/null)" ]; then
  cp -a "$OLD_OUTPUT_DIR"/. "$HOST_OUTPUT_DIR/"
  rm -rf "$OLD_OUTPUT_DIR"
fi

for file in config.yaml frequency_words.txt ai_analysis_prompt.txt ai_translation_prompt.txt; do
  if [ ! -f "$CONFIG_DIR/$file" ] && [ -f "/defaults/$file" ]; then
    cp "/defaults/$file" "$CONFIG_DIR/$file"
  fi
done

rm -rf /app/config /app/output
ln -s "$CONFIG_DIR" /app/config
ln -s "$HOST_OUTPUT_DIR" /app/output
