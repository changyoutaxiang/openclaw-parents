#!/usr/bin/env bash
# openclaw-parents — VPS 端同步脚本
# 用法: ./vps/sync.sh [commit message]
# 首次使用请先运行: ./vps/setup.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VPS_DIR="$REPO_DIR/vps"
SHARED_DIR="$REPO_DIR/shared"
COMMIT_MSG="${1:-"vps: $(date '+%Y-%m-%d %H:%M')"}"

# 路径配置（首次由 setup.sh 写入，或手动调整）
CLAUDE_MEMORY_DIR="${CLAUDE_MEMORY_DIR:-$(find /root/.claude/projects -maxdepth 3 -name "MEMORY.md" 2>/dev/null | head -1 | xargs -r dirname 2>/dev/null)}"
OPENCLAW_WORKSPACE="/root/.openclaw/workspace"

echo "=== 龙虾母亲 [VPS 端] 同步开始 ==="

# 0. 先拉取远端（双向同步关键步骤）
echo "→ 拉取远端最新..."
cd "$REPO_DIR"
git stash --quiet 2>/dev/null || true
git pull --rebase origin main 2>&1 | sed 's/^/   /'
git stash pop --quiet 2>/dev/null || true

# 1. 全局身份（shared，两端共用）
# 方向：shared/ 是权威来源（由本地 Mac 维护），VPS 只读取/还原
echo "→ 同步全局身份..."
if [ -f "$SHARED_DIR/claude/CLAUDE.md" ]; then
  mkdir -p /root/.claude
  cp "$SHARED_DIR/claude/CLAUDE.md" /root/.claude/CLAUDE.md
  echo "   ✓ 已还原 /root/.claude/CLAUDE.md"
else
  # 如果 shared 里还没有，则从本地上传一次（兜底）
  [ -f /root/.claude/CLAUDE.md ] && cp /root/.claude/CLAUDE.md "$SHARED_DIR/claude/CLAUDE.md"
fi

# 2. Claude 记忆文件
if [ -n "$CLAUDE_MEMORY_DIR" ] && [ -d "$CLAUDE_MEMORY_DIR" ]; then
  echo "→ 同步 Claude 记忆 ($CLAUDE_MEMORY_DIR)..."
  mkdir -p "$VPS_DIR/claude/memory"
  find "$CLAUDE_MEMORY_DIR" -maxdepth 1 -name "*.md" | while read f; do
    cp "$f" "$VPS_DIR/claude/memory/$(basename "$f")"
  done
else
  echo "⚠ 未找到 Claude 记忆目录，跳过（可设置环境变量 CLAUDE_MEMORY_DIR）"
fi

# 3. OpenClaw workspace 根目录 md
echo "→ 同步 workspace 根目录..."
mkdir -p "$VPS_DIR/openclaw/workspace"
for f in AGENTS.md HEARTBEAT.md IDENTITY.md MEMORY.md SOUL.md TOOLS.md USER.md; do
  src="$OPENCLAW_WORKSPACE/$f"
  [ -f "$src" ] && cp "$src" "$VPS_DIR/openclaw/workspace/$f"
done

# 4. 各 agent workspace md（VPS 四虾）
for agent in auto health intel code; do
  src_dir="$OPENCLAW_WORKSPACE/$agent"
  [ -d "$src_dir" ] || continue
  echo "→ 同步 $agent..."
  dst_dir="$VPS_DIR/openclaw/workspace/$agent"
  mkdir -p "$dst_dir"
  find "$src_dir" -maxdepth 1 -name "*.md" | while read f; do
    cp "$f" "$dst_dir/$(basename "$f")"
  done
done

# 5. shared workspace
echo "→ 同步 shared workspace..."
shared_src="$OPENCLAW_WORKSPACE/shared"
if [ -d "$shared_src" ]; then
  mkdir -p "$VPS_DIR/openclaw/workspace/shared"
  find "$shared_src" -maxdepth 1 -name "*.md" | while read f; do
    cp "$f" "$VPS_DIR/openclaw/workspace/shared/$(basename "$f")"
  done
fi

# 6. openclaw.json 脱敏模板
echo "→ 生成脱敏配置模板..."
python3 - <<PYEOF
import json, os

SENSITIVE_KEYS = {'apiKey', 'authHeader', 'botToken', 'appToken', 'userTokenReadOnly', 'auth', 'token'}

def sanitize(obj):
    if isinstance(obj, dict):
        return {k: "***REDACTED***" if k in SENSITIVE_KEYS else sanitize(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [sanitize(i) for i in obj]
    return obj

src = '/root/.openclaw/openclaw.json'
dst = '$VPS_DIR/openclaw/openclaw.template.json'

if not os.path.exists(src):
    print("   ⚠ 未找到 openclaw.json，跳过")
else:
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    with open(src) as f:
        data = json.load(f)
    with open(dst, 'w') as f:
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

echo "=== [VPS 端] 同步完成 ==="
