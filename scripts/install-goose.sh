#!/usr/bin/env bash
# install-goose.sh
# Install Goose — an open source, general-purpose AI agent for your machine.
#
# Usage:
#   ./scripts/install-goose.sh
#
# What this does:
#   1. Checks if Goose is already installed
#   2. Installs via the official install script
#   3. Guides you through connecting to Ollama
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
print_header "Goose — General-Purpose AI Agent"

print_info "OpenCode is designed for coding workflows. Goose is broader."
print_info "It can write code, run commands, search the web, manage files,"
print_info "do research, and automate workflows — all from your terminal."
print_blank
print_info "Goose is open source, works with Ollama, and is part of the"
print_info "Linux Foundation's Agentic AI Foundation."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama (recommended, not required)
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "Goose can use Ollama for free local inference."
    print_info "Without it, Goose will need a paid API key to function."
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi
fi

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OS=$(detect_os)
INSTALL_METHOD="existing"

if is_installed goose; then
    GOOSE_VERSION=$(get_tool_version goose)
    print_success "Goose is already installed  ($GOOSE_VERSION)"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update Goose to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing Goose installation."
            ;;
        2)
            print_step "Updating Goose..."
            print_info "This uses the same install script as a fresh install."
            print_blank
            if ask "Continue with the update?"; then
                run_with_status "Updating Goose" \
                    bash -c 'curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh | bash'
                export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
                print_success "Goose updated."
                INSTALL_METHOD="updated"
            fi
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "Goose is not installed."
    print_blank

    if ! ask "Install Goose now?"; then
        print_info "Skipping Goose install."
        print_info "You can install it later by running: ./scripts/install-goose.sh"
        exit 0
    fi

    print_blank
    print_info "Goose installs using the official install script from GitHub."
    print_info "What this script does:"
    print_info "  • Downloads the Goose binary for your platform"
    print_info "  • Places it in ~/.local/bin (macOS/Linux)"
    print_info "  • Does not require root or sudo"
    print_blank

    if ! ask "Download and run the Goose install script?"; then
        print_info "Skipping. You can also download the Goose desktop app at:"
        print_info "  https://github.com/aaif-goose/goose/releases/latest"
        exit 0
    fi

    print_step "Installing Goose..."
    print_blank

    run_with_status "Installing Goose" \
        bash -c 'curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh | bash'

    # Make goose available in this session
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

    if ! is_installed goose; then
        print_warn "Goose installed but is not yet on your PATH in this session."
        print_info "Open a new terminal window and run: goose configure"
        print_info "Or restart your terminal and run this script again."
        exit 0
    fi

    print_success "Goose installed."
    INSTALL_METHOD="install script"
fi

# ---------------------------------------------------------------------------
# Ollama configuration guidance
# ---------------------------------------------------------------------------
print_blank
print_header "Connect Goose to Ollama"

print_info "Run this to configure Goose:"
print_blank
print_info "  goose configure"
print_blank
print_info "When it asks for a provider, choose  Ollama."
print_info "When it asks for a model, enter:  ${LOCAL_MODEL}"
print_blank
print_info "Goose will use your local Ollama model — no API key required."
print_blank

if ask "Run 'goose configure' now?"; then
    print_blank
    print_info "Follow the prompts. When you're done, come back here."
    print_blank
    goose configure
    print_blank
    press_enter_to_continue
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
case "$OS" in
    macos)   CONFIG_LOC="~/.config/goose/" ;;
    debian)  CONFIG_LOC="~/.config/goose/" ;;
    *)       CONFIG_LOC="~/.config/goose/" ;;
esac

record_install \
    "Goose" \
    "$(get_tool_version goose)" \
    "$INSTALL_METHOD" \
    "$CONFIG_LOC" \
    "CLI"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "Goose is ready"

print_success "Goose is installed."
print_blank
print_info "Start a session:"
print_info "  goose session"
print_blank
print_info "Or ask it to do something directly:"
print_info "  goose run --text \"summarize the files in this directory\""
print_blank
print_info "Guide: docs/setup/goose.md"
print_blank
print_state_file_location
