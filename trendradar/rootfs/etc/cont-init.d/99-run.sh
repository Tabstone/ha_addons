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
    'RUN_MODE': 'cron',
    'CRON_SCHEDULE': '*/30 * * * *',
    'IMMEDIATE_RUN': True,
    'FEISHU_WEBHOOK_URL': '',
    'TELEGRAM_BOT_TOKEN': '',
    'TELEGRAM_CHAT_ID': '',
    'DINGTALK_WEBHOOK_URL': '',
    'WEWORK_WEBHOOK_URL': '',
    'WEWORK_MSG_TYPE': '',
    'EMAIL_FROM': '',
    'EMAIL_PASSWORD': '',
    'EMAIL_TO': '',
    'EMAIL_SMTP_SERVER': '',
    'EMAIL_SMTP_PORT': '',
    'NTFY_SERVER_URL': 'https://ntfy.sh',
    'NTFY_TOPIC': '',
    'NTFY_TOKEN': '',
    'BARK_URL': '',
    'SLACK_WEBHOOK_URL': '',
    'GENERIC_WEBHOOK_URL': '',
    'GENERIC_WEBHOOK_TEMPLATE': '',
    'AI_ANALYSIS_ENABLED': False,
    'AI_API_KEY': '',
    'AI_MODEL': '',
    'AI_API_BASE': '',
    'S3_ENDPOINT_URL': '',
    'S3_BUCKET_NAME': '',
    'S3_ACCESS_KEY_ID': '',
    'S3_SECRET_ACCESS_KEY': '',
    'S3_REGION': '',
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

env['ENABLE_WEBSERVER'] = 'true'
env['WEBSERVER_PORT'] = '8080'
env['CONFIG_PATH'] = '/app/config/config.yaml'
env['FREQUENCY_WORDS_PATH'] = '/app/config/frequency_words.txt'

output = pathlib.Path('/tmp/addon_env.sh')
with output.open('w', encoding='utf-8') as fh:
    for key, value in env.items():
        fh.write(f'export {key}={shlex.quote(value)}\n')
PY
