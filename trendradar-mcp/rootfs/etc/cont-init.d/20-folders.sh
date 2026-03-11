#!/bin/sh
set -eu

BASE_SLUG="trendradar"
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

SHARED_ROOT_DIR="$ADDON_CONFIG_DIR"
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
