# CLI Proxy API

CLI Proxy API 的 Home Assistant add-on 封装，提供多模型 API 代理与认证管理。

## 持久化目录

首次启动后会在 `/addon_configs/cli-proxy-api/` 下自动创建如下结构：

```
/addon_configs/cli-proxy-api/
  config/
    config.yaml        # 主配置文件
  auth-dir/            # 认证数据目录（OAuth token 等）
```

## 首次启动

首次启动时，add-on 会自动从内置默认模板生成 `config.yaml`。
你可以通过 HA 文件编辑器或 SSH 直接编辑该文件来调整配置。

## 端口与 Ingress

- **Ingress**：通过 Home Assistant 侧边栏直接访问管理面板（默认入口 `/management.html`）
- **外部端口**：默认映射 `8317/tcp`，可在 add-on 网络设置中修改

## 配置说明

大部分配置通过 `config.yaml` 文件管理，包括：

- API 密钥（Claude / Gemini / Codex / OpenAI 兼容）
- 代理设置
- TLS 配置
- 认证与安全
- 模型路由与别名

详细配置参考上游文档。

## 环境变量

可通过 add-on 配置页面的 `env_vars` 列表传递额外环境变量。
