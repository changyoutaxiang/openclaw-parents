# GEMINI_BRIDGE.md — Gemini Skill 系统集成指南

> Leon 的个人第二大脑系统。效率虾可调用其 workflow 和读取其数据。

## 项目根目录

`/Users/wangdong/Desktop/Gemini skill`

## 可调用的 Workflow

所有命令从项目根目录执行。`--json` 放在子命令**之前**获得机器可读输出。

### 高频（日常使用）

| 命令 | 风险 | 用法 |
|------|------|------|
| `/log` | 🟢 | `python3 99_System/workflows/journal_session.py log "内容"` |
| `/log --heavy` | 🟡 | 同上加 `--heavy`，会自动关联项目和知识 |
| `/meeting` | 🟡 | `python3 99_System/workflows/note_session.py --type meeting "文本"` |

### 中频（每日/每周）

| 命令 | 风险 | 用法 | 人工审核 |
|------|------|------|----------|
| `/journey start` | 🟡 | `python3 99_System/workflows/journal_session.py start` | ✅ 需要 |
| `/journey reflect` | 🟡 | `python3 99_System/workflows/journal_session.py reflect` | ✅ 需要 |
| `/journey finalize` | 🟡 | `python3 99_System/workflows/journal_session.py finalize` | ✅ 需要 |
| `/weekly-review` | 🔴 | `python3 99_System/workflows/weekly_smelt.py` | ✅ 必须 |

### 低频（按需）

| 命令 | 风险 | 用法 |
|------|------|------|
| `/essay` | 🟡 | `python3 99_System/workflows/catalyze_and_essay.py "主题"` |
| `/project` | 🟡 | (项目状态记录，通过 chief_of_staff 路由) |
| `/doctor` | 🟢 | `python3 99_System/workflows/doctor_session.py` |

## 数据目录（只读参考）

| 路径 | 内容 | 用途 |
|------|------|------|
| `20_Stream/Staging/` | 当日原始日志 | 查看 Leon 今天记了什么 |
| `20_Stream/YYYY/MM/DD/` | 整理后的日记 + 反思 + 摘要 | 回顾历史 |
| `30_Projects/` | 活跃项目状态 | 了解 Leon 在忙什么项目 |
| `40_Knowledge/nodes/` | 结构化知识节点 | 查询积累的知识和决策 |
| `40_Knowledge/_staging/candidates.jsonl` | 待晋升候选 | 知识积压状态 |

## 注意事项

- 🟢 低风险命令可直接执行
- 🟡 中风险命令执行后向 Leon 报告结果
- 🔴 高风险命令（/weekly-review）必须先得到 Leon 确认
- 所有写操作都发生在 Gemini Skill 目录内，不会影响龙虾 workspace
- Gemini Skill 有自己的 LLM 路由（走 DeepSeek/Moonshot/Zhipu），不消耗龙虾的 token 预算
