#!/usr/bin/env bash
set -euo pipefail

LLAMA_DIR="${1:-$(cd "$(dirname "$0")" && pwd)/llama.cpp}"

echo "[1/5] Installing build dependencies..."
if command -v apt-get &>/dev/null; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq cmake build-essential ccache cuda-nvcc-13-2 2>/dev/null || \
  sudo apt-get install -y -qq cmake build-essential ccache
elif command -v dnf &>/dev/null; then
  sudo dnf install -y cmake gcc-c++ make ccache
elif command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm cmake make gcc ccache
else
  echo "Warning: Package manager not detected. Ensure cmake, make, g++, and ccache are installed."
fi

echo "[2/5] Cloning/fetching latest llama.cpp..."
if [ -d "$LLAMA_DIR/.git" ]; then
  echo "llama.cpp already exists at $LLAMA_DIR, fetching latest..."
  git -C "$LLAMA_DIR" fetch origin
  git -C "$LLAMA_DIR" reset --hard origin/main || git -C "$LLAMA_DIR" reset --hard origin/master
else
  git clone --depth 1 https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
fi

echo "[3/5] Configuring build with CUDA..."
BUILD_DIR="$LLAMA_DIR/build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

ARCH=$(uname -m)

# Locate CUDA toolkit
CUDA_BIN=""
for dir in /usr/local/cuda-13.2 /usr/local/cuda-13 /usr/local/cuda-12.2 /usr/local/cuda-12 /usr/local/cuda*; do
  if [ -f "$dir/bin/nvcc" ]; then
    CUDA_BIN="$dir/bin"
    break
  fi
done
if [ -z "$CUDA_BIN" ] && command -v nvcc &>/dev/null; then
  CUDA_BIN=$(dirname "$(command -v nvcc)")
fi

if [ -n "$CUDA_BIN" ]; then
  export PATH="$CUDA_BIN:$PATH"
  export CUDACXX="$CUDA_BIN/nvcc"
  echo "CUDA found: $CUDACXX"
else
  echo "CUDA not found, building without CUDA support."
fi

# Jetson Orin Nano has Ampere GPU (compute capability 8.7)
CUDA_OPTS=()
if [ -n "$CUDA_BIN" ]; then
  CUDA_OPTS=(-DGGML_CUDA=ON -DGGML_CUDA_F16=ON -DGGML_CUDA_FA=ON)
  if [ "$ARCH" = "aarch64" ]; then
    CUDA_OPTS+=(-DCMAKE_CUDA_ARCHITECTURES="87")
  fi
fi

COMMON_OPTS=(-DGGML_NATIVE=ON -DGGML_OPENMP=ON)
if [ "$ARCH" = "aarch64" ]; then
  COMMON_OPTS+=(-DGGML_FMA=OFF)
else
  COMMON_OPTS+=(-DGGML_OPENBLAS=ON)
fi

cmake -S "$LLAMA_DIR" -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  "${CUDA_OPTS[@]}" \
  "${COMMON_OPTS[@]}" \
  -DGGML_METAL=OFF \
  -DGGML_CCACHE=ON

echo "[4/5] Building with $(nproc) parallel jobs..."
cmake --build "$BUILD_DIR" --config Release -j "$(nproc)"

echo "[5/5] Build complete!"
echo ""
echo "=== llama.cpp build summary ==="
echo "Source:   $LLAMA_DIR"
echo "Binaries: $BUILD_DIR/bin/"
echo ""
ls -lh "$BUILD_DIR/bin/" 2>/dev/null || ls "$BUILD_DIR/bin/" 2>/dev/null
echo ""
echo "To run inference:"
echo "  cd $BUILD_DIR/bin && ./llama-cli -h"
echo "  cd $BUILD_DIR/bin && ./llama-infill -h"
echo ""
