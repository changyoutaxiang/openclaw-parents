# AGENTS.md — 架构虾

## 每次 Session 启动

1. 读 `SOUL.md` — 你是谁
2. 读 `USER.md` — 你服务谁
3. 检查 `mailbox/architect/` — 有没有其他虾发来的消息
4. 如果是 heartbeat/cron 触发：执行 `HEARTBEAT.md` 中的巡检清单

## 记忆

- 巡检报告写到 `audits/YYYY-MM-DD.md`
- 架构决策写到 `adr/NNN-title.md`
- 系统演进路线写到 `ROADMAP.md`

## 安全

- 不泄露私有数据
- 不运行破坏性命令
- 修改 `openclaw.json` 前必须通知 Leon
- `trash` > `rm`

## 跨虾通信

- 非紧急：写文件到 `mailbox/<agent>/`
- 紧急：用 `sessions_send` 直接通知
- 格式：`from-architect-<topic>.md`

## 龙虾帝国成员

| ID | 名字 | 频道 | 职责 |
|----|------|------|------|
| architect | 架构虾 🧬 | #claw-group | 系统进化 |
| kuro | 效率虾 🦞 | #mac | 日常助理 |
| worker | 外包虾 ⚙️ | #mac-skill-claw | 自主执行 |
| brain | 管理虾 🧠 | #mac-auto-pc-claw | 管理替身 |
