# Sub2API

Sub2API 的 Home Assistant add-on 薄封装，直接复用上游官方镜像 `weishaw/sub2api`，持久化应用数据目录，并通过 add-on 配置页注入运行环境变量。

## 部署形态

这个 add-on 对应上游的 `docker-compose.standalone.yml` 模式：

- add-on 仅运行 `sub2api` 主服务
- PostgreSQL 需要外部提供
- Redis 需要外部提供

适合以下场景：

- 你已经有可用的 PostgreSQL 和 Redis
- 你准备用 Home Assistant 之外的数据库/缓存服务
- 你希望先保持 add-on 封装尽量薄，不把三套服务塞进同一个容器

## 持久化目录

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  data/
    config.yaml
    logs/
    ...
```

上游容器中的 `/app/data` 已被映射到这里。

## 首次启动前必须配置

请在 add-on 配置页至少填写：

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_USER`
- `DATABASE_PASSWORD`
- `DATABASE_DBNAME`
- `REDIS_HOST`
- `REDIS_PORT`

推荐同时设置：

- `JWT_SECRET`
- `TOTP_ENCRYPTION_KEY`

如果这两个值留空，上游会在启动时生成随机值，后续重启可能导致登录会话或 2FA 状态不稳定。

## 访问方式

- 外部端口：默认 `8080/tcp`
- Web UI：`http://homeassistant.local:8080/`

当前默认不开启 Ingress，优先使用宿主机端口访问，避免 iframe 兼容性问题。

## 可选扩展环境变量

配置页里的 `env_vars` 可继续传递上游支持但本 add-on 未显式建模的环境变量，例如：

- `GEMINI_OAUTH_CLIENT_ID`
- `GEMINI_OAUTH_CLIENT_SECRET`
- `GEMINI_OAUTH_SCOPES`
- `GEMINI_QUOTA_POLICY`
- `UPDATE_PROXY_URL`
- 其他上游新增配置项

## 升级说明

- 该 add-on 直接使用上游官方镜像 `weishaw/sub2api`
- 仓库级同步 workflow 会直接检查官方 Docker Hub 标签
- 检测到新的上游版本后，会自动更新 add-on 的 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
