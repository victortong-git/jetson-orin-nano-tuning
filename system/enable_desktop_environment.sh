#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo)." >&2
  exit 1
fi

echo "=== Enabling display manager ==="
for dm in gdm3 lightdm sddm lxdm xdm slim; do
  if systemctl is-enabled "$dm" &>/dev/null || systemctl list-unit-files "$dm.service" &>/dev/null; then
    echo "Enabling $dm..."
    systemctl enable "$dm"
    systemctl start "$dm"
  fi
done

echo ""
echo "=== Setting default target to graphical (GUI mode) ==="
systemctl set-default graphical.target

echo ""
echo "=== Current default target ==="
systemctl get-default

echo ""
echo "Done. Reboot for changes to take effect."
exit 0
