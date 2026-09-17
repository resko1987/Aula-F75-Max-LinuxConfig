#!/usr/bin/env bash
#
# AULA F75 Max — revert keyd setup (restore original media-key behavior)
# Usage: sudo ./uninstall.sh
#
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo ./uninstall.sh" >&2
    exit 1
fi

echo "==> Removing config"
rm -f /etc/keyd/aula-f75.conf

echo "==> Restarting keyd (continues without the AULA config)"
systemctl restart keyd 2>/dev/null || true

echo "Done. F1..F12 are media keys again."
echo "To fully remove keyd: sudo systemctl disable --now keyd && sudo apt purge keyd"