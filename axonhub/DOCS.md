# AxonHub

AxonHub 的 Home Assistant add-on 薄封装，直接复用上游官方镜像 `looplj/axonhub`，默认使用 SQLite 单容器模式，并把配置、数据库和日志持久化到 Home Assistant add-on 配置目录。

## 部署形态

这个 add-on 对应上游 Docker Compose 中的 SQLite 单容器方案：

- add-on 只运行 AxonHub 主服务
- 默认监听 `8090`
- 默认使用 SQLite，不附带 PostgreSQL 或 MySQL
- 不默认启用 Ingress，优先通过宿主机端口访问 Web UI

## 持久化目录

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  config.yml
  data/
    axonhub.db
    ...
  logs/
    axonhub.log
    ...
```

wrapper 会建立这些软链接：

- `/app/config.yml` -> `/config/config.yml`
- `/app/data` -> `/config/data`
- `/app/logs` -> `/config/logs`

这样可以保留上游默认的 `/app/config.yml` 配置入口，同时让实际数据留在 HA add-on 配置目录。

## 首次启动前建议配置

默认配置已经可以直接启动。首次打开 Web UI 后，按 AxonHub 的初始化向导创建管理员账号，然后再配置上游模型渠道和 API key。

配置页里显式提供：

- `AXONHUB_DB_DIALECT`：默认 `sqlite3`
- `AXONHUB_DB_DSN`：默认写入 `/config/data/axonhub.db`
- `AXONHUB_LOG_OUTPUT`：默认 `stdio`，也可以切换为 `file`
- `AXONHUB_SERVER_DISABLE_SSL_VERIFY`
- `AXONHUB_SERVER_API_AUTH_ALLOW_NO_AUTH`

## 访问方式

- 外部端口：默认 `8090/tcp`
- Web UI：`http://homeassistant.local:8090/`
- API base URL：`http://homeassistant.local:8090/v1`

当前默认不开启 Ingress，优先使用宿主机端口访问，避免复杂前端在 iframe 下出现兼容问题。

## 可选扩展环境变量

配置页里的 `env_vars` 可继续传递上游支持但本 add-on 未显式建模的环境变量，例如：

- `AXONHUB_SERVER_NAME`
- `AXONHUB_SERVER_BASE_PATH`
- `AXONHUB_LOG_LEVEL`
- `AXONHUB_CACHE_MODE`
- `AXONHUB_CACHE_REDIS_URL`
- `AXONHUB_METRICS_ENABLED`
- `AXONHUB_GC_CRON`

如果你希望使用外部 PostgreSQL 或 MySQL，可以在配置页修改 `AXONHUB_DB_DIALECT` 和 `AXONHUB_DB_DSN`，数据库服务本身需要在 add-on 外部准备好。

## 升级说明

- 该 add-on 直接使用上游官方镜像 `looplj/axonhub`
- `build.yaml` 固定明确上游 tag
- `config.yaml.version` 使用 `<upstream-version>-<wrapper-revision>`，用于 Home Assistant 升级检测
- 仓库级同步 workflow 会检查 Docker Hub 上的 semver tag，并自动更新 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
