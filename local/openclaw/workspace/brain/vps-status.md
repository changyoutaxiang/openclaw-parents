# VPS 云端分部状态（收集于 2026-03-12 09:02:36 PST）

## ⚠️ 隧道离线

VPS Gateway 无法访问（127.0.0.1:18790 不通）。

**可能原因：**
- autossh LaunchAgent 未运行（launchctl list | grep vps-tunnel）
- VPS Gateway 服务已停止（ssh vps，然后 systemctl --user status openclaw-gateway.service）

