#!/bin/sh
set -eu

OWN_CONFIG_DIR="/config"
SHARED_CONFIG_DIR="/homeassistant/addons_config/trendradar"
SHARED_OUTPUT_DIR="/homeassistant/addons_config/trendradar_output"
OLD_OWN_OUTPUT_DIR="${OWN_CONFIG_DIR}/output"

mkdir -p "$OWN_CONFIG_DIR" "$SHARED_CONFIG_DIR" "$SHARED_OUTPUT_DIR"

if [ -f "$OWN_CONFIG_DIR/config.yaml" ] && [ ! -f "$SHARED_CONFIG_DIR/config.yaml" ]; then
  cp -a "$OWN_CONFIG_DIR"/. "$SHARED_CONFIG_DIR/"
fi

if [ -d "$OLD_OWN_OUTPUT_DIR" ] && [ -z "$(ls -A "$SHARED_OUTPUT_DIR" 2>/dev/null)" ]; then
  cp -a "$OLD_OWN_OUTPUT_DIR"/. "$SHARED_OUTPUT_DIR/"
fi

for file in config.yaml frequency_words.txt ai_analysis_prompt.txt ai_translation_prompt.txt; do
  if [ ! -f "$SHARED_CONFIG_DIR/$file" ] && [ -f "/defaults/$file" ]; then
    cp "/defaults/$file" "$SHARED_CONFIG_DIR/$file"
  fi
done

rm -rf /app/config /app/output
ln -s "$SHARED_CONFIG_DIR" /app/config
ln -s "$SHARED_OUTPUT_DIR" /app/output
