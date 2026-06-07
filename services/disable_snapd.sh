#!/bin/bash
# Disable snapd service and socket
sudo systemctl disable --now snapd snapd.socket
echo "snapd disabled (service + socket)"