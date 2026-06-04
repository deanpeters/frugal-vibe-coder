#!/usr/bin/env bash
# install-open-webui.sh
# Install Open WebUI — a ChatGPT-style interface for your local Ollama models.
#
# Usage:
#   ./scripts/install-open-webui.sh
#
# What this does:
#   1. Checks if Open WebUI is already installed
#   2. Installs via pipx (isolated Python app install)
#   3. Explains how to start it and connect to Ollama
#   4. Records the install in docs/reference/my-setup.md

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

# ---------------------------------------------------------------------------
# Introduction
# ---------------------------------------------------------------------------
print_header "Open WebUI — Local Chat Interface"

print_info "Ollama runs AI models on your machine, but it has no built-in chat interface."
print_info "Open WebUI adds one: a private, browser-based chat that looks and feels like ChatGPT,"
print_info "powered entirely by the local Ollama model you already have installed."
print_blank
print_info "No cloud account. No API key. No data leaving your machine."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "Open WebUI needs Ollama to run AI features locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here so you don't end up with a half-configured setup."
        print_info "Run ./scripts/install-open-webui.sh again after Ollama is installed."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Check Python 3.10+
# ---------------------------------------------------------------------------
print_step "Checking Python version..."
print_blank

PYTHON_OK=false
if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
    if [ "$PY_MAJOR" -gt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -ge 10 ]; }; then
        PYTHON_OK=true
        print_success "Python ${PY_VERSION} found"
    else
        print_warn "Python ${PY_VERSION} found — Open WebUI needs Python 3.10 or newer."
    fi
else
    print_warn "Python 3 is not installed."
fi
print_blank

if [ "$PYTHON_OK" = false ]; then
    OS=$(detect_os)
    print_info "Install Python 3 first:"
    case "$OS" in
        macos)  print_info "  brew install python" ;;
        debian) print_info "  sudo apt install python3 python3-pip" ;;
    esac
    print_blank
    print_info "Then run this script again."
    exit 1
fi

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OS=$(detect_os)
INSTALL_METHOD="existing"

if is_installed open-webui; then
    print_success "Open WebUI is already installed"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing Open WebUI installation."
            ;;
        2)
            print_step "Updating Open WebUI..."
            if command -v pipx &>/dev/null && pipx list 2>/dev/null | grep -q open-webui; then
                run_with_status "Updating Open WebUI" pipx upgrade open-webui
            else
                run_with_status "Updating Open WebUI" pip3 install --upgrade open-webui
            fi
            print_success "Open WebUI updated."
            INSTALL_METHOD="updated"
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "Open WebUI is not installed."
    print_blank

    if ! ask "Install Open WebUI now?"; then
        print_info "Skipping Open WebUI install."
        print_info "You can install it later by running: ./scripts/install-open-webui.sh"
        exit 0
    fi

    # Install pipx if not already available
    if ! command -v pipx &>/dev/null; then
        print_step "Installing pipx first..."
        print_info "pipx installs Python apps in isolated environments — safer than a direct pip install."
        print_blank

        case "$OS" in
            macos)
                if command -v brew &>/dev/null; then
                    run_with_status "Installing pipx" brew install pipx
                else
                    run_with_status "Installing pipx" python3 -m pip install --user pipx
                fi
                ;;
            debian)
                apt_update_if_needed
                if ! sudo apt install -y pipx 2>/dev/null; then
                    run_with_status "Installing pipx" python3 -m pip install --user pipx
                fi
                ;;
        esac

        export PATH="$HOME/.local/bin:$PATH"
        pipx ensurepath 2>/dev/null || true
        print_success "pipx installed."
        print_blank
    fi

    print_step "Installing Open WebUI..."
    print_info "This downloads Open WebUI and its dependencies — it may take a few minutes."
    print_blank

    run_with_status "Installing Open WebUI" pipx install open-webui

    print_success "Open WebUI installed."
    INSTALL_METHOD="pipx"
fi

# ---------------------------------------------------------------------------
# Connection guidance
# ---------------------------------------------------------------------------
print_blank
print_header "Starting Open WebUI"

print_info "Open WebUI runs as a local server you start from your terminal."
print_blank
print_info "To start it:"
print_info "  open-webui serve"
print_blank
print_info "Then open your browser to:"
print_info "  http://localhost:8080"
print_blank
print_info "The first time you open it, you'll be asked to create a local account."
print_info "This account stays on your machine — no cloud sign-up required."
print_blank
print_info "Open WebUI connects to Ollama automatically when both are running."
print_info "If it asks you to configure the connection, use:"
print_info "  Ollama URL: http://localhost:11434"
print_info "  Model: ${LOCAL_MODEL}"
print_blank

if ask "Start Open WebUI now?"; then
    print_blank
    print_info "Open WebUI will start in this terminal."
    print_info "Once you see 'Application startup complete', open http://localhost:8080 in your browser."
    print_info "To stop it later, press Ctrl+C in this terminal."
    press_enter_to_continue "Press Enter to start Open WebUI..."
    open-webui serve
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
record_install \
    "Open WebUI" \
    "$(open-webui --version 2>/dev/null | head -1 || echo "installed")" \
    "$INSTALL_METHOD" \
    "~/.local/share/open-webui/" \
    "No-code"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "Open WebUI is ready"

print_success "Open WebUI is installed."
print_blank
print_info "To start it:"
print_info "  open-webui serve"
print_blank
print_info "Then open: http://localhost:8080"
print_blank
print_info "Guide: docs/setup/open-webui.md"
print_blank
print_state_file_location
