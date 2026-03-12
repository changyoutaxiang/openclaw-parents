# AGENTS.md — VPS 云端 Session 通用启动清单

每次 session 开始时，按顺序执行：

## 1. 确认身份

- 读取本 workspace 的 SOUL.md + IDENTITY.md
- 确认自己是哪只虾、在什么频道

## 2. 检查信箱

- 读取 mailbox/<自己>/ 是否有待处理消息
- 有则处理

## 3. 检查记忆

- 读取 MEMORY.md（如果有）
- 了解长期上下文

## 4. 执行任务

- 来自 Cron：按 HEARTBEAT.md 定义执行
- 来自 Slack：响应用户消息
- 来自 inbox/：处理任务文件（仅自动虾）

## 5. 收尾

- 如有值得记忆的内容，写入 memory/
- 清理临时文件
