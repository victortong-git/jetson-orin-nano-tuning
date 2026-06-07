#!/bin/bash
# Disable wireplumber at system level
sudo systemctl disable --now wireplumber

# Disable wireplumber at user level
systemctl --user disable --now wireplumber 2>/dev/null || true

echo "wireplumber disabled (system + user)"
