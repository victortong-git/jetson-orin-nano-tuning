#!/usr/bin/env bash
set -euo pipefail

SWAPFILE=/swap/swapfile
SIZE=${1:-16G}

sudo dd if=/dev/zero of="$SWAPFILE" bs=1M count=$(numfmt --from=iec "$SIZE" | awk '{printf "%.0f\n", $1/1048576}') status=progress
sudo chmod 600 "$SWAPFILE"
sudo mkswap "$SWAPFILE"
sudo swapon "$SWAPFILE"

if ! grep -q "$SWAPFILE" /etc/fstab; then
    echo "$SWAPFILE none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
fi

swapon --show
