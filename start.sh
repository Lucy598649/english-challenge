#!/bin/bash
# ============================================================
#  English Challenge — 本地启动脚本
#  关闭此窗口 / Ctrl+C 即停止后端服务
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/english-challenge/backend"

# 获取本机局域网 IP
LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$LOCAL_IP" ] && LOCAL_IP=$(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v 127.0.0.1 | head -1)

cd "$BACKEND_DIR"

# 自动安装依赖
if [ ! -d "node_modules" ]; then
    echo "📦 首次运行，正在安装依赖..."
    npm install --silent
    echo ""
fi

echo "╔══════════════════════════════════════════════════╗"
echo "║         🏆  English Challenge 后端              ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║                                                  ║"
echo "║  本机访问:                                       ║"
echo "║  👉 http://localhost:3001                        ║"
if [ -n "$LOCAL_IP" ]; then
echo "║                                                  ║"
echo "║  局域网设备访问（手机/其他电脑）:                 ║"
echo "║  👉 http://${LOCAL_IP}:3001                 ║"
fi
echo "║                                                  ║"
echo "║  GitHub Pages（仅本机）:                         ║"
echo "║  👉 https://lucy598649.github.io/english-challenge║"
echo "║                                                  ║"
echo "║  题库: 30 题  数据: backend/data/submissions.json║"
echo "║  关闭此窗口停止服务                              ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

node server.js
