#!/usr/bin/env bash
set -euo pipefail

LLAMA_DIR="$(cd "$(dirname "$0")" && pwd)/llama.cpp"

echo "[1/5] Installing build dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq cmake build-essential ccache cuda-nvcc-13-2 2>/dev/null || \
sudo apt-get install -y -qq cmake build-essential ccache

CUDA_BIN="/usr/local/cuda-13.2/bin"
if [ ! -f "$CUDA_BIN/nvcc" ]; then
  # Fallback: find highest CUDA version
  CUDA_BIN=$(find /usr/local/cuda* -name nvcc -type f 2>/dev/null | head -1 | xargs dirname)
fi
export PATH="$CUDA_BIN:$PATH"
export CUDACXX="$CUDA_BIN/nvcc"

echo "[2/5] Cloning llama.cpp..."
if [ -d "$LLAMA_DIR" ]; then
  echo "llama.cpp already exists at $LLAMA_DIR, pulling latest..."
  git -C "$LLAMA_DIR" pull --ff-only
else
  git clone --depth 1 https://github.com/ggerganov/llama.cpp.git "$LLAMA_DIR"
fi

echo "[3/5] Configuring with CUDA for Jetson Orin Nano (aarch64)..."
BUILD_DIR="$LLAMA_DIR/build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cmake -S "$LLAMA_DIR" -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_CUDA=ON \
  -DGGML_CUDA_F16=ON \
  -DGGML_NATIVE=ON \
  -DCMAKE_CUDA_ARCHITECTURES="87" \
  -DGGML_FMA=OFF \
  -DGGML_CCACHE=ON \
  -DCMAKE_CUDA_COMPILER="$CUDA_BIN/nvcc" \
  -DCMAKE_INSTALL_PREFIX="$BUILD_DIR/install"

echo "[4/5] Building with $(nproc) parallel jobs..."
cmake --build "$BUILD_DIR" --config Release -j "$(nproc)"

echo "[5/5] Installing..."
cmake --install "$BUILD_DIR" --config Release

echo ""
echo "=== llama.cpp build complete ==="
echo "Binaries:     $BUILD_DIR/bin/"
echo "Install dir:  $BUILD_DIR/install/"
echo ""
echo "Key binaries:"
ls -lh "$BUILD_DIR/bin/"llama-* 2>/dev/null || ls -lh "$BUILD_DIR/bin/" 2>/dev/null
echo ""
echo "To run inference:  $BUILD_DIR/bin/llama-cli --help"
