#!/bin/bash
# ============================================================
#  English Challenge — 一键启动
#  关闭窗口即停止，数据自动存本地
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/english-challenge/backend"

# ── 获取本机局域网 IP（排除 docker/虚拟网卡） ──
get_lan_ip() {
    ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+(?=/\d+)' | while read ip; do
        case "$ip" in
            127.*|172.1[7-9].*|172.2[0-9].*|172.3[01].*|198.18.*|198.19.*) continue ;;
            10.*|172.1[6].*|172.3[2].*|192.168.*) echo "$ip"; return ;;
        esac
    done | head -1
}

LAN_IP=$(get_lan_ip)

# ── 安装依赖 ──
cd "$BACKEND_DIR"
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 首次运行，安装依赖...${NC}"
    npm install --silent
    echo ""
fi

# ── 防火墙检查 ──
echo -e "${CYAN}🔍 检查网络配置...${NC}"

check_port_open() {
    # 用 Python 快速检测端口是否对外可达
    python3 -c "
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(1)
try:
    s.bind(('0.0.0.0', 3001))
    s.close()
    print('free')
except:
    print('in_use')
" 2>/dev/null
}

PORT_STATUS=$(check_port_open)
if [ "$PORT_STATUS" = "in_use" ]; then
    echo -e "  ${RED}⚠ 端口 3001 已被占用${NC}"
    echo "  请先关闭占用该端口的程序：lsof -i :3001"
    echo ""
fi

# 检查 UFW
if command -v ufw &>/dev/null; then
    if sudo -n ufw status 2>/dev/null | grep -q "^Status: active"; then
        if ! sudo -n ufw status 2>/dev/null | grep -q "3001"; then
            echo -e "  ${YELLOW}⚠ 防火墙未开放 3001 端口，外网无法访问${NC}"
            echo ""
            echo "  执行以下命令开放端口（需要管理员权限）："
            echo ""
            echo -e "    ${GREEN}sudo ufw allow 3001/tcp${NC}"
            echo ""
        fi
    fi
else
    # iptables 检查
    if command -v iptables &>/dev/null; then
        echo -e "  ${YELLOW}⚠ 检测到 iptables，如外网无法访问请检查规则${NC}"
    fi
fi

echo ""

# ── 启动 ──
echo "╔══════════════════════════════════════════════════════╗"
echo "║          🏆  English Challenge  English Challenge              ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║                                                      ║"
echo "║  本机打开:                                           ║"
echo -e "║  ${GREEN}👉 http://localhost:3001${NC}                        ║"
if [ -n "$LAN_IP" ]; then
echo "║                                                      ║"
echo "║  手机/平板/其他电脑（同 WiFi）:                       ║"
echo -e "║  ${GREEN}👉 http://${LAN_IP}:3001${NC}     ║"
fi
echo "║                                                      ║"
echo -e "║  题库: 30 题    数据: ${CYAN}submissions.json${NC}          ║"
echo -e "║  ${RED}关闭此窗口即停止服务${NC}                              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# 启动服务
exec node server.js
