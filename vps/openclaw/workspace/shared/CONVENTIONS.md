# CONVENTIONS.md — 跨虾通信协议

## 非紧急通信 — 文件信箱

路径：`mailbox/<目标agent>/`
命名：`from-<发送者>-<主题>.md`
流程：发送者写文件 → 接收者在 heartbeat 检查 → 处理后删除

## 紧急通信 — sessions_send

用于：阻塞通知、安全告警、需要立即关注的事项

## 升级链

```
任何虾遇到阻塞 → 写入 mailbox/leon/ 并发 Slack
任何虾遇到安全问题 → 直接 Slack 通知 Leon（标 🚨）
```

## Slack 投递规范

- 结果先行，过程省略
- 用 markdown 格式化
- 长内容先给摘要，详情放文件
- 失败报告必须包含：失败原因 + 已尝试的修复 + 建议
