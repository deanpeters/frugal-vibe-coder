#!/usr/bin/env bash
# install-bolt-diy.sh
# Install bolt.diy — a browser-based AI app builder that runs on your machine.
#
# Usage:
#   ./scripts/install-bolt-diy.sh
#
# What this does:
#   1. Checks prerequisites: Ollama, Node.js, git, pnpm
#   2. Clones the bolt.diy repo to ~/bolt.diy
#   3. Installs dependencies
#   4. Configures it to use your local Ollama model
#   5. Records the install in docs/reference/my-setup.md

set -euo pipefail

# ---------------------------------------------------------------------------
# Load shared libraries
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/platform.sh"
source "$SCRIPT_DIR/lib/packages.sh"
source "$SCRIPT_DIR/lib/check.sh"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/state.sh"

load_config

BOLT_DIR="$HOME/bolt.diy"

# ---------------------------------------------------------------------------
# Introduction
# ---------------------------------------------------------------------------
print_header "bolt.diy — Browser-Based AI App Builder"

print_info "bolt.diy is a locally-run app builder you access through your browser."
print_info "You describe what you want to build in plain language, and bolt.diy"
print_info "generates a working app — UI, logic, and all — right in the browser."
print_blank
print_info "Unlike Dyad, bolt.diy outputs downloadable code and supports more"
print_info "complex app structures. It runs entirely on your machine."
print_blank
print_info "This tool requires a few more steps to set up than Dyad."
print_info "If you haven't tried Dyad yet, that's the faster starting point."
print_blank

# ---------------------------------------------------------------------------
# Prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "bolt.diy needs Ollama to run AI features locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here. Run ./scripts/install-bolt-diy.sh again after Ollama is installed."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Prerequisite: Node.js
# ---------------------------------------------------------------------------
print_step "Checking for Node.js..."
print_blank

OS=$(detect_os)

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version 2>/dev/null)
    print_success "Node.js is installed  ($NODE_VERSION)"
else
    print_warn "Node.js is not installed."
    print_info "bolt.diy is a Node.js application — it needs Node.js 18 or later to run."
    print_blank

    if ! ask "Install Node.js now?"; then
        print_info "Stopping here. Install Node.js and run this script again."
        print_info "  macOS:  brew install node"
        print_info "  Linux:  sudo apt install nodejs npm"
        print_info "  All:    https://nodejs.org (download the LTS version)"
        exit 0
    fi

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                run_with_status "Installing Node.js" brew install node
            else
                print_info "Homebrew not found. Download Node.js from: https://nodejs.org"
                print_info "Get the LTS version for macOS and run the installer."
                if ! wait_for_tool_install node "Node.js"; then
                    exit 0
                fi
            fi
            ;;
        debian)
            apt_update_if_needed
            run_with_status "Installing Node.js" sudo apt install -y nodejs npm
            ;;
        *)
            print_error "Unsupported platform. Install Node.js from: https://nodejs.org"
            exit 1
            ;;
    esac

    if ! command -v node &>/dev/null; then
        print_warn "Node.js still not found on PATH."
        print_info "Try opening a new terminal and running this script again."
        exit 0
    fi

    print_success "Node.js installed."
fi

# ---------------------------------------------------------------------------
# Prerequisite: git
# ---------------------------------------------------------------------------
print_step "Checking for git..."
print_blank

if ! command -v git &>/dev/null; then
    print_warn "git is not installed."
    print_info "bolt.diy is installed by cloning its GitHub repository, which requires git."
    print_blank

    if ! ask "Install git now?"; then
        print_info "Stopping here. Install git and run this script again."
        exit 0
    fi

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                run_with_status "Installing git" brew install git
            else
                print_info "On macOS, you can install git by running: xcode-select --install"
                if ! wait_for_tool_install git "git"; then
                    exit 0
                fi
            fi
            ;;
        debian)
            apt_update_if_needed
            run_with_status "Installing git" sudo apt install -y git
            ;;
    esac

    print_success "git installed."
else
    GIT_VERSION=$(git --version 2>/dev/null)
    print_success "git is installed  ($GIT_VERSION)"
fi

# ---------------------------------------------------------------------------
# Prerequisite: pnpm
# ---------------------------------------------------------------------------
print_step "Checking for pnpm..."
print_blank

if ! command -v pnpm &>/dev/null; then
    print_warn "pnpm is not installed."
    print_info "bolt.diy uses pnpm to manage its dependencies."
    print_blank

    if ! ask "Install pnpm now?"; then
        print_info "Stopping here. Install pnpm and run this script again."
        print_info "  macOS:  brew install pnpm"
        print_info "  All:    npm install -g pnpm"
        exit 0
    fi

    if command -v brew &>/dev/null && [ "$OS" = "macos" ]; then
        run_with_status "Installing pnpm" brew install pnpm
    else
        run_with_status "Installing pnpm" npm install -g pnpm
    fi

    # pnpm may install to a non-standard path
    export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

    if ! command -v pnpm &>/dev/null; then
        print_warn "pnpm installed but not found on PATH."
        print_info "Try opening a new terminal and running this script again."
        exit 0
    fi

    print_success "pnpm installed."
else
    PNPM_VERSION=$(pnpm --version 2>/dev/null)
    print_success "pnpm is installed  ($PNPM_VERSION)"
fi

# ---------------------------------------------------------------------------
# Check current state of bolt.diy
# ---------------------------------------------------------------------------
print_step "Checking for bolt.diy..."
print_blank

INSTALL_METHOD="existing"

if [ -d "$BOLT_DIR" ]; then
    print_success "bolt.diy is already installed  ($BOLT_DIR)"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current installation and continue" \
        "Update bolt.diy to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing bolt.diy installation."
            ;;
        2)
            print_step "Updating bolt.diy..."
            print_blank
            run_with_status "Pulling latest changes" git -C "$BOLT_DIR" pull
            run_with_status "Installing updated dependencies" bash -c "cd '$BOLT_DIR' && pnpm install"
            print_success "bolt.diy updated."
            INSTALL_METHOD="updated"
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "bolt.diy is not installed."
    print_blank

    if ! ask "Install bolt.diy now?"; then
        print_info "Skipping bolt.diy install."
        print_info "You can install it later by running: ./scripts/install-bolt-diy.sh"
        exit 0
    fi

    print_blank
    print_info "bolt.diy will be cloned to: $BOLT_DIR"
    print_info "What this does:"
    print_info "  • Downloads the bolt.diy source code from GitHub  (~50 MB)"
    print_info "  • Installs its Node.js dependencies  (this can take a few minutes)"
    print_blank

    run_with_status "Cloning bolt.diy" \
        git clone https://github.com/stackblitz-labs/bolt.diy "$BOLT_DIR"

    print_blank
    print_info "Installing dependencies — this can take 2–5 minutes."
    print_info "You will not see much output while it runs. That is normal."
    print_blank

    run_with_status "Installing dependencies" bash -c "cd '$BOLT_DIR' && pnpm install"

    print_success "bolt.diy installed."
    INSTALL_METHOD="git clone"
fi

# ---------------------------------------------------------------------------
# Configure for Ollama
# ---------------------------------------------------------------------------
print_blank
print_header "Connect bolt.diy to Ollama"

ENV_FILE="$BOLT_DIR/.env.local"

if [ -f "$ENV_FILE" ] && grep -q "OLLAMA_API_BASE_URL" "$ENV_FILE"; then
    print_success "Ollama is already configured in .env.local"
else
    backup_file_if_exists "$ENV_FILE" ".env.local"

    {
        echo ""
        echo "# Added by frugal-vibe-coder setup"
        echo "OLLAMA_API_BASE_URL=http://localhost:11434"
        echo "DEFAULT_NUM_CTX=32768"
    } >> "$ENV_FILE"

    print_success "Ollama connection settings written to .env.local"
fi

print_blank
print_info "bolt.diy will connect to your local Ollama instance at localhost:11434."
print_info "You will select ${LOCAL_MODEL} from the model menu inside the app."
print_blank

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
record_install \
    "bolt.diy" \
    "$(git -C "$BOLT_DIR" describe --tags --always 2>/dev/null || echo "installed")" \
    "$INSTALL_METHOD" \
    "$BOLT_DIR/.env.local" \
    "No-code"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "bolt.diy is ready"

print_success "bolt.diy is installed at: $BOLT_DIR"
print_blank
print_info "To start bolt.diy, run this in your terminal:"
print_blank
print_info "  cd ~/bolt.diy && pnpm run dev"
print_blank
print_info "Then open your browser and go to:"
print_blank
print_info "  http://localhost:5173"
print_blank
print_info "Inside bolt.diy:"
print_info "  1. Click the settings icon"
print_info "  2. Select Ollama as the model provider"
print_info "  3. Choose ${LOCAL_MODEL} from the model list"
print_blank
print_info "To stop bolt.diy: press Ctrl+C in the terminal where it's running."
print_blank
print_info "Guide: docs/setup/bolt-diy.md"
print_blank
print_state_file_location
