# atvloadly

atvloadly 的 Home Assistant add-on 薄封装，直接复用上游镜像 `ghcr.io/bitxeno/atvloadly`，用于通过 Web UI 给 Apple TV 侧载 IPA，并支持自动刷新应用。

## 部署形态

这个 add-on 对应上游 Docker / Docker Compose 部署：

- 容器内服务端口：`80`
- Home Assistant 默认宿主端口：`5533`
- 上游数据目录：`/data`
- 默认不开启 Ingress，优先通过宿主机端口访问 Web UI
- 使用 host network、host D-Bus、full access，并关闭 AppArmor，以贴近上游对 Avahi/D-Bus 和 pairing 的要求
- 该 add-on 设置了 `protected: false`，否则 `host_dbus` 和 `full_access` 不会生效

## 持久化目录

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  config.yaml
  app.log
  lockdown/
  PlumeImpactor/
    pairing_files/
  logs/
```

wrapper 会把这些路径链接回上游期望的位置：

- `/data/config.yaml`
- `/data/app.log`
- `/data/lockdown`
- `/data/PlumeImpactor`
- `/var/lib/lockdown`
- `/root/.config/PlumeImpactor`

## 访问方式

- Web UI：`http://homeassistant.local:5533/`
- 健康检查：`http://homeassistant.local:5533/healthcheck`
- MCP endpoint：`http://homeassistant.local:5533/mcp`

## Apple TV 发现与配对

上游要求 Linux/OpenWrt 主机可用 `avahi-daemon`，并且 Docker 部署通常需要挂载：

- `/var/run/dbus`
- `/var/run/avahi-daemon`

Home Assistant add-on 不能用普通 Compose volume 直接声明这些运行时路径，因此本 add-on 使用：

- `host_network: true`
- `host_dbus: true`
- `full_access: true`
- `apparmor: false`
- `protected: false`

如果 Web UI 正常打开但无法发现 Apple TV，请确认 Home Assistant 主机本身的 mDNS/Avahi 能发现 `_remotepairing-manual-pairing._tcp` 服务，并让 Apple TV 进入 `Remote and Devices -> Remote App and Devices` 配对模式。

## 配置说明

配置页提供：

- `SERVICE_PORT`：容器内监听端口，默认 `80`
- `TZ`：时区
- `env_vars`：透传上游后续新增的环境变量

上游默认配置文件位于持久化目录的 `config.yaml`，默认内容来自镜像内 `/keep/config.yaml`：

```yaml
server:
  work_dir: /data
log:
  log_file: /data/app.log
```

## 升级说明

- 该 add-on 使用 `ghcr.io/bitxeno/atvloadly`
- `build.yaml` 固定明确 tag，不使用 `latest`
- `config.yaml.version` 使用 `<upstream-version>-<wrapper-revision>`
- 仓库级同步 workflow 会从 GHCR registry tag 列表读取最高 semver，自动更新 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
