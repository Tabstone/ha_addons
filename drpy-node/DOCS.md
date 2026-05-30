# drpy-node

drpy-node 的 Home Assistant add-on 薄封装，直接复用上游 GHCR 镜像 `ghcr.io/hjdhnx/drpy-node`，提供 drpyS Web UI、HTTP API 和 websocket 日志服务。

## 部署形态

这个 add-on 对应上游常见 Docker 部署：

- 主服务端口固定为 `5757`
- websocket 日志服务端口固定为 `57575`
- 上游镜像入口保持为 `node index.js`
- 不默认启用 Ingress，优先通过宿主机端口访问

## 持久化目录

上游示例把 `./drpy-node` 挂载到 `/root/drpy-node`。在 Home Assistant add-on 中，这个路径会指向 add-on 配置目录 `/config`。

首次启动后会在 `/addon_configs/<实际 add-on slug>/` 下创建：

```text
/addon_configs/<实际 add-on slug>/
  .env
  config/
  data/
  json/
  jx/
  logs/
  public/
    sub/
  quark_cache/
  uc_cache/
  vod_cache/
```

wrapper 会把这些路径软链接回上游应用目录：

- `/app/.env`
- `/app/config`
- `/app/data`
- `/app/json`
- `/app/jx`
- `/app/logs`
- `/app/public/sub`
- `/app/vod_cache`
- `/app/quark_cache`
- `/app/uc_cache`
- `/root/drpy-node`

这样管理后台写入的配置、订阅、源文件和缓存可以在镜像升级后保留。

## 访问方式

- Web UI：`http://homeassistant.local:5757/`
- Admin 管理面板：`http://homeassistant.local:5757/apps/admin`
- Websocket 日志：`http://homeassistant.local:57575/`

默认不开启 Ingress，避免复杂前端和 websocket 在 iframe 里出现兼容问题。

## 配置说明

配置页提供了常用环境变量：

- `API_AUTH_NAME` / `API_AUTH_CODE`：访问首页和管理接口的 Basic Auth
- `API_PWD`：T4 接口密码和 T3 文件访问密码
- `COOKIE_AUTH_CODE`：设置中心入库授权码
- `CLIPBOARD_SECURITY_CODE`：剪切板接口安全码
- `ENABLE_TERMINAL`：后台管理在线终端开关
- `READ_ONLY_MODE`：只读模式
- `LOG_WITH_FILE` / `LOG_LEVEL`：日志输出设置

更多上游环境变量可以通过 `env_vars` 追加，例如：

- `EPG_URL`
- `LOGO_URL`
- `LIVE_URL`
- `MAX_TASK`
- `FORCE_HEADER`
- `DR2_API_TYPE`
- `DS_REQ_LIB`
- `QQ_EMAIL`
- `QQ_SMTP_AUTH_CODE`

## 升级说明

- 该 add-on 使用 `ghcr.io/hjdhnx/drpy-node`
- `build.yaml` 固定明确 tag，不使用 `latest`
- `config.yaml.version` 使用 `<upstream-version>-<wrapper-revision>`
- 仓库级同步 workflow 会从 GHCR registry tag 列表读取最高 semver，自动更新 `build.yaml`、`config.yaml.version` 和 `CHANGELOG.md`
