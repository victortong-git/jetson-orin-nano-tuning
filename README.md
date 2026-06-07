# Jetson Orin Nano - Memory Optimization Scripts (JetPack 7.2)

Scripts to free up memory on Jetson Orin Nano after upgrading from JetPack 6.2 to 7.2 for running large LLM models with larger context windows.

## ⚠️ Boot Failure After Upgrade

If you fail to boot after upgrading from JetPack 6.2 to 7.2:

1. Check if the firmware was updated from **R36 to R39**
2. If not, upgrade the firmware to R39 first
3. **Brand new devices** should upgrade firmware to **R36 first** before upgrading to 7.2

## Purpose

These scripts optimize memory by:
- Adding swap file to extend virtual memory
- Disabling unnecessary desktop environment
- Disabling background services that consume memory

Mainly intended for running LLM inference tools like [llama.cpp](https://github.com/ggerganov/llama.cpp) or [Ollama](https://ollama.com/).

## Monitoring

If you want to use `jtop` (Jetson system monitoring tool), you have to install it first:

```bash
sudo apt install python3-pip
pip3 install jtop
```

## Structure

```
├── docker/           - Docker containerd enable/disable
├── llm_scripts/      - llama.cpp installation script
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
| `system/show_memory.sh` | Display current memory usage |

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

## ⚠️ Important: Reboot Required

**Reboot your Jetson after running any enable/disable scripts to confirm the update persistence.**

```bash
sudo reboot
```

## llama.cpp Installation

The installation script for llama.cpp can be found in the `llm_scripts/` folder:

```bash
llm_scripts/install_llamacpp.sh
```

Run with `sudo`:

```bash
sudo ./llm_scripts/install_llamacpp.sh
```

## License

This project is licensed under the [Apache License 2.0](LICENSE).
