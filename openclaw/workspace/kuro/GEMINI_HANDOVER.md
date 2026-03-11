# GEMINI_HANDOVER.md — 第二大脑平滑交接指南

> 写给 Leon 的过渡期操作手册。
> 你用 Gemini Skill 积累了几个月，这份文档确保什么都不丢、节奏不断。

---

## 一句话结论

**Gemini Skill 不是被"关掉"，而是被"吸收"。**
数据资产永久保留，高价值 workflow 继续运行，只有冗余的管道层退役。
龙虾不是替代品，是升级版的载体。

---

## 每日操作对照表

你今天怎么用 → 以后怎么用

| 操作 | Gemini Skill 时代 | 龙虾时代 | 变化 |
|------|------------------|---------|------|
| 快速记笔记 | 在 Slack 发 `/log 内容` | **完全一样** | 无，kuro 调同一个脚本 |
| 早晨开始一天 | `/journey start` | **完全一样** | kuro 调 journal_session.py |
| 晚上收尾 | `/journey reflect` + `/journey finalize` | **完全一样** | kuro 调同上 |
| 周回顾 | `/weekly-review`（需人工确认） | **完全一样** | kuro 调 weekly_smelt.py，人工门不变 |
| 写长文/分析 | `/essay 主题` | **kuro 直接写** | kuro 原生能力，不需要脚本 |
| 查项目状态 | 看 `30_Projects/STATE.md` | **kuro 帮你读** | 说"最近项目怎么样" |
| 查知识库 | 用 Gemini Skill 的检索 | **memory-lancedb-pro**（迁移后）| 迁移前还是查文件 |
| 多模型投票 | `/council 问题` | **暂停** | Council Engine 已 PARK，Phase 3 后再议 |
| 研究任务 | Web Searcher skill | **kuro 原生搜索** | 性能更好，直接说"帮我查X" |

---

## 什么继续跑，什么退役

### ✅ 继续运行（不动）

这些 Gemini Skill 的 workflow 继续原地运行，kuro 作为调用者：

```
journal_session.py  ← /log、/journey 的核心引擎，保持原样
weekly_smelt.py     ← 周回顾，保持原样（需人工确认）
note_session.py     ← 会议记录，保持原样
```

**这些脚本有自己的 LLM 调用（DeepSeek/Moonshot），不消耗龙虾 token。**

### 🗄️ 数据目录：永久保留，只读

```
/Users/wangdong/Desktop/Gemini skill/
├── 20_Stream/          ← 你的时间线，不会动
│   ├── Staging/        ← /log 写入这里
│   └── YYYY/MM/DD/     ← 已整理的日记/反思
├── 30_Projects/        ← 项目状态，继续在这里
└── 40_Knowledge/
    ├── nodes/          ← 结构化知识（待迁移到龙虾记忆）
    └── _staging/       ← 知识候选队列
```

kuro 可以读这里的任何文件，回答你"上周写了什么"、"这个项目进展如何"。

### ❌ 静默退役（你不需要再用的）

| 组件 | 替代者 |
|------|--------|
| `llm_client` / `model_loader` | OpenClaw 原生多模型路由 |
| `chief_of_staff.py`（意图分发） | OpenClaw agent 路由 + 效率虾 |
| Web Searcher skill | kuro 原生 web search |
| Run Report 系统 | OpenClaw session 日志 |
| Obsidian 集成 | 已用 Slack，不再需要 |
| 飞书 Client（1,728 LOC） | 等钉钉插件，届时彻底退役 |

这些你可以忘掉了，不需要主动关闭，它们只是不再被调用。

### ⏸️ 暂停（等待时机）

| 组件 | 状态 | 何时重启 |
|------|------|---------|
| Council Engine（多模型投票） | PARK | Phase 3 通用工具编排完成后 |
| Librarian 归档 skill | PARK | knowledge 迁移完成后评估是否还需要 |
| Retriever (Chroma 向量检索) | 退役 | memory-lancedb-pro 完全替代 |

---

## 最大的一次性工作：知识迁移

这是整个交接中唯一需要你花时间的事情。

**背景**：`40_Knowledge/nodes/` 里有 500+ 个知识节点，经过 Gate-4 人工审核，是你的思维精华。但它们现在只是本地文件，四只虾看不见。

**目标**：把这些知识写入 memory-lancedb-pro 的 global scope，让所有虾都能检索和引用。

**为什么需要你亲自审查**：
- 部分节点可能含有私密信息（不该进 global 范围）
- 部分节点可能已经过时或被更新的认知推翻
- 你需要决定哪些进 global（四虾可见）、哪些只进 agent:kuro（只有效率虾可见）

**流程（待安排时间执行）**：
```
1. 我生成审查工具 — 逐条展示知识节点，你判断：
   [A] 进 global  [B] 进 kuro private  [C] 跳过/不迁移
2. 审查完成后，一键批量写入 memory-lancedb-pro
3. 验证检索效果
```

这不急，但做完之后，第二大脑就真正"活"在龙虾里了。

---

## Crucible Protocol 精华

从 Gemini Skill 里提取的思维框架，已嵌入效率虾的工作方式：

```
A (你的输入) + B (历史上下文/记忆) + C (你的目标)
→ 推理
→ 行动
→ 新的 B（写进记忆）
```

每次效率虾回答重要问题，都会隐式地激活 B（查记忆）和 C（对齐目标）。这个循环就是"第二大脑"真正工作的样子。

---

## 过渡期检查清单

- [x] 数据目录只读挂载（kuro SOUL.md 已配置）
- [x] /log 可正常调用（已测试）
- [x] /journey 命令映射就位（GEMINI_BRIDGE.md）
- [ ] 知识迁移（等 Leon 安排审查时间）
- [ ] Deep Essayist + Critic → 改造为 kuro workflow prompt
- [ ] 飞书 Client 退役（等钉钉迁移）

---

*参考文件：*
- *`GEMINI_BRIDGE.md` — 效率虾日常调用速查表*
- *`~/.openclaw/workspace/architect/ROADMAP.md` — 整合进度追踪*
