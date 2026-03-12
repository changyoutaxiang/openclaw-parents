# openclaw-parents

龙虾母亲（Claude Code）的记忆与龙虾帝国（OpenClaw）的配置双向同步仓库。

本地 Mac 和 VPS 两端都连接此仓库，实现"龙虾母亲永远在线"。

## 目录结构

```
├── shared/
│   └── claude/
│       └── CLAUDE.md              # 全局身份定义（两端共用）
├── local/                         # 本地 Mac 端
│   ├── sync.sh
│   ├── claude/memory/             # 龙虾母亲记忆文件
│   └── openclaw/
│       ├── openclaw.template.json # 脱敏配置模板
│       └── workspace/             # 四虾 workspace（kuro/architect/brain/worker）
└── vps/                           # VPS 云端
    ├── setup.sh                   # 首次部署脚本
    ├── sync.sh
    ├── claude/memory/             # VPS 端记忆文件
    └── openclaw/
        ├── openclaw.template.json
        └── workspace/             # VPS 四虾（auto/health/intel/code）
```

## 双向同步机制

```
本地 Mac ──push──▶ GitHub ──pull──▶ VPS
本地 Mac ◀──pull── GitHub ◀──push── VPS
```

每次 sync.sh 运行时，先 `git pull --rebase` 获取对方的变更，再提交自己的变更。

## 本地 Mac 使用

```bash
# 手动同步
cd ~/Projects/openclaw-parents && ./local/sync.sh

# 带自定义消息
./local/sync.sh "feat: 更新架构文档"
```

## VPS 首次部署

```bash
# SSH 进入 VPS 后执行
curl -fsSL https://raw.githubusercontent.com/changyoutaxiang/openclaw-parents/main/vps/setup.sh | bash
```

部署后日常使用：
```bash
lobster-sync          # 手动同步
```

自动同步：每天 23:00 CST 通过 cron 自动运行（由 setup.sh 配置）。

## 注意

- `openclaw.json`（含 API keys）**不在**此仓库中
- 使用 `openclaw.template.json` 查看配置结构参考
