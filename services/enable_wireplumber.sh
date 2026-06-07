#!/bin/bash
# Enable wireplumber at system level
sudo systemctl enable --now wireplumber

# Enable wireplumber at user level
systemctl --user enable --now wireplumber 2>/dev/null || true

echo "wireplumber enabled (system + user)"
