#!/bin/sh
set -eu

python - <<'PY'
import json
import pathlib
import shlex

options_path = pathlib.Path('/data/options.json')
options = json.loads(options_path.read_text()) if options_path.exists() else {}

def stringify(value):
    if isinstance(value, bool):
        return 'true' if value else 'false'
    return str(value)

defaults = {
    'TZ': 'Asia/Shanghai',
    'MCP_PORT': 3333,
}

env = {}
for key, default in defaults.items():
    env[key] = stringify(options.get(key, default))

for item in options.get('env_vars', []):
    if not isinstance(item, dict):
        continue
    name = item.get('name')
    if not name or name in env:
        continue
    value = item.get('value', '')
    env[name] = stringify(value)

env['CONFIG_PATH'] = '/app/config/config.yaml'
env['FREQUENCY_WORDS_PATH'] = '/app/config/frequency_words.txt'

output = pathlib.Path('/tmp/addon_env.sh')
with output.open('w', encoding='utf-8') as fh:
    for key, value in env.items():
        fh.write(f'export {key}={shlex.quote(value)}\n')
PY
