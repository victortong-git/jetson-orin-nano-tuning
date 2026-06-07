#!/bin/bash
set -e

echo "Disabling and stopping Docker and containerd..."
sudo systemctl stop docker containerd
sudo systemctl disable docker containerd
echo "Done. Docker and containerd have been stopped and disabled."
