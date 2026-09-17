#!/usr/bin/env bash
#
# AULA F75 Max — Linux setup via keyd
# Usage: sudo ./install.sh
#
set -euo pipefail

CONFIG_SRC="/etc/keyd/aula-f75.conf"
CONFIG_DIR="/etc/keyd"

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo ./install.sh" >&2
    exit 1
fi

# 1. Install keyd if missing
if ! command -v keyd >/dev/null 2>&1 && ! command -v keyd.rvaiya >/dev/null 2>&1; then
    echo "==> Installing keyd..."
    apt-get update
    apt-get install -y keyd
fi

# 2. Install config
echo "==> Installing config to ${CONFIG_SRC}"
mkdir -p "${CONFIG_DIR}"
install -m 0644 keyd/aula-f75.conf "${CONFIG_SRC}"

# 3. Enable and restart the daemon
echo "==> Starting keyd service"
systemctl enable keyd
systemctl restart keyd

echo
echo "Done. Usage:"
echo "  FN + Esc  - toggle between F-keys mode and media-keys mode"
echo "  Check logs: journalctl -u keyd -n 30 --no-pager"