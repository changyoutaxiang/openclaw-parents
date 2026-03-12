#!/usr/bin/env bash
# openclaw-parents — 本地 Mac 端同步脚本
# 用法: ./local/sync.sh [commit message]

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_DIR="$REPO_DIR/local"
SHARED_DIR="$REPO_DIR/shared"
COMMIT_MSG="${1:-"local: $(date '+%Y-%m-%d %H:%M')"}"

echo "=== 龙虾母亲 [本地端] 同步开始 ==="

# 0. 先拉取远端（双向同步关键步骤）
echo "→ 拉取远端最新..."
cd "$REPO_DIR"
git stash --quiet 2>/dev/null || true
git pull --rebase origin main 2>&1 | sed 's/^/   /'
git stash pop --quiet 2>/dev/null || true

# 1. 全局身份（shared，两端共用）
echo "→ 同步全局身份..."
cp ~/.claude/CLAUDE.md "$SHARED_DIR/claude/CLAUDE.md"

# 2. Claude 记忆文件
echo "→ 同步 Claude 记忆..."
cp ~/.claude/projects/-Users-wangdong/memory/MEMORY.md       "$LOCAL_DIR/claude/memory/MEMORY.md"
cp ~/.claude/projects/-Users-wangdong/memory/lobster-empire.md  "$LOCAL_DIR/claude/memory/lobster-empire.md"
cp ~/.claude/projects/-Users-wangdong/memory/troubleshooting.md "$LOCAL_DIR/claude/memory/troubleshooting.md"

# 3. OpenClaw workspace 根目录 md
echo "→ 同步 workspace 根目录..."
for f in AGENTS.md HEARTBEAT.md IDENTITY.md MEMORY.md SOUL.md TOOLS.md USER.md OPENCLAW_SETUP.md; do
  src="$HOME/.openclaw/workspace/$f"
  [ -f "$src" ] && cp "$src" "$LOCAL_DIR/openclaw/workspace/$f"
done

# 4. 各 agent workspace md
for agent in kuro architect brain worker; do
  echo "→ 同步 $agent..."
  dst_dir="$LOCAL_DIR/openclaw/workspace/$agent"
  mkdir -p "$dst_dir"
  find "$HOME/.openclaw/workspace/$agent" -maxdepth 1 -name "*.md" | while read f; do
    cp "$f" "$dst_dir/$(basename "$f")"
  done
done

# 5. shared workspace
echo "→ 同步 shared workspace..."
mkdir -p "$LOCAL_DIR/openclaw/workspace/shared"
find "$HOME/.openclaw/workspace/shared" -maxdepth 1 -name "*.md" | while read f; do
  cp "$f" "$LOCAL_DIR/openclaw/workspace/shared/$(basename "$f")"
done

# 6. openclaw.json 脱敏模板
echo "→ 生成脱敏配置模板..."
python3 - <<PYEOF
import json

SENSITIVE_KEYS = {'apiKey', 'authHeader', 'botToken', 'appToken', 'userTokenReadOnly', 'auth', 'token'}

def sanitize(obj):
    if isinstance(obj, dict):
        return {k: "***REDACTED***" if k in SENSITIVE_KEYS else sanitize(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [sanitize(i) for i in obj]
    return obj

with open('/Users/wangdong/.openclaw/openclaw.json') as f:
    data = json.load(f)

with open('$LOCAL_DIR/openclaw/openclaw.template.json', 'w') as f:
    json.dump(sanitize(data), f, indent=2, ensure_ascii=False)

print("   配置模板生成完毕")
PYEOF

# 7. git commit & push
echo "→ Git 提交..."
git add -A
if git diff --cached --quiet; then
  echo "✓ 无变更，跳过提交"
else
  git commit -m "$COMMIT_MSG"
  git push origin main
  echo "✓ 已推送到 GitHub"
fi

echo "=== [本地端] 同步完成 ==="
