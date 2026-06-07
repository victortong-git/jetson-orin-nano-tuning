#!/bin/bash
set -e

echo "Enabling and starting Docker and containerd..."
sudo systemctl enable docker containerd
sudo systemctl start docker containerd
echo "Done. Docker and containerd have been enabled and started."
