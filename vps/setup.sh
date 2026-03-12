#!/usr/bin/env bash
# VPS 端首次部署脚本
# 在 VPS 上执行一次，完成 git 仓库克隆 + 权限配置
#
# 用法:
#   curl -fsSL https://raw.githubusercontent.com/changyoutaxiang/openclaw-parents/main/vps/setup.sh | bash
# 或者 clone 后:
#   bash vps/setup.sh

set -e

REPO_URL="https://github.com/changyoutaxiang/openclaw-parents.git"
REPO_DIR="/root/Projects/openclaw-parents"

echo "=== VPS 龙虾母亲部署 ==="

# 1. 克隆仓库
if [ -d "$REPO_DIR/.git" ]; then
  echo "→ 仓库已存在，跳过克隆"
else
  echo "→ 克隆仓库..."
  mkdir -p /root/Projects
  git clone "$REPO_URL" "$REPO_DIR"
fi

# 2. 设置执行权限
chmod +x "$REPO_DIR/vps/sync.sh"
chmod +x "$REPO_DIR/vps/setup.sh"

# 3. 检测 Claude 记忆目录
echo "→ 检测 Claude 记忆目录..."
MEMORY_DIR=$(find /root/.claude/projects -maxdepth 2 -name "MEMORY.md" 2>/dev/null | head -1 | xargs dirname 2>/dev/null || true)
if [ -n "$MEMORY_DIR" ]; then
  echo "   找到: $MEMORY_DIR"
else
  echo "   ⚠ 未找到记忆目录（Claude Code 尚未在此 VPS 使用，或路径不同）"
  MEMORY_DIR=""
fi

# 4. 创建快捷命令
cat > /usr/local/bin/lobster-sync <<EOF
#!/usr/bin/env bash
# 龙虾母亲 VPS 端快捷同步
export CLAUDE_MEMORY_DIR="$MEMORY_DIR"
exec "$REPO_DIR/vps/sync.sh" "\$@"
EOF
chmod +x /usr/local/bin/lobster-sync
echo "→ 快捷命令已创建: lobster-sync"

# 5. 设置 cron（每天 23:00 UTC+8 = 15:00 UTC 自动同步）
CRON_JOB="0 15 * * * /usr/local/bin/lobster-sync 'cron: daily sync' >> /root/.openclaw/logs/git-sync.log 2>&1"
if crontab -l 2>/dev/null | grep -q "lobster-sync"; then
  echo "→ Cron 任务已存在，跳过"
else
  (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
  echo "→ Cron 已设置: 每天 23:00 CST 自动同步"
fi

echo ""
echo "=== 部署完成 ==="
echo ""
echo "日常使用:"
echo "  lobster-sync                    # 手动同步"
echo "  lobster-sync '自定义消息'       # 带 commit 消息同步"
echo ""
echo "仓库位置: $REPO_DIR"
