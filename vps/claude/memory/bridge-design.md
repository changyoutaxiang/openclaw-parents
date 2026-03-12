# 桥接层设计笔记

## Phase 1 (MVP) 关键路径
1. OpenClaw Plugin 骨架 → `openclaw.plugin.json` + `index.ts`
2. `bridge_dispatch` tool → 构建 prompt, 启动 `claude -p`, 写任务 JSON
3. `bridge-watcher` service → 30s 轮询, 检测进程退出, 解析 JSON 输出
4. 完成回调 → `openclaw system event --text "BRIDGE_DONE:..."` 或 watcher 直接检测

## Phase 3 tmux 方案注意事项
- tmux send-keys 有时序和转义脆弱性
- 必须用 `--dangerously-skip-permissions` 防止权限弹窗阻塞
- 在 prompt 和 CLAUDE.md 双重嵌入回调指令，防止上下文压缩丢失
- 设 tmux `destroy-unattached on` 防僵尸
- watcher 可直接读 `~/.claude/teams/` 和 `~/.claude/tasks/` 监控团队进度

## OpenClaw 集成要点
- Webhook: `POST /hooks/agent` (async 202) / `POST /hooks/wake` (sync 200)
- 后台进程: `bash background:true pty:true` + `process action:log` 读输出
- Cron: 支持 isolated session，适合做清理和日报
- 文件系统: `~/.openclaw/workspace/` 完全可读写

## Claude Code 集成要点
- `claude -p "prompt" --output-format json` → 结构化输出含 cost/usage
- `--max-budget-usd` → 每任务硬限
- `--allowedTools` → 工具白名单
- `--model opus|sonnet|haiku` → 模型选择
- Agent SDK (TypeScript): `@anthropic-ai/claude-agent-sdk` 的 `query()` 可编程控制
