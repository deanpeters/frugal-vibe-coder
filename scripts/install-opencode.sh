#!/usr/bin/env bash
# install-opencode.sh
# Install OpenCode and configure it to use your local Ollama model.
#
# Usage:
#   ./scripts/install-opencode.sh
#
# What this does:
#   1. Checks if OpenCode is already installed
#   2. Offers to install, update, or skip
#   3. Configures OpenCode to use Ollama
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
print_header "OpenCode — CLI Surface"

print_info "Visual builders are fast, but they don't show you what's happening."
print_info "OpenCode runs in your terminal and makes the building process visible:"
print_info "you see which files are created, what the AI is planning, and why."
print_blank
print_info "You approve each step before anything changes."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "OpenCode needs Ollama to run AI features locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ! ask "Ollama is missing. Continue anyway?"; then
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OS=$(detect_os)

OPENCODE_VERSION=$(get_tool_version opencode)

if [ -n "$OPENCODE_VERSION" ]; then
    print_success "OpenCode is already installed  ($OPENCODE_VERSION)"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update OpenCode to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing OpenCode installation."
            ;;
        2)
            print_step "Updating OpenCode..."
            case "$OS" in
                macos)
                    if command -v brew &>/dev/null; then
                        brew upgrade opencode
                    else
                        curl -fsSL https://opencode.ai/install | sh
                    fi
                    ;;
                debian)
                    curl -fsSL https://opencode.ai/install | sh
                    ;;
            esac
            print_success "OpenCode updated."
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "OpenCode is not installed."
    print_blank

    if ! ask "Install OpenCode now?"; then
        print_info "Skipping OpenCode install."
        print_info "You can install it later by running: ./scripts/install-opencode.sh"
        exit 0
    fi

    print_step "Installing OpenCode..."
    print_blank

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                print_info "Using Homebrew..."
                brew install opencode
            else
                print_info "Installing from opencode.ai..."
                curl -fsSL https://opencode.ai/install | sh
            fi
            ;;
        debian)
            print_info "Installing from opencode.ai..."
            curl -fsSL https://opencode.ai/install | sh
            ;;
        *)
            print_error "Unsupported platform. Visit https://opencode.ai for instructions."
            exit 1
            ;;
    esac

    print_success "OpenCode installed."
fi

# ---------------------------------------------------------------------------
# Configure OpenCode to use Ollama
# ---------------------------------------------------------------------------
print_blank
print_header "Configure OpenCode"

print_info "OpenCode needs to know which model to use."
print_info "We'll configure it to use your local Ollama model (${LOCAL_MODEL})."
print_blank

# Determine config file location
case "$OS" in
    macos|debian) OPENCODE_CONFIG_DIR="$HOME/.config/opencode" ;;
    *)            OPENCODE_CONFIG_DIR="$HOME/.opencode" ;;
esac

OPENCODE_CONFIG="$OPENCODE_CONFIG_DIR/config.json"

if [ -f "$OPENCODE_CONFIG" ]; then
    print_success "OpenCode config already exists at $OPENCODE_CONFIG"
    print_blank

    choice=$(ask_choice "What would you like to do with the existing config?" \
        "Keep the existing config unchanged" \
        "Update it to use Ollama with ${LOCAL_MODEL}")

    case "$choice" in
        1)
            print_info "Keeping existing config."
            ;;
        2)
            print_step "Updating config..."
            mkdir -p "$OPENCODE_CONFIG_DIR"
            cat > "$OPENCODE_CONFIG" << EOF
{
  "provider": "ollama",
  "model": "${LOCAL_MODEL}"
}
EOF
            print_success "Config updated."
            ;;
    esac
else
    print_step "Creating config..."
    mkdir -p "$OPENCODE_CONFIG_DIR"
    cat > "$OPENCODE_CONFIG" << EOF
{
  "provider": "ollama",
  "model": "${LOCAL_MODEL}"
}
EOF
    print_success "Config created at $OPENCODE_CONFIG"
fi

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
print_blank
print_step "Verifying OpenCode is working..."

if command -v opencode &>/dev/null; then
    print_success "OpenCode is available and ready."
else
    print_warn "OpenCode command not found. You may need to restart your terminal."
    print_info "Try closing and reopening your terminal, then run:"
    print_info "  opencode --version"
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
OPENCODE_VERSION=$(get_tool_version opencode || echo "installed")

record_install \
    "OpenCode" \
    "$OPENCODE_VERSION" \
    "$(command -v brew &>/dev/null && echo "Homebrew" || echo "install.sh")" \
    "$OPENCODE_CONFIG_DIR/" \
    "CLI"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "OpenCode is ready"

print_success "OpenCode is installed and configured to use ${LOCAL_MODEL} via Ollama."
print_blank
print_info "To start a session:"
print_info "  1. Open your terminal"
print_info "  2. Navigate to a project folder"
print_info "  3. Run: opencode"
print_blank
print_info "OpenCode will show you its plan before making any changes."
print_info "Type y to approve, n to redirect, or /exit to quit."
print_blank
print_info "Guide: docs/surfaces/cli.md"
print_blank
print_state_file_location
