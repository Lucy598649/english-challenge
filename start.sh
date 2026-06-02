#!/bin/bash
# ============================================================
#  English Challenge — 本地启动脚本
#  关闭此窗口 / Ctrl+C 即停止后端服务
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/english-challenge/backend"

cd "$BACKEND_DIR"

# 自动安装依赖
if [ ! -d "node_modules" ]; then
    echo "📦 首次运行，正在安装依赖..."
    npm install --silent
    echo ""
fi

echo "╔══════════════════════════════════════════╗"
echo "║       🏆  English Challenge 后端        ║"
echo "╠══════════════════════════════════════════╣"
echo "║  API 地址 : http://localhost:3001        ║"
echo "║  题库数量 : 30 题                        ║"
echo "║  数据存储 : backend/data/submissions.json║"
echo "║                                          ║"
echo "║  双击 frontend/index.html 开始答题       ║"
echo "║  关闭此窗口即可停止服务                  ║"
echo "╚══════════════════════════════════════════╝"
echo ""

node server.js
