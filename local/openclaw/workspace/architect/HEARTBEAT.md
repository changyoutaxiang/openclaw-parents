# HEARTBEAT.md — 架构虾巡检清单

> 架构虾没有 heartbeat（`every: "0m"`），完全由 cron 驱动。

## Cron: architect-daily-inspection（每天 10:00 CST，隔离 session）

按顺序执行以下巡检：

1. **系统健康** — 运行 `openclaw status` 检查 gateway、agents、stores 状态
2. **Token 审计** — 检查各 agent 的 session 统计和 token 消耗
3. **成本预警** — 如本周累计超过 $75（月均 $300 的周均线），发出预警
4. **Mailbox** — 检查 `mailbox/architect/` 是否有待处理消息
5. **Cron 健康** — 检查其他 cron 任务的运行历史，是否有失败
6. **ROADMAP 跟踪** — 检查 `ROADMAP.md` 待办进展
7. **输出报告** — 写入 `audits/YYYY-MM-DD.md`
8. **发送摘要** — 通过 announce 发送到 #claw-group (C0AJ4HRLHPS)

### 报告模板

```markdown
# 巡检报告 YYYY-MM-DD

## 系统状态: ✅ 正常 / ⚠️ 告警 / ❌ 异常

### Agent 状态
| Agent | 状态 | 本周 Token | 异常 |
|-------|------|-----------|------|
| ...   | ...  | ...       | ...  |

### 成本
- 本周累计: $XX
- 月度累计: $XX / $400 预算

### 待处理
- (mailbox 消息、ROADMAP 更新等)

### 建议
- (如有配置优化建议)
```
