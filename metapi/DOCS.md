# Metapi

Metapi 的 Home Assistant add-on 薄封装，直接复用上游官方镜像 `1467078763/metapi`，持久化默认 SQLite 数据目录，并通过 add-on 配置页注入首次启动所需的关键环境变量。

## 部署形态

这个 add-on 对应上游推荐的单容器 Docker / Docker Compose 部署：

- add-on 仅运行 `metapi` 主服务
- 默认使用 SQLite，数据目录持久化到 Home Assistant add-on 配置目录
- 不额外启用 Ingress，优先通过宿主机端口访问 Web UI

## 持久化目录

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  data/
    hub.db
    logs/
    ...
```

上游容器中的 `/app/data` 已被映射到这里。

## 首次启动前建议配置

请在 add-on 配置页至少填写：

- `AUTH_TOKEN`：后台管理员初始登录令牌
- `PROXY_TOKEN`：下游客户端调用 `/v1/*` 时使用的 Bearer Token

建议同时设置：

- `ACCOUNT_CREDENTIAL_SECRET`：账号凭证加密密钥；留空时默认跟随 `AUTH_TOKEN`

补充说明：

- Web 管理后台登录使用 `AUTH_TOKEN`
- 下游代理访问使用 `PROXY_TOKEN`
- `CHECKIN_CRON` 和 `BALANCE_REFRESH_CRON` 只是首次启动默认值，后续也可在 Metapi 自身后台里调整

## 访问方式

- 外部端口：默认 `4000/tcp`
- Web UI：`http://homeassistant.local:4000/`

当前默认不开启 Ingress，优先使用宿主机端口访问，避免 iframe 兼容性问题。

## 可选扩展环境变量

配置页里的 `env_vars` 可继续传递上游支持但本 add-on 未显式建模的环境变量，例如：

- `DB_TYPE`
- `DB_URL`
- `DB_SSL`
- `SYSTEM_PROXY_URL`
- `ADMIN_IP_ALLOWLIST`
- 各类 OAuth 覆盖参数和通知配置参数
- 其他上游后续新增配置项

如果你希望使用外部 MySQL 或 PostgreSQL，而不是默认 SQLite，可以通过 `env_vars` 传入：

- `DB_TYPE=mysql` 或 `DB_TYPE=postgres`
- `DB_URL=<数据库连接串>`
- `DB_SSL=true`（按需）

## 升级说明

- 该 add-on 直接使用上游官方镜像 `1467078763/metapi`
- 仓库级同步 workflow 会直接检查官方 Docker Hub 标签
- 检测到新的上游版本后，会自动更新 add-on 的 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
