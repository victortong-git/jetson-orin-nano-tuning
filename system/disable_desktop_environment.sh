#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo)." >&2
  exit 1
fi

echo "=== Stopping and disabling display manager ==="
for dm in gdm3 gdm lightdm sddm lxdm xdm slim; do
  if systemctl is-enabled "$dm" &>/dev/null; then
    echo "Disabling $dm..."
    systemctl stop "$dm" 2>/dev/null || true
    systemctl disable "$dm"
  fi
done

echo ""
echo "=== Stopping and disabling remote desktop services ==="
for rs in gnome-remote-desktop xrdp x11vnc; do
  if systemctl is-enabled "$rs" &>/dev/null 2>&1; then
    echo "Disabling $rs..."
    systemctl stop "$rs" 2>/dev/null || true
    systemctl disable "$rs"
  fi
done

echo ""
echo "=== Setting default target to multi-user (text mode) ==="
systemctl set-default multi-user.target

echo ""
echo "=== Current default target ==="
systemctl get-default

echo ""
echo "Done. Reboot for changes to take effect."
echo "To restore GUI later, run: sudo systemctl set-default graphical.target"
exit 0
