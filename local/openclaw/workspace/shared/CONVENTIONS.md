# CONVENTIONS.md — 团队约定

> 所有虾遵守。

## 跨虾通信协议

### 非紧急：文件信箱
- 路径: `/Users/wangdong/.openclaw/workspace/mailbox/<目标agent>/`
- 命名: `from-<发送者>-<主题>.md`
- 每个虾在 heartbeat 时检查自己的信箱
- 处理完毕后删除信件

### 紧急：sessions_send
- 用于阻塞通知、安全告警、需要立即关注的事项
- 通过 `sessions_send` 工具直接发送

### 任务提交（给外包虾）
- 路径: `/Users/wangdong/.openclaw/workspace/worker/inbox/`
- 格式: YAML（见外包虾 AGENTS.md）

## 升级链

```
外包虾 遇到阻塞    →  通知提交者（效率虾/管理虾）
效率虾 遇到管理问题 →  升级给管理虾
管理虾 发现系统问题 →  升级给架构虾
架构虾 需要重大变更 →  升级给 Leon
任何虾 遇到安全问题 →  直接通知 Leon
```

## 定时任务 (Cron)

| 名称 | Agent | 频率 | 说明 |
|------|-------|------|------|
| architect-daily-inspection | 架构虾 | 每天 10:00 CST | 系统巡检 + 成本审计 |
| worker-inbox-poll | 外包虾 | 每 15 分钟 | inbox 任务扫描 |
| brain-daily-scan | 管理虾 | 每天 09:00 CST | GitHub 状态 + 仪表盘更新 |

管理命令: `openclaw cron list` / `openclaw cron runs <id>`

## 文件命名

- 日期格式: `YYYY-MM-DD`
- 任务 ID: `task-YYYYMMDD-NNN`
- ADR: `NNN-kebab-case-title.md`
