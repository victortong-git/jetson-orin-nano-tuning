#!/bin/bash
set -e

echo "Enabling and starting nvargus-daemon..."
sudo systemctl enable nvargus-daemon
sudo systemctl start nvargus-daemon

echo "Done. nvargus-daemon has been enabled and started."
