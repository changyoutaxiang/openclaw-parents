# TOOLS.md — VPS 云端全局工具

## 系统环境

- **OS**: Ubuntu 24.04 LTS (x64)
- **Node**: v22.22.0
- **Python**: python3
- **Git**: 已安装
- **Browser**: Headless Chromium（CDP http://127.0.0.1:18800）

## OpenClaw 内置工具

| 工具 | 说明 |
|------|------|
| `read / write / edit` | 文件读写 |
| `bash` | Shell 执行 |
| `web_search` | Brave 搜索 |
| `web_fetch` | 网页抓取 |
| `browser_*` | Headless Chromium 浏览器自动化 |
| `sessions_send` | 跨 agent 发送消息 |
| `cron_create / cron_list` | Cron 任务管理 |
| `memory_*` | 记忆读写（本地向量搜索） |

## 浏览器使用规则

- Headless Chromium 是共享资源，同一时间只允许一个 agent 操作
- 操作完毕必须关闭页面，不要留残
- 不允许登录任何需要 Leon 密码的服务
