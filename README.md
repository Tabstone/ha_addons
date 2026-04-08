# Tabstone Home Assistant Add-ons

这个仓库收口了一些原本需要单独用 Docker 或 docker-compose 部署的服务。因为不想在 Home Assistant 之外再维护太多独立容器，所以把这些服务迁移成了 Home Assistant add-ons，统一在 HA 内安装、配置和升级。

仓库中的 add-on 采用薄封装思路：尽量直接复用上游镜像和启动逻辑，只补 Home Assistant 所需的目录映射、配置注入、启动包装和文档。这里的迁移与适配代码由 AI 协助完成，但各项目的核心实现、版权和发布仍归原始上游仓库或镜像维护者所有。

## Add-ons

| Add-on | 目录 | 说明 | 上游项目地址 | 上游镜像地址 |
| --- | --- | --- | --- | --- |
| TrendRadar | `trendradar/` | 趋势分析服务，提供 Web UI 与通知能力 | 公开源码地址暂未确认，当前直接跟随镜像源 | [wantcat/trendradar](https://hub.docker.com/r/wantcat/trendradar) |
| TrendRadar MCP | `trendradar-mcp/` | TrendRadar 的 MCP 服务，复用主 add-on 数据 | 公开源码地址暂未确认，当前直接跟随镜像源 | [wantcat/trendradar-mcp](https://hub.docker.com/r/wantcat/trendradar-mcp) |
| CLI Proxy API | `cli-proxy-api/` | CLI Proxy API 服务，保留配置与鉴权目录 | 公开源码地址暂未确认，当前直接跟随镜像源 | [eceasy/cli-proxy-api](https://hub.docker.com/r/eceasy/cli-proxy-api) |
| Mihomo | `mihomo/` | Mihomo 核心，保留配置目录并映射宿主网络能力 | [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo) | [metacubex/mihomo](https://hub.docker.com/r/metacubex/mihomo) |
| MetaCubeXD | `metacubexd/` | Mihomo 的 Web UI | [MetaCubeX/metacubexd](https://github.com/MetaCubeX/metacubexd) | [ghcr.io/metacubex/metacubexd](https://github.com/MetaCubeX/metacubexd/pkgs/container/metacubexd) |
| Metapi | `metapi/` | Metapi AI API 聚合管理与统一代理，默认持久化 SQLite 数据目录 | [cita-777/metapi](https://github.com/cita-777/metapi) | [1467078763/metapi](https://hub.docker.com/r/1467078763/metapi) |
| Sub2API | `sub2api/` | Sub2API 独立网关封装，依赖外部 PostgreSQL 与 Redis | [Wei-Shaw/sub2api](https://github.com/Wei-Shaw/sub2api) | [weishaw/sub2api](https://hub.docker.com/r/weishaw/sub2api) |

## 维护方式

- 每个 add-on 都尽量跟随上游镜像版本，不重写上游业务逻辑。
- 仓库级 GitHub Actions 会检查上游镜像版本，并自动同步 `build.yaml`、`config.yaml.version` 与 `CHANGELOG.md`。
- 具体的使用方式、目录映射和配置项说明，请直接查看各 add-on 目录下的 `DOCS.md`。
