#!/usr/bin/env bash
# install-dyad.sh
# Install Dyad and connect it to your local Ollama model.
#
# Usage:
#   ./scripts/install-dyad.sh
#
# What this does:
#   1. Checks if Dyad is already installed
#   2. Offers to install, or skip
#   3. Provides guidance on connecting Dyad to Ollama
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
print_header "Dyad — No-Code Surface"

print_info "Getting to a working app normally means writing code, navigating a terminal,"
print_info "or paying for a cloud service. Dyad removes all three barriers."
print_blank
print_info "Dyad is a free, open-source, visual app builder that runs on your machine."
print_info "You describe what you want to build. Dyad generates and runs it."
print_info "No coding required. No API costs. Your local Ollama model does the work."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "Dyad needs Ollama to run AI features locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here so you don't end up with a half-configured setup."
        print_info "Run ./scripts/install-dyad.sh again after Ollama is installed."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OS=$(detect_os)
INSTALL_METHOD="existing"

if is_installed dyad; then
    DYAD_VERSION=$(get_tool_version dyad)
    print_success "Dyad is already installed  ($DYAD_VERSION)"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Check for updates (opens Dyad — it will notify you if an update is available)" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing Dyad installation."
            ;;
        2)
            print_step "Opening Dyad..."
            case "$OS" in
                macos) open -a Dyad ;;
                debian) dyad &>/dev/null & ;;
            esac
            print_info "Check the Dyad interface for update notifications."
            press_enter_to_continue
            INSTALL_METHOD="existing"
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "Dyad is not installed."
    print_blank

    if ! ask "Install Dyad now?"; then
        print_info "Skipping Dyad install."
        print_info "You can install it later by running: ./scripts/install-dyad.sh"
        exit 0
    fi

    print_step "Installing Dyad..."
    print_blank

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                print_info "Using Homebrew..."
                brew install --cask dyad
                INSTALL_METHOD="Homebrew Cask"
            else
                print_info "Homebrew not found — opening the Dyad download page..."
                open "https://dyad.sh" 2>/dev/null || \
                    print_info "Visit https://dyad.sh to download Dyad manually."
                print_blank
                print_info "Download the .dmg file, open it, and drag Dyad to your Applications folder."
                if ! wait_for_path_install "/Applications/Dyad.app" "Dyad"; then
                    print_info "Stopping here for now. Run ./scripts/install-dyad.sh again when you're ready."
                    exit 0
                fi
                INSTALL_METHOD="manual download"
            fi
            ;;
        debian)
            print_info "Opening the Dyad download page..."
            xdg-open "https://dyad.sh" 2>/dev/null || \
                print_info "Visit https://dyad.sh to download Dyad for Linux."
            print_blank
            print_info "Download the .deb file and install it with:"
            print_info "  sudo apt install ./dyad-*.deb"
            if ! wait_for_tool_install dyad "Dyad"; then
                print_info "Stopping here for now. Run ./scripts/install-dyad.sh again when you're ready."
                exit 0
            fi
            INSTALL_METHOD="manual download"
            ;;
        *)
            print_error "Unsupported platform. Visit https://dyad.sh to download Dyad."
            exit 1
            ;;
    esac

    print_success "Dyad installation complete."
fi

# ---------------------------------------------------------------------------
# Connection guidance
# ---------------------------------------------------------------------------
print_blank
print_header "Connect Dyad to Ollama"

print_info "When you open Dyad for the first time, it will ask you to choose a model provider."
print_blank
print_info "  1. Select  Ollama  as the provider"
print_info "  2. Set the model to  ${LOCAL_MODEL}"
print_info "  3. Click Save or Confirm"
print_blank
print_info "Dyad will connect to the Ollama model running on your machine."
print_info "No API key required."
print_blank

if ask "Open Dyad now to complete the setup?"; then
    case "$OS" in
        macos)  open -a Dyad 2>/dev/null || print_warn "Could not open Dyad automatically. Find it in your Applications folder." ;;
        debian) dyad &>/dev/null & ;;
    esac
    print_blank
    print_info "Complete the model setup in Dyad, then come back here."
    press_enter_to_continue
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
case "$OS" in
    macos)   CONFIG_LOC="~/Library/Application Support/Dyad/" ;;
    debian)  CONFIG_LOC="~/.config/dyad/" ;;
    *)       CONFIG_LOC="see Dyad documentation" ;;
esac

record_install \
    "Dyad" \
    "$(get_tool_version dyad || echo "installed")" \
    "$INSTALL_METHOD" \
    "$CONFIG_LOC" \
    "No-code"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "Dyad is ready"

print_success "Dyad is installed."
print_blank
print_info "What you can do now:"
print_info "  • Open Dyad and describe an app you want to build"
print_info "  • Use your local ${LOCAL_MODEL} model — free, private, offline"
print_info "  • Iterate by describing changes in plain language"
print_blank
print_info "Guide: docs/surfaces/no-code.md"
print_blank
print_state_file_location
