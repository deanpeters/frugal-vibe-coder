#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Dyad + Ollama bootstrap for macOS
# - Downloads latest Dyad macOS release from GitHub
# - Installs Ollama using Ollama's official install script
# - Starts Ollama
# - Optionally pulls one or more Ollama models
#
# Notes:
# - Best on Apple Silicon Macs.
# - Requires: macOS, curl, hdiutil, python3, unzip, rsync
# - You may be prompted for your password when moving apps into /Applications
# ------------------------------------------------------------

# -------------------------
# Config: edit these
# -------------------------

# Pull models automatically after Ollama starts?
PULL_MODELS=true

# Conservative default model list.
# qwen3:8b is a reasonable starter.
# qwen3-coder:30b is much larger; uncomment if your Mac has the RAM for it.
MODELS=(
  "qwen3:8b"
  # "qwen3-coder:30b"
)

# Install app into /Applications
APPS_DIR="/Applications"

# Temp workspace
WORK_DIR="$(mktemp -d /tmp/dyad-ollama-install.XXXXXX)"

# -------------------------
# Helpers
# -------------------------

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

log() {
  printf "\n==> %s\n" "$1"
}

warn() {
  printf "\nWARNING: %s\n" "$1"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

download_file() {
  local url="$1"
  local dest="$2"
  curl -L --fail --progress-bar "$url" -o "$dest"
}

wait_for_ollama() {
  local tries=60
  local i=1
  while [ "$i" -le "$tries" ]; do
    if curl -fsS http://localhost:11434/api/tags >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
    i=$((i + 1))
  done
  return 1
}

# -------------------------
# Preflight
# -------------------------

log "Checking platform"
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only."
  exit 1
fi

ARCH="$(uname -m)"
if [[ "$ARCH" != "arm64" && "$ARCH" != "x86_64" ]]; then
  echo "Unsupported macOS architecture: $ARCH"
  exit 1
fi

need_cmd curl
need_cmd python3
need_cmd hdiutil
need_cmd unzip
need_cmd rsync

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if [[ "${MACOS_MAJOR}" -lt 14 ]]; then
  warn "Ollama officially requires macOS 14 Sonoma or newer."
fi

log "Working directory: $WORK_DIR"

# -------------------------
# Fetch latest Dyad release asset from GitHub
# -------------------------

log "Fetching latest Dyad release metadata"
DYAD_API="https://api.github.com/repos/dyad-sh/dyad/releases/latest"
DYAD_JSON="$WORK_DIR/dyad-release.json"
download_file "$DYAD_API" "$DYAD_JSON"

log "Selecting Dyad macOS asset"
DYAD_URL="$(python3 - <<'PY' "$DYAD_JSON" "$ARCH"
import json, sys

path = sys.argv[1]
arch = sys.argv[2]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

assets = data.get("assets", [])
candidates = []

def score(name):
    n = name.lower()
    s = 0

    # Prefer dmg over zip, but either is okay
    if n.endswith(".dmg"):
        s += 30
    elif n.endswith(".zip"):
        s += 20

    # Prefer mac/darwin/osx assets
    if "mac" in n or "darwin" in n or "osx" in n:
        s += 20

    # Prefer correct arch
    if arch == "arm64":
        if "arm64" in n or "aarch64" in n or "apple" in n or "silicon" in n:
            s += 25
        if "x64" in n or "x86_64" in n or "intel" in n:
            s -= 50
    elif arch == "x86_64":
        if "x64" in n or "x86_64" in n or "intel" in n:
            s += 25
        if "arm64" in n or "aarch64" in n or "apple" in n or "silicon" in n:
            s -= 50

    return s

for asset in assets:
    name = asset.get("name", "")
    url = asset.get("browser_download_url", "")
    if not url:
        continue
    n = name.lower()
    if any(ext in n for ext in [".dmg", ".zip"]) and any(k in n for k in ["mac", "darwin", "osx", "apple", "silicon", "arm64", "x64", "x86_64", "intel"]):
        candidates.append((score(name), name, url))

if not candidates:
    # fallback: any dmg or zip
    for asset in assets:
        name = asset.get("name", "")
        url = asset.get("browser_download_url", "")
        if name.lower().endswith((".dmg", ".zip")):
            candidates.append((score(name), name, url))

if not candidates:
    raise SystemExit("No suitable Dyad release asset found.")

candidates.sort(reverse=True)
print(candidates[0][2])
PY
)"

if [[ -z "$DYAD_URL" ]]; then
  echo "Could not determine Dyad download URL."
  exit 1
fi

DYAD_FILE="$WORK_DIR/$(basename "$DYAD_URL")"
log "Downloading Dyad"
download_file "$DYAD_URL" "$DYAD_FILE"

# -------------------------
# Install Dyad
# -------------------------

log "Installing Dyad"
if [[ "$DYAD_FILE" == *.dmg ]]; then
  MOUNT_POINT="$WORK_DIR/dyad-mount"
  mkdir -p "$MOUNT_POINT"
  hdiutil attach "$DYAD_FILE" -nobrowse -mountpoint "$MOUNT_POINT" >/dev/null

  DYAD_APP="$(find "$MOUNT_POINT" -maxdepth 2 -name "*.app" | head -n 1 || true)"
  if [[ -z "$DYAD_APP" ]]; then
    hdiutil detach "$MOUNT_POINT" >/dev/null || true
    echo "Could not find Dyad.app inside DMG."
    exit 1
  fi

  sudo rsync -a "$DYAD_APP" "$APPS_DIR/"
  hdiutil detach "$MOUNT_POINT" >/dev/null || true

elif [[ "$DYAD_FILE" == *.zip ]]; then
  unzip -q "$DYAD_FILE" -d "$WORK_DIR/dyad-unzip"
  DYAD_APP="$(find "$WORK_DIR/dyad-unzip" -maxdepth 3 -name "*.app" | head -n 1 || true)"
  if [[ -z "$DYAD_APP" ]]; then
    echo "Could not find Dyad.app inside ZIP."
    exit 1
  fi

  sudo rsync -a "$DYAD_APP" "$APPS_DIR/"
else
  echo "Unsupported Dyad file format: $DYAD_FILE"
  exit 1
fi

log "Dyad installed to $APPS_DIR"

# -------------------------
# Install Ollama
# -------------------------

log "Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sh

# -------------------------
# Start Ollama
# -------------------------

log "Starting Ollama"
# Try app launch first if app exists, otherwise run background serve
if [[ -d "/Applications/Ollama.app" ]]; then
  open -a Ollama || true
else
  nohup ollama serve >/tmp/ollama-serve.log 2>&1 &
fi

log "Waiting for Ollama API on localhost:11434"
if ! wait_for_ollama; then
  echo "Ollama did not become ready in time."
  echo "Check logs at ~/.ollama/logs/server.log if present."
  exit 1
fi

log "Ollama is running"

# -------------------------
# Pull models
# -------------------------

if [[ "$PULL_MODELS" == "true" ]]; then
  for model in "${MODELS[@]}"; do
    log "Pulling model: $model"
    ollama pull "$model"
  done
fi

# -------------------------
# Launch Dyad
# -------------------------

log "Launching Dyad"
open -a Dyad || true

cat <<'EOF'

Done.

Next steps:
1. In Dyad, open the model picker.
2. Choose "Local Models".
3. Pick one of the Ollama models you pulled.
4. Start building.

If no local models appear in Dyad:
- Make sure Ollama is running.
- Confirm this works: curl http://localhost:11434/api/tags
- If needed, set OLLAMA_HOST=http://localhost:11434

EOF