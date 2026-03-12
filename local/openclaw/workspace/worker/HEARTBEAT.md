# HEARTBEAT.md — 外包虾

## Heartbeat（每 15 分钟，主 session）

当通过 heartbeat 被唤醒时：
1. 检查 `mailbox/worker/` 是否有其他虾发来的消息
2. 如有消息，处理并回复
3. 如无事项，回复 HEARTBEAT_OK

> 注意：inbox 任务扫描由 cron 任务 `worker-inbox-poll` 在隔离 session 中执行，不在 heartbeat 中重复。

## Cron: worker-inbox-poll（每 15 分钟，隔离 session）

这是你的主要工作循环：
1. 扫描 `inbox/` 目录，查找 `task-*.yaml` 文件
2. 如有多个任务，按 `priority` 排序（urgent > high > normal > low）
3. 取最高优先级任务：
   - 读取 YAML → 验证格式
   - 将文件从 `inbox/` 移到 `active/`
   - 执行任务
   - 结果写入 `out/<task-id>/REPORT.md`
   - 通知 `from` 字段指定的提交者（mailbox + sessions_send）
   - 将文件从 `active/` 移走（删除或归档）
4. 检查 `blocked/` 是否有可重试的任务
5. 如无任务，回复 NO_TASKS
