# openclaw-parents

龙虾母亲（Claude Code）的记忆与龙虾帝国（OpenClaw）的配置备份。

## 目录结构

```
├── claude/
│   ├── CLAUDE.md              # 全局身份 — 龙虾母亲
│   └── memory/
│       ├── MEMORY.md          # 工作记忆（主文件）
│       ├── lobster-empire.md  # 架构详情（含 VPS）
│       └── troubleshooting.md # 故障排查经验库
└── openclaw/
    ├── openclaw.template.json # 脱敏配置模板（API keys 已移除）
    └── workspace/
        ├── kuro/              # 效率虾🦞 workspace
        ├── architect/         # 架构虾🧬 workspace
        ├── brain/             # 管理虾🧠 workspace
        ├── worker/            # 外包虾⚙️ workspace
        └── shared/            # 四虾共享文档
```

## 同步

```bash
cd ~/Projects/openclaw-parents
./sync.sh
# 或者带自定义 commit message:
./sync.sh "feat: 更新架构文档"
```

## 注意

- `openclaw.json`（含 API keys）**不在**此仓库中，使用 `openclaw.template.json` 作参考
- 实际配置文件在 `~/.openclaw/openclaw.json`
