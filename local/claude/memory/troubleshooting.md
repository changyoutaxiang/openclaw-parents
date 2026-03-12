# 故障排查经验库

## [2026-03-11] memory-lancedb-pro: Cannot find module 'apache-arrow'

**症状**: Gateway 启动日志显示 `retrieval: FAIL`，每 15 分钟报错：
```
memory-lancedb-pro: failed to load LanceDB. Error: Cannot find module 'apache-arrow'
```

**根因**: `apache-arrow` 是 `@lancedb/lancedb` 的 peer dependency，npm 不会自动安装 peer deps，导致缺失。

**修复**:
```bash
cd ~/.openclaw/extensions/memory-lancedb-pro
npm install apache-arrow@18.1.0
openclaw gateway restart
```

**验证**: 日志出现 `memory-lancedb-pro: initialized successfully (embedding: OK, retrieval: OK, mode: hybrid, FTS: enabled)`

---

## [2026-03-11] Slack 所有频道无响应（Codex + 网络双重故障）

**症状**: Slack 频道收不到 agent 回复，日志显示：
- `Codex error: server_error` （OpenAI 上游 500）
- `getaddrinfo ENOTFOUND slack.com` （DNS 解析失败）
- `socket-mode pong timeout` × N

**根因**: OpenAI 间歇性 500 + 本地网络短暂故障，WebSocket 断连后没有完全恢复（12 次重试均失败）。

**修复**: 网络恢复后手动重启 gateway：
```bash
openclaw gateway restart
```

**经验**:
- Codex 500 是上游问题，不用动配置，等恢复或重试即可
- 两个 provider 都在 openai-codex 下时，OpenAI 整体抖动 fallback 也救不了，考虑加跨 provider fallback（如 MiniMax M2.5）
- 排查顺序: 先看网络 → 再看 Slack WebSocket → 再看模型错误

---

## [2026-03-10] memorySearch.provider "jina" 不支持

**症状**: Config 写了 `memorySearch.provider: "jina"`，gateway 报 config validation error

**根因**: 内置 memorySearch 只支持 `openai | local | gemini | voyage | mistral | ollama`，且不接受 `apiKey` 字段

**修复**: 改为 `provider: "local"`（使用内置 embeddinggemma-300m）

---

## [2026-03-10] journal_session.py --json 参数位置错误

**症状**: `python3 journal_session.py log --json "内容"` 报 argparse error

**根因**: `--json` 是全局参数，必须在子命令之前

**正确用法**:
```bash
cd "/Users/wangdong/Desktop/Gemini skill" && python3 99_System/workflows/journal_session.py --json log "内容"
```
