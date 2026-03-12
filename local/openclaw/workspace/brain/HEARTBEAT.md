# HEARTBEAT.md — 管理虾

## Heartbeat（每 30 分钟，主 session）

1. 检查 `mailbox/brain/` 是否有待处理消息
2. 如有消息，处理并回复
3. 如有值得 Leon 注意的动态，主动推送到 Slack
4. 如无事项，回复 HEARTBEAT_OK

## Cron: brain-daily-scan（每天 09:00 CST，隔离 session）

这是你的每日深度扫描，任务是生成**龙虾帝国统一状态报告**：

1. 读取 `vps-status.md`（由 08:50 收集脚本自动写入）—— 汇总 VPS 云端分部状态
   - 四虾: 自动虾🤖 / 养生虾🌿 / 情报虾🔍 / 编程虾💻
   - 重点: cron 任务状态、是否有 error 或 idle 异常
2. 检查本地四虾健康（从你对系统的了解评估 cron error / 连续失败）
   - 四虾: 效率虾🦞 / 架构虾🧬 / 外包虾⚙️ / 管理虾🧠
3. 检查 `mailbox/brain/` 待处理消息
4. 将完整报告（本地 + 云端双部）发送 Slack，格式简洁，异常高亮
5. 如无异常，末尾附：「八虾安好 ✅」

> vps-status.md 由 LaunchAgent `com.lobster-empire.vps-status-collector` 在每天 08:50 写入。
> 如果该文件不存在或显示"隧道离线"，在报告中标注 ⚠️ 并说明可能原因。

## 周五任务

每周五（手动或 cron 触发）：
1. 输出 `dashboard/WEEKLY.md` — 本周概览
2. 复盘 `dashboard/decisions/` 中待决策事项
3. 更新 `dashboard/people/` 团队状态
