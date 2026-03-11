#!/usr/bin/env bash
# openclaw-parents sync script
# 同步龙虾母亲的记忆、配置到 git 仓库
# 用法: ./sync.sh [commit message]

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_MSG="${1:-"sync: $(date '+%Y-%m-%d %H:%M')"}"

echo "=== 龙虾母亲同步开始 ==="

# 1. Claude 全局身份 & 记忆
echo "→ 同步 Claude 记忆文件..."
cp ~/.claude/CLAUDE.md "$REPO_DIR/claude/CLAUDE.md"
cp ~/.claude/projects/-Users-wangdong/memory/MEMORY.md "$REPO_DIR/claude/memory/MEMORY.md"
cp ~/.claude/projects/-Users-wangdong/memory/lobster-empire.md "$REPO_DIR/claude/memory/lobster-empire.md"
cp ~/.claude/projects/-Users-wangdong/memory/troubleshooting.md "$REPO_DIR/claude/memory/troubleshooting.md"

# 2. OpenClaw workspace 的 md 文件（根目录）
echo "→ 同步 workspace 根目录..."
for f in AGENTS.md HEARTBEAT.md IDENTITY.md MEMORY.md SOUL.md TOOLS.md USER.md OPENCLAW_SETUP.md; do
  src="$HOME/.openclaw/workspace/$f"
  [ -f "$src" ] && cp "$src" "$REPO_DIR/openclaw/workspace/$f"
done

# 3. 各 agent workspace 的 md 文件
for agent in kuro architect brain worker; do
  echo "→ 同步 $agent..."
  src_dir="$HOME/.openclaw/workspace/$agent"
  dst_dir="$REPO_DIR/openclaw/workspace/$agent"
  find "$src_dir" -maxdepth 1 -name "*.md" | while read f; do
    cp "$f" "$dst_dir/$(basename "$f")"
  done
done

# 4. shared workspace
echo "→ 同步 shared..."
find "$HOME/.openclaw/workspace/shared" -maxdepth 1 -name "*.md" | while read f; do
  cp "$f" "$REPO_DIR/openclaw/workspace/shared/$(basename "$f")"
done

# 5. openclaw.json 脱敏模板
echo "→ 生成脱敏配置模板..."
python3 - <<'PYEOF'
import json, re, sys

SENSITIVE_KEYS = {'apiKey', 'authHeader', 'botToken', 'appToken', 'userTokenReadOnly', 'auth', 'token'}

def sanitize(obj):
    if isinstance(obj, dict):
        return {
            k: "***REDACTED***" if k in SENSITIVE_KEYS else sanitize(v)
            for k, v in obj.items()
        }
    elif isinstance(obj, list):
        return [sanitize(i) for i in obj]
    return obj

with open('/Users/wangdong/.openclaw/openclaw.json') as f:
    data = json.load(f)

sanitized = sanitize(data)

with open('/Users/wangdong/Projects/openclaw-parents/openclaw/openclaw.template.json', 'w') as f:
    json.dump(sanitized, f, indent=2, ensure_ascii=False)

print("   配置模板生成完毕")
PYEOF

# 6. git commit & push
echo "→ Git 提交..."
cd "$REPO_DIR"
git add -A
if git diff --cached --quiet; then
  echo "✓ 无变更，跳过提交"
else
  git commit -m "$COMMIT_MSG"
  git push origin main
  echo "✓ 已推送到 GitHub"
fi

echo "=== 同步完成 ==="
