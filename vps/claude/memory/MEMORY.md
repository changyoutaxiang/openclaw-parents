# Agent 军团系统 - 项目记忆

## 项目概况
- **目标**：为管理者构建多 AI 员工团队，双引擎架构（OpenClaw + Claude Code Agent Teams）
- **用户身份**：管理者，非专业开发者，用中文沟通
- **设计文档**：`/root/system-design/agent-army-architecture-onepage.md`（v0.2）
- **桥接 Plugin 代码**：`/root/system-design/bridge-plugin/`

## 关键架构决策
1. **双引擎**：OpenClaw（始终在线前台）+ Agent Teams（按需工程车间）
2. **桥接方式**：OpenClaw Plugin，三阶段演进（CLI → PTY监控 → tmux团队编排）
3. **记忆体系**：三层（会话上下文 → CLAUDE.md → Supermemory/自建向量库）
4. **员工分布**：3个OpenClaw常驻Agent（PM/Ops/秘书）+ 3个Agent Teams Teammate（Dev/Review/Knowledge）

## 技术要点
- Agent Teams 是实验功能（2026-02-05 发布），需 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Agent Teams 需交互式终端，多Teammate场景无法纯headless，Phase 3 用 tmux 驱动
- `claude -p` 支持 headless 单Agent执行，配合 `--output-format json` 可获取结构化输出
- OpenClaw Plugin SDK：`registerTool()`, `registerService()`, `registerCli()` 是核心API
- 桥接回调用 `openclaw system event --text "BRIDGE_DONE:..." --mode now`

## 待解决
- Phase 2/3 尚未实现（PTY监控、tmux团队编排）
- Supermemory 集成待落地
- 各员工 CLAUDE.md 岗位手册待编写
- OpenClaw 实际 Plugin 目录适配（需确认用户环境路径）

详细桥接设计见 → [bridge-design.md](bridge-design.md)
