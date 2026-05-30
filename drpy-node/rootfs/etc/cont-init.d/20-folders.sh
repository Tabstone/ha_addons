#!/bin/sh
set -eu

ROOT_DIR="/config"
APP_DIR="/app"

mkdir -p "$ROOT_DIR" /root

seed_dir() {
  src="$1"
  dest="$2"
  if [ ! -d "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
  fi
}

seed_file() {
  src="$1"
  dest="$2"
  if [ ! -f "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  fi
}

seed_file /defaults/.env "$ROOT_DIR/.env"

for name in config data json jx public/sub logs vod_cache quark_cache uc_cache; do
  if [ -e "$APP_DIR/$name" ]; then
    seed_dir "$APP_DIR/$name" "$ROOT_DIR/$name"
  else
    mkdir -p "$ROOT_DIR/$name"
  fi
done

for name in .env config data json jx logs vod_cache quark_cache uc_cache; do
  rm -rf "$APP_DIR/$name"
  ln -s "$ROOT_DIR/$name" "$APP_DIR/$name"
done

mkdir -p "$APP_DIR/public"
rm -rf "$APP_DIR/public/sub"
ln -s "$ROOT_DIR/public/sub" "$APP_DIR/public/sub"

rm -rf /root/drpy-node
ln -s "$ROOT_DIR" /root/drpy-node
