# Lobster Empire — Detailed Architecture Notes

## Current State (v2.2, 2026-03-11)
- Phase 1 + Phase 2 complete
- memory-lancedb-pro deployed (kuro + brain first batch)
- Lobster workflow engine installed for worker
- VPS cloud branch rebuilt (2026-03-11)
- **VPS ↔ Local interconnect complete (2026-03-11)**

## Local Mac Agents
| Agent | Model Primary | Heartbeat | Slack Channel |
|-------|--------------|-----------|---------------|
| kuro | Codex gpt-5.4 | 30m | C0AJJ495FK3 |
| architect | Codex gpt-5.4 | off | C0AJ4HRLHPS |
| worker | **minimax-portal/MiniMax-M2.5** | 15m | C0ALHLW4Q72 |
| brain | Codex gpt-5.4 | 30m | C0AKBR92PL5 |

Worker model cascade: minimax-portal → minimax → codex gpt-5.3 → codex gpt-5.4

## VPS Cloud Agents (207.246.110.130)
| Agent | Name | Model Primary | Heartbeat | Slack Channel |
|-------|------|--------------|-----------|---------------|
| auto | 自动虾 🤖 | Codex gpt-5.4 | 30m | C0ALJRU4BQ8 |
| health | 养生虾 🌿 | Codex gpt-5.4 | 30m | C0AH3VCRWCR |
| intel | 情报虾 🔍 | **kimi-k2.5** | off | C0AJU7H2KQR |
| code | 编程虾 💻 | Codex gpt-5.4 | off | C0AKS11FCT0 |

VPS default cascade: Codex gpt-5.4 → MiniMax M2.5 (API key) → openrouter/Claude
VPS Gateway: `http://207.246.110.130:18789` (bind: lan, auth: token)
VPS token: `a154e905452c2a00119b01f3d6c0f2e3f17532fa1533ba9e`
VPS systemd: `systemctl --user restart openclaw-gateway.service`
VPS logs: `/tmp/openclaw/openclaw-YYYY-MM-DD.log` (NOT ~/.openclaw/logs/)

## VPS ↔ Local Interconnect
- autossh LaunchAgent: `~/Library/LaunchAgents/com.lobster-empire.vps-tunnel.plist`
  - 开机自启，断线自动重连
  - 本地 18790 → VPS 18789（SSH tunnel via `ssh vps`）
- gateway.remote 配置写入本地 openclaw.json:
  ```json
  "remote": { "url": "ws://127.0.0.1:18790", "token": "a154e905..." }
  ```
- shell alias in ~/.zshrc: `vps-claw <cmd>` = openclaw + --url + --token

### 常用 vps-claw 命令（支持 --url 的命令）
```bash
vps-claw cron list              # 查看 VPS 定时任务
vps-claw cron create ...        # 创建 VPS 定时任务
vps-claw gateway status         # VPS gateway 健康状态
vps-claw logs --limit 50        # 读 VPS 实时日志
ssh vps                         # 深度操作（改配置、查文件）
```
注意：`openclaw agent` 和 `openclaw sessions` 不支持 --url，只能通过 Slack 或 SSH 操作 VPS agents。

## MiniMax Config
- API Key: sk-cp-3diDsK... (coding plan, shared between local + VPS)
- Local uses minimax-portal (OAuth) as worker primary
- VPS uses minimax (API key) in fallback chain
- apiKey refreshed 2026-03-11 (old key invalidated)

## Memory Scopes (Local)
- global: shared by kuro, brain, architect
- agent:kuro, agent:brain, agent:architect: private + global
- agent:worker: worker-only (isolated from global)

## Memory Scopes (VPS)
- cloud-global: shared by auto, intel, code
- agent:auto, agent:intel, agent:code: private + cloud-global
- agent:health: health-only (isolated, same pattern as local worker)

## Inter-agent Communication
- Mailbox: `workspace/mailbox/<agent>/` (async file-based)
- Task inbox: `workspace/worker/inbox/task-*.yaml` (local) / `workspace/auto/inbox/` (VPS)
- sessions_send: urgent real-time messaging
- Slack conventions: see shared/CONVENTIONS.md

## VPS Health Data
- 养生虾 inherits full health records from old personal workspace
- MEMORY.md contains: 体检报告, 门诊病历, 用药方案, 血糖段位, 复查结果
- Privacy: health data stays in agent:health scope ONLY

## Scheduled Tasks (VPS 自动虾)
- AI 资讯早餐: 每天 08:00 CST（cron `0 0 * * *` UTC），递送到 C0ALJRU4BQ8
- 马尼拉天气 x9: 每天 09:00 CST，3/12–3/20，递送到 C0ALJRU4BQ8（本地对应 cron 已禁用）

## Local Cron Jobs
- worker-inbox-poll: 每 15m
- brain-daily-scan: 每天 09:00 CST（配置已修复 2026-03-11，待明日验证）
  - 修复内容：移除 GitHub check，改为读 vps-status.md，timeout 120s→180s
- architect-daily-inspection: 每天 10:00 CST

## Mobile Capture System（出差模式，2026-03-11）

**场景**: Leon 外出时 Mac 关闭，需要通过手机 Slack 记录观察。

**流程**:
1. Leon 在手机 Slack 发 `/log <内容>` 到 **VPS 自动虾频道（C0ALJRU4BQ8）**
2. 自动虾接收，追加到 `/root/.openclaw/workspace/auto/mobile-captures/YYYYMMDD.md`
   格式：`HH:MM — <原文>`（北京时间 UTC+8）
3. 回复：`✅ 已记录（今日第 N 条）`
4. Leon 回来后对 kuro 说"回来了"
5. kuro 自动：SSH 读文件 → `journal_session.py --json log "[出差捕获 HH:MM] <内容>"` → 归档到 `processed/`

**关键文件**:
- VPS HEARTBEAT.md: `/root/.openclaw/workspace/auto/HEARTBEAT.md`（含捕获协议）
- 捕获目录: `/root/.openclaw/workspace/auto/mobile-captures/`
- kuro SOUL.md: `~/.openclaw/workspace/kuro/SOUL.md`（含"出差归来"处理步骤）

**端到端测试**: 2026-03-11 通过 ✅（Slack → VPS 文件写入 → kuro 处理 → staging 写入 → 归档）

## SSH Config
- `ssh vps` = root@207.246.110.130（密钥认证，~/.ssh/config 已配置）

## Pending Roadmap
- [ ] 管理虾深度设计 (brain project/team info access)
- [ ] Gemini Skill knowledge migration (Leon manual review)
- [ ] 飞书→钉钉迁移 (2026-04)
- [ ] Phase 3: universal tool orchestration (CLI → Browser → Desktop)
- [ ] brain-daily-scan error 排查
