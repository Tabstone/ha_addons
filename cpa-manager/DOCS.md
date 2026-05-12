# CPA Manager

CPA Manager 的 Home Assistant add-on 薄封装，直接复用上游官方镜像 `seakee/cpa-manager` 的 Usage Service，用 SQLite 持久化 CPA 请求统计，并提供内置管理面板。

## 部署形态

这个 add-on 对应上游 README 中的完整 Docker Usage Service 方案：

- add-on 仅运行 `cpa-manager` Usage Service
- 不包含 CLI Proxy API 本体
- 默认通过 `18317` 提供内置面板 `/management.html`
- 默认把 SQLite 数据持久化到 add-on 配置目录

## 持久化目录

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  data/
    usage.sqlite
    ...
```

上游服务默认把 SQLite 数据写到 `/data/usage.sqlite`。
在 Home Assistant add-on 中，wrapper 不会复用系统保留的 `/data` 目录，而是通过环境变量把上游数据目录重定向到 `/config/data`，因此数据库实际落盘到 `/config/data/usage.sqlite`。

## 首次启动前建议配置

你至少需要准备一个独立运行的 CLI Proxy API 实例，并满足：

- 已开启 Management
- 已启用 usage statistics / usage queue
- 可以从当前 add-on 访问到 CPA 的管理地址

配置页里推荐填写：

- `CPA_UPSTREAM_URL`：上游 CPA 地址，例如 `http://homeassistant.local:8317`
- `CPA_MANAGEMENT_KEY`：CPA 的 Management Key

如果留空，也可以在首次打开内置面板后通过 setup 流程手动填写。

## 访问方式

- Ingress：Home Assistant 侧边栏进入，入口为 `/management.html`
- 外部端口：默认 `18317/tcp`
- Web UI：`http://homeassistant.local:18317/management.html`

## 配置说明

wrapper 会固定这些与 add-on 结构强相关的运行参数：

- `HTTP_ADDR=0.0.0.0:18317`
- `USAGE_DATA_DIR=/config/data`
- `USAGE_DB_PATH=/config/data/usage.sqlite`

配置页显式提供：

- `CPA_UPSTREAM_URL`
- `CPA_MANAGEMENT_KEY`
- `USAGE_COLLECTOR_MODE`
- `USAGE_CORS_ORIGINS`

其余上游支持但本 add-on 未显式建模的环境变量，可通过 `env_vars` 继续传递，例如：

- `USAGE_RESP_QUEUE`
- `USAGE_RESP_POP_SIDE`
- `USAGE_BATCH_SIZE`
- `USAGE_POLL_INTERVAL_MS`
- `USAGE_QUERY_LIMIT`
- `USAGE_RESP_TLS_SKIP_VERIFY`
- `PANEL_PATH`

## 升级说明

- 该 add-on 直接使用上游官方镜像 `seakee/cpa-manager`
- 仓库级同步 workflow 会检查上游镜像 semver tag
- 检测到新的上游版本后，会自动更新 add-on 的 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
