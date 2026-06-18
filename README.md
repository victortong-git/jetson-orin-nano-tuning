# Jetson Orin Nano - Memory Optimization Scripts (JetPack 7.2)

Scripts to free up memory on Jetson Orin Nano after upgrading from JetPack 6.2 to 7.2 for running large LLM models with larger context windows.

## ⚠️ Boot Failure After Upgrade

If you fail to boot after upgrading from JetPack 6.2 to 7.2:

1. Check if the firmware was updated from **R36 to R39**
2. If not, upgrade the firmware to R39 first
3. **Brand new devices** should upgrade firmware to **R36 first** before upgrading to 7.2

## Precautions

**⚠️ Run `system/disable_desktop_environment.sh` via SSH before disabling.** Disabling the desktop environment locally will disconnect your desktop session and prevent further GUI access. Use SSH to run this script, then reboot.

## Purpose

These scripts optimize memory by:
- Adding swap file to extend virtual memory
- Disabling unnecessary desktop environment
- Disabling background services that consume memory

Mainly intended for running LLM inference tools like [Ollama](https://ollama.com/).

## Results

After running all memory optimization scripts and rebooting, you should have approximately **6.7 GB available** out of 7.5 GB total RAM with 16 GB swap.

Use `./show_memory.sh` to verify your current memory usage.

## Monitoring

If you want to use `jtop` (Jetson system monitoring tool), you have to install it first:

```bash
sudo apt install python3-pip
pip3 install jtop
```

## Structure

```
├── docker/           - Docker containerd enable/disable
├── llm_scripts/      - LLM utility scripts
├── nvidia/           - NVIDIA nvargus-daemon enable/disable
├── services/         - General system services (bluetooth, lpd, ModemManager, wireplumber)
└── system/           - System configuration (add_swapfile, disable_desktop_environment)
```

## Usage

All scripts require root privileges. Run with `sudo`:

```bash
sudo ./script_name.sh
```

### Memory Optimization (Run First)

| Script | Description |
|--------|-------------|
| `system/add_swapfile.sh` | Create swap file for extended virtual memory |
| `system/disable_desktop_environment.sh` | Disable GUI desktop environment |
| `show_memory.sh` | Display current memory usage |

### Services Management

Services are disabled by default to free up memory. If you require a service, run the corresponding `enable_*.sh` script to re-enable it. Use the `disable_*.sh` script to disable it again when needed.

| Service | Description |
|---------|-------------|
| Bluetooth | Wireless Bluetooth connectivity for peripherals and devices |
| LPD (Line Printer Daemon) | Print service for network printing support |
| ModemManager | Mobile broadband and modem device management |
| Snapd | Snap package manager daemon |
| WirePlumber | Multimedia framework for GStreamer pipeline management |

### NVIDIA Services

| Service | Description |
|---------|-------------|
| nvargus-daemon | NVIDIA camera and video capture service for ISP |

### Docker

| Service | Description |
|---------|-------------|
| Docker & containerd | Container runtime for running Docker containers |

### LLM Installation

| Script | Description |
|--------|-------------|
| `llm_scripts/install_ollama_jetson.sh` | Install Ollama with automatic JetPack detection — selects the correct GPU binary for your L4T version and sets `JETSON_JETPACK=6` for Jetson Orin Nano |

## ⚠️ Important: Reboot Required

**Reboot your Jetson after running any enable/disable scripts to confirm the update persistence.**

```bash
sudo reboot
```

## License

This project is licensed under the [Apache License 2.0](LICENSE).
