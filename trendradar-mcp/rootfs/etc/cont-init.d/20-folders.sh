#!/bin/sh
set -eu

SHARED_ROOT_DIR="/addon_configs/trendradar"
SHARED_CONFIG_DIR="${SHARED_ROOT_DIR}/config"
SHARED_OUTPUT_DIR="${SHARED_ROOT_DIR}/output"

mkdir -p "$SHARED_CONFIG_DIR" "$SHARED_OUTPUT_DIR"

for file in config.yaml frequency_words.txt ai_analysis_prompt.txt ai_translation_prompt.txt timeline.yaml; do
  if [ ! -f "$SHARED_CONFIG_DIR/$file" ] && [ -f "/defaults/$file" ]; then
    cp "/defaults/$file" "$SHARED_CONFIG_DIR/$file"
  fi
done

rm -rf /app/config /app/output
ln -s "$SHARED_CONFIG_DIR" /app/config
ln -s "$SHARED_OUTPUT_DIR" /app/output
