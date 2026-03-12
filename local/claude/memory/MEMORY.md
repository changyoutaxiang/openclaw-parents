# Memory — 龙虾母亲工作记忆

> 全局身份在 `~/.claude/CLAUDE.md`。本文件记录细节和进行中的事项。
> 详情见各主题文件。行数控制在 200 以内。

## 当前系统状态（v2.2, 2026-03-11）

### 本地 Mac（四虾）
- OpenClaw v2.2，四虾全部上线
- memory-lancedb-pro: ✅ 正常
- Slack: ✅ socket mode connected
- Lobster: ✅ 已安装，worker 专属
- Worker model: minimax-portal/MiniMax-M2.5（primary）
- VPS 互通: ✅ autossh 隧道 18790→18789，`vps-claw` alias 可用

### VPS 云端（四虾）— 完整运行中
- IP: 207.246.110.130, Ubuntu 24.04, 4vCPU/8GB/180GB
- 四虾: 自动虾🤖 / 养生虾🌿 / 情报虾🔍 / 编程虾💻
- Gateway: `http://207.246.110.130:18789` (bind: lan)
- 本地访问: `ws://127.0.0.1:18790`（通过 autossh 隧道）
- Slack: ✅ 四频道全通
- 定时任务: AI早餐（每天08:00 CST）+ 马尼拉天气x9（3/12-3/20）

## 近期待办

- [x] 迁移定时任务（天气/AI早餐）到 VPS 自动虾 ✅
- [ ] 管理虾深度设计（接入项目/团队信息钥匙）
- [ ] Gemini Skill 知识迁移（Leon 人工审查）
- [x] VPS 端 OpenClaw 对接 ✅ 已完成重建
- [x] VPS ↔ 本地 Gateway 互通 ✅ autossh + vps-claw 别名
- [ ] Phase 3: 通用工具编排
- [ ] 飞书→钉钉迁移（2026-04）

## Leon 的偏好与习惯

- 直接干，少废话，结论先行
- 高度信任，给大量自主权
- 喜欢养育/成长的比喻（"龙虾帝国"、"儿女双全"）
- 每次学到东西都要沉淀文档

## 架构速记

- Worker scope: `[agent:worker]` only（不进 global）
- kuro/brain/architect 可访问 `[global, agent:*]`
- VPS 默认级联: Codex → MiniMax M2.5(API key) → openrouter/Claude
- 情报虾特殊: Kimi K2.5 → Claude → Codex
- VPS 互通: `vps-claw <cmd>` = openclaw 对 VPS 操作（autossh 隧道 18790→18789）
- VPS token: `a154e905...`，本地 token: `3f2bad04...`
- LaunchAgent: `com.lobster-empire.vps-tunnel`（~/Library/LaunchAgents/）
- **移动捕获**: Leon 发 `/log <内容>` → VPS 自动虾 → `workspace/auto/mobile-captures/YYYYMMDD.md` → kuro 归来处理

## Git 备份仓库

- 仓库: `https://github.com/changyoutaxiang/openclaw-parents`
- 本地: `~/Projects/openclaw-parents/`
- 本地同步: `cd ~/Projects/openclaw-parents && ./local/sync.sh`
- VPS 首次部署: `curl -fsSL .../vps/setup.sh | bash`，之后 `lobster-sync`
- 自动 cron: 本地 23:30 CST / VPS 23:00 CST 每日同步
- 内容: claude 记忆 + openclaw workspace md + 脱敏配置模板

## 关键文件索引

| 文件 | 用途 |
|------|------|
| `~/.openclaw/openclaw.json` | 本地主配置 |
| `~/.openclaw/logs/gateway.err.log` | 本地错误日志 |
| `~/.openclaw/workspace/architect/ROADMAP.md` | 路线图 |
| `~/.openclaw/workspace/kuro/SOUL.md` | 效率虾人格（含出差归来处理） |
| `~/.openclaw/workspace/shared/DIVISION_OF_LABOR.md` | 本地/VPS 分工协议 |
| VPS `/root/.openclaw/workspace/auto/HEARTBEAT.md` | 自动虾心跳（含 /log 捕获协议） |
| VPS `/root/.openclaw/workspace/auto/mobile-captures/` | 移动捕获缓冲目录 |
| `memory/lobster-empire.md` | 架构详情（含 VPS） |
| `memory/troubleshooting.md` | 故障排查经验库 |

## 成长记录

| 日期 | 学到的 |
|------|--------|
| 2026-03-10 | Phase 1+2 搭建、memory-lancedb-pro 部署、Lobster 安装 |
| 2026-03-11 | 修复 apache-arrow、Slack 断连诊断、三层记忆体系建立 |
| 2026-03-11 | VPS 云端分部重建（4虾+完整workspace）、MiniMax API key 配置、健康数据迁移 |
| 2026-03-11 | VPS ↔ 本地互通：autossh 隧道 + gateway.remote 配置 + vps-claw shell alias |
| 2026-03-11 | 移动捕获系统：VPS 自动虾作缓冲区，kuro 归来批处理，端到端测试通过 ✅ |
