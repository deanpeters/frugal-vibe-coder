#!/usr/bin/env bash
# install-aider.sh
# Install Aider — AI pair programming in your terminal.
#
# Usage:
#   ./scripts/install-aider.sh
#
# What this does:
#   1. Checks Python 3.10+ is available
#   2. Checks if Aider is already installed
#   3. Installs via pipx (isolated Python app install)
#   4. Configures it to use Ollama by default
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

# ---------------------------------------------------------------------------
# Introduction
# ---------------------------------------------------------------------------
print_header "Aider — AI Pair Programming"

print_info "OpenCode and Goose work best when you're starting something new."
print_info "Aider is different: it's built for iterating on code that already exists."
print_blank
print_info "Point Aider at a project folder, describe what you want to change,"
print_info "and it edits your files directly — showing you a clear diff of every change"
print_info "before anything is saved."
print_blank
print_info "Aider works with your local Ollama model. No API key required."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "Aider needs a model to work. Ollama provides one for free."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here so you don't end up with a half-configured setup."
        print_info "Run ./scripts/install-aider.sh again after Ollama is installed."
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
        print_warn "Python ${PY_VERSION} found — Aider needs Python 3.10 or newer."
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

if is_installed aider; then
    print_success "Aider is already installed"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing Aider installation."
            ;;
        2)
            print_step "Updating Aider..."
            if command -v pipx &>/dev/null && pipx list 2>/dev/null | grep -q aider-chat; then
                run_with_status "Updating Aider" pipx upgrade aider-chat
            else
                run_with_status "Updating Aider" pip3 install --upgrade aider-chat
            fi
            print_success "Aider updated."
            INSTALL_METHOD="updated"
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "Aider is not installed."
    print_blank

    if ! ask "Install Aider now?"; then
        print_info "Skipping Aider install."
        print_info "You can install it later by running: ./scripts/install-aider.sh"
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

    print_step "Installing Aider..."
    print_info "This downloads Aider and its dependencies — it may take a few minutes."
    print_blank

    run_with_status "Installing Aider" pipx install aider-chat

    print_success "Aider installed."
    INSTALL_METHOD="pipx"
fi

# ---------------------------------------------------------------------------
# Write default config for Ollama
# ---------------------------------------------------------------------------
AIDER_CONF="$HOME/.aider.conf.yml"

if [ ! -f "$AIDER_CONF" ]; then
    print_blank
    print_step "Writing default Aider config..."
    print_info "This sets Ollama as the default model so you don't need to type it every time."
    print_blank

    cat > "$AIDER_CONF" << EOF
# Aider default config — generated by frugal-vibe-coder
# To use a different model, change the value below or override with --model on the command line.
model: ollama/${LOCAL_MODEL}
EOF

    print_success "Config written to ~/.aider.conf.yml"
    print_info "Model set to: ollama/${LOCAL_MODEL}"
else
    print_info "Existing ~/.aider.conf.yml found — leaving it unchanged."
    print_info "To use Ollama, run: aider --model ollama/${LOCAL_MODEL}"
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
record_install \
    "Aider" \
    "$(aider --version 2>/dev/null | head -1 || echo "installed")" \
    "$INSTALL_METHOD" \
    "~/.aider.conf.yml" \
    "CLI"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "Aider is ready"

print_success "Aider is installed."
print_blank
print_info "How to use it:"
print_info "  1. Move into a project folder:  cd ~/my-project"
print_info "  2. Run Aider:                   aider"
print_info "  3. Describe what to change in plain language"
print_info "  4. Review the diff before it's applied"
print_blank
print_info "Aider works best inside a git repository."
print_info "If your project isn't in git yet: git init"
print_blank
print_info "Guide: docs/setup/aider.md"
print_blank
print_state_file_location
