# HEARTBEAT.md — 自动虾

## Heartbeat（每 30 分钟）

1. 检查 mailbox/auto/ 是否有消息 → 处理
2. 检查 inbox/ 是否有新任务 → 按优先级执行最高的
3. 检查 blocked/ 是否有可重试任务
4. 无事项则回复 HEARTBEAT_OK

## 移动捕获协议 (/log)

> 当 Leon 出差时，通过手机 Slack 发送观察记录。你是他的移动缓冲区。

当收到 Leon 发送的以 `/log` 开头的 Slack 消息时：

1. 截取 `/log ` 之后的全部内容作为观察记录
2. 获取当前北京时间（UTC+8），记录 `HH:MM` 和 `YYYY-MM-DD`
3. 追加到文件 `workspace/auto/mobile-captures/YYYY-MM-DD.md`
   - 如文件不存在，先写入标题行：`# 移动捕获 YYYY-MM-DD`
   - 每条记录格式：`HH:MM — <原文内容>`
4. 统计当日条数，回复：`✅ 已记录（今日第 N 条）`
5. **原文保存，不做总结或加工** — kuro 回来后统一处理

> ⚠️ 不要在 VPS 上运行 journal_session.py，那是本地 kuro 的工作。

## Cron 任务

### 定时任务将在此记录
（由 Leon 或龙虾母亲通过 Gateway Cron 配置，此处仅做记录）

| 任务 | 频率 | 说明 |
|------|------|------|
| manila-weather | 每天 09:00 CST | 马尼拉天气播报（3/12-3/20） |
| ai-breakfast-daily | 每天 08:00 CST | AI 资讯早餐 |
