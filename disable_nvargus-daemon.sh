#!/bin/bash
set -e

echo "Stopping nvargus-daemon..."
sudo systemctl stop nvargus-daemon

echo "Disabling nvargus-daemon..."
sudo systemctl disable nvargus-daemon

echo "Done. nvargus-daemon has been stopped and disabled."
