#!/usr/bin/env bash
# install-langflow.sh
# Install LangFlow — a visual builder for AI pipelines and agent workflows.
#
# Usage:
#   ./scripts/install-langflow.sh
#
# What this does:
#   1. Checks Python 3.10+ is available
#   2. Checks if LangFlow is already installed
#   3. Installs via pipx (isolated Python app install)
#   4. Explains how to start it and connect to Ollama
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
print_header "LangFlow — Visual AI Pipeline Builder"

print_info "The no-code and CLI surfaces build apps by talking to a model."
print_info "LangFlow is different: it lets you design how AI components connect to each other"
print_info "using a visual canvas — models, prompts, retrievers, tools — wired together as a flow."
print_blank
print_info "This is the surface for learners ready to think about AI architecture,"
print_info "not just prompt a single model."
print_blank
print_info "LangFlow runs locally, connects to Ollama, and costs nothing to use."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "LangFlow can connect to Ollama for free local inference."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "You can continue and connect LangFlow to Ollama later."
        print_info "Or run ./scripts/install-ollama.sh first, then come back."
        if ! ask "Continue installing LangFlow without Ollama for now?"; then
            exit 0
        fi
    fi
fi

# ---------------------------------------------------------------------------
# Check Python 3.10–3.12
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
        print_warn "Python ${PY_VERSION} found — LangFlow needs Python 3.10 or newer."
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
    print_info "Python 3.11 or 3.12 is recommended for LangFlow."
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

if is_installed langflow; then
    print_success "LangFlow is already installed"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing LangFlow installation."
            ;;
        2)
            print_step "Updating LangFlow..."
            if command -v pipx &>/dev/null && pipx list 2>/dev/null | grep -q langflow; then
                run_with_status "Updating LangFlow" pipx upgrade langflow
            else
                run_with_status "Updating LangFlow" pip3 install --upgrade langflow
            fi
            print_success "LangFlow updated."
            INSTALL_METHOD="updated"
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "LangFlow is not installed."
    print_blank

    if ! ask "Install LangFlow now?"; then
        print_info "Skipping LangFlow install."
        print_info "You can install it later by running: ./scripts/install-langflow.sh"
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

    print_step "Installing LangFlow..."
    print_info "LangFlow has many dependencies — this download will take a few minutes."
    print_blank

    run_with_status "Installing LangFlow" pipx install langflow

    print_success "LangFlow installed."
    INSTALL_METHOD="pipx"
fi

# ---------------------------------------------------------------------------
# Guidance
# ---------------------------------------------------------------------------
print_blank
print_header "Starting LangFlow"

print_info "LangFlow runs as a local server you start from your terminal."
print_blank
print_info "To start it:"
print_info "  langflow run"
print_blank
print_info "Then open your browser to:"
print_info "  http://localhost:7860"
print_blank
print_info "To stop it later, press Ctrl+C in this terminal."
print_blank

print_header "Connecting LangFlow to Ollama"

print_info "Inside a flow, add an Ollama component:"
print_info "  1. In the component sidebar, search for 'Ollama'"
print_info "  2. Drag an Ollama component onto the canvas"
print_info "  3. Set Base URL to:  http://localhost:11434"
print_info "  4. Set Model Name to:  ${LOCAL_MODEL}"
print_blank
print_info "LangFlow will use your local Ollama model — no API key required."
print_blank

if ask "Start LangFlow now?"; then
    print_blank
    print_info "LangFlow will start in this terminal."
    print_info "Once you see 'Application startup complete', open http://localhost:7860 in your browser."
    print_info "To stop it later, press Ctrl+C in this terminal."
    press_enter_to_continue "Press Enter to start LangFlow..."
    langflow run
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
record_install \
    "LangFlow" \
    "$(langflow --version 2>/dev/null | head -1 || echo "installed")" \
    "$INSTALL_METHOD" \
    "~/.local/share/langflow/" \
    "Visual flow builder"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "LangFlow is ready"

print_success "LangFlow is installed."
print_blank
print_info "To start it:"
print_info "  langflow run"
print_blank
print_info "Then open: http://localhost:7860"
print_blank
print_info "Guide: docs/setup/langflow.md"
print_blank
print_state_file_location
