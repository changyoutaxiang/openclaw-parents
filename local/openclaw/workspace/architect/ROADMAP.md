# ROADMAP.md — 龙虾帝国演进路线

## 当前版本: v2.2 (2026-03-11)

四虾架构上线 + Phase 2 运行机制就位 + VPS 云端分部完整部署。

### 已完成
- [x] Phase 1: 四虾架构、workspace、SOUL.md、频道映射 (2026-03-10)
- [x] Phase 2: Mailbox 信箱、Worker inbox、Brain 仪表盘、Cron 任务 (2026-03-10)
- [x] ADR-001: memory-lancedb-pro 选型决策 (2026-03-10, by 架构虾)
- [x] memory-lancedb-pro 试点部署: kuro + brain 第一批 (2026-03-10)
- [x] 记忆增强方案评测 → ADR-001 已输出，memory-lancedb-pro 已部署
- [x] Lobster 工作流引擎: 已安装 CLI + 启用插件，外包虾专属 (2026-03-11)
- [x] **VPS 云端分部完整重建** (2026-03-11)
  - 四虾: 自动虾🤖 / 养生虾🌿 / 情报虾🔍 / 编程虾💻
  - 完整 workspace + SOUL.md + IDENTITY.md + HEARTBEAT.md 等
  - memory-lancedb-pro 独立部署（云端独立数据库，Option C）
  - 情报虾特殊: Kimi K2.5 primary，claude + codex fallback
  - 养生虾继承旧 workspace-personal 完整健康档案
- [x] **定时任务迁移至 VPS** (2026-03-11)
  - 马尼拉天气 x9（3/12-3/20，09:00 CST，已从本地禁用）
  - AI 资讯早餐每日循环（08:00 CST，含周末节假日）
- [x] Worker 切换至 MiniMax M2.5 primary (2026-03-11，修复 Codex 超时问题)
- [x] MiniMax API Key 刷新 (2026-03-11，本地+VPS 同步更新)

## 近期待办

- [ ] **管理虾深度设计** — 赋予 brain 项目与团队信息的"钥匙"
  - 讨论: Leon 会提供项目信息源、团队信息源的访问权限
  - 需设计: 数据接入方式、信息更新频率、权限粒度、决策边界
  - 核心问题: brain 能看什么、能做什么、不能碰什么
  - 状态: 待细致讨论（2026-03-12）
- [x] **VPS ↔ 本地 Gateway 互通** (2026-03-11) ✅
  - autossh LaunchAgent: 本地 18790 → VPS 18789（开机自启，断线自动重连）
  - gateway.remote 配置: openclaw CLI 可直接操作 VPS gateway
  - shell alias: `vps-claw <cmd>` = `openclaw <cmd> --url ws://127.0.0.1:18790 --token <vps_token>`
  - 已验证: cron list / logs / gateway status 均可透过隧道操作 VPS
- [ ] **Gemini Skill 最终整合** — 第二大脑接入龙虾帝国
  - 终判已定（2026-03-11）:
    - DROP: Retriever/Chroma（memory-lancedb-pro 替代）、Librarian、编排层、基础设施层
    - KEEP: 数据资产（20_Stream、30_Projects、40_Knowledge）、Promotion Gate 逻辑、Crucible Protocol
    - PARK: Council Engine（Phase 3 后再议）、飞书 Client（等钉钉）
    - ADAPT: Deep Essayist+Critic → 改造为 kuro workflow prompt
  - **核心工作：知识图谱迁移（Leon 人工审查门控）**
    - 目标: 将 `40_Knowledge/nodes/` 中已晋升的知识节点迁移进 memory-lancedb-pro global scope
    - ⚠️ 必须由 Leon 亲自审查所有内容后才入库（隐私 + 质量控制）
    - 流程: Leon 逐节点审查 → 确认 → 工具辅助批量写入 global memory
    - 这是一次性的"历史迁移"，不是自动同步
  - **日常捕获**: /log 继续由效率虾执行（kuro + journal_session.py），不变
  - 状态: 待 Leon 安排审查时间
- [ ] Agent Reach 试点：kuro + worker 外部信息获取能力增强（只开读，不开写）
- [ ] 飞书→钉钉迁移准备（2026-04）
- [ ] 首次成本审计报告（等待明天 10:00 CST 架构虾首次巡检自动生成）

## 本地 ↔ VPS 互通后解锁的高级玩法

> 互通完成于 2026-03-11。以下是因为打通才拥有的新能力，按层级排列。

### Layer 1 — 运维层（已解锁，随时可用）
- 龙虾母亲（Claude Code）在一个对话里同时管两套龙虾，无需 SSH 上下文切换
- `vps-claw cron list/create/logs` 与 `openclaw cron list` 并排操作
- VPS 故障诊断：直接 `vps-claw logs` 读日志，不需要 ssh vps tail

### Layer 2 — 协作层（设计中，可逐步实现）
- [ ] **跨节点任务路由** — kuro 判断"Leon 不在场时执行"的任务，写入 VPS 自动虾 inbox
  - 触发条件: 任务耗时长 / 不需要 Leon 实时确认 / 需要 24h 保障
  - 实现: kuro 通过 mailbox 或 vps-claw cron create 投递
- [x] **统一仪表盘** (2026-03-11) ✅
  - vps-status-collector LaunchAgent 每天 08:50 收集 VPS 状态写入 brain/vps-status.md
  - brain-daily-scan 修复（去 GitHub、加 VPS 读取、超时 120s→180s）
  - brain/HEARTBEAT.md 更新为"八虾统一报告"
- [x] **互补分工协议** (2026-03-11) ✅
  - 文档: `workspace/shared/DIVISION_OF_LABOR.md`
  - 本地: 高信任 / Leon 在场 / 本地文件/工具
  - VPS: 常驻定时 / 无人值守 / 公网出口 / 批量处理
  - 包含任务路由决策树 + 跨节点投递方式

### Layer 3 — 进化层（需要深度设计）
- [ ] **夜间批处理流水线** — 白天在本地设计任务，夜间在 VPS 批量执行，早晨看结果
- [ ] **冗余故障切换** — 本地 agent 不可用时，临时把任务路由到 VPS 同职责 agent
- [ ] **成本感知路由** — 按模型成本决策执行位置（MiniMax 便宜→VPS，Codex 贵→本地）
- [ ] **双向记忆同步探索** — 评估 global memory 是否需要在本地/VPS 间同步（当前独立）

## 中期规划

- [ ] **Phase 3: 通用工具编排** — 让 kuro/worker 能操控宿主机上的一切工具
  - 目标：从"文件读写 + API 调用"升级到"全桌面自动化"
  - 能力层:
    - Layer 1: CLI 工具编排 — 调用 Claude Code CLI、Codex CLI（agent-spawning-agent）
    - Layer 2: Browser 自动化 — 通过 Chrome DevTools / Playwright MCP 操控 Web AI 工具
    - Layer 3: Desktop 自动化 — macOS AppleScript / Accessibility API 控制任意 App
  - 需评估: 权限边界、递归防护、成本控制、安全隔离
  - 状态: 待讨论细节方案（2026-03-12 继续）
- [ ] OpenTelemetry 可观测性集成（diagnostics-otel）
- [ ] Agent Teams RFC 跟踪（openclaw/openclaw#10036）
- [ ] self-improving-agent skill 全面启用
