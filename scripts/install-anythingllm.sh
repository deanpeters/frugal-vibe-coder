#!/usr/bin/env bash
# install-anythingllm.sh
# Install AnythingLLM — a desktop app for asking questions about your documents.
#
# Usage:
#   ./scripts/install-anythingllm.sh
#
# What this does:
#   1. Checks if AnythingLLM is already installed
#   2. Opens the download page if it isn't
#   3. Waits for you to complete the install
#   4. Guides you through connecting to Ollama
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
print_header "AnythingLLM — Document Q&A"

print_info "AI chat works well for general questions — but what about your own documents?"
print_info "AnythingLLM lets you upload your files (PRDs, research reports, specs, notes)"
print_info "and ask questions about them, using your local Ollama model to answer."
print_blank
print_info "Everything stays on your machine. No cloud upload. No API cost."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "AnythingLLM needs Ollama to run AI features locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here so you don't end up with a half-configured setup."
        print_info "Run ./scripts/install-anythingllm.sh again after Ollama is installed."
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

# Detect AnythingLLM across possible install locations
anythingllm_is_installed() {
    case "$(detect_os)" in
        macos)
            [ -d "/Applications/AnythingLLM.app" ] || [ -d "$HOME/Applications/AnythingLLM.app" ]
            ;;
        debian)
            command -v anythingllm &>/dev/null || command -v anythinglm &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

if anythingllm_is_installed; then
    print_success "AnythingLLM is already installed"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Open AnythingLLM to check for updates manually" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing AnythingLLM installation."
            ;;
        2)
            print_step "Opening AnythingLLM..."
            case "$OS" in
                macos)
                    if [ -d "/Applications/AnythingLLM.app" ]; then
                        open -a "AnythingLLM" 2>/dev/null || \
                            open "/Applications/AnythingLLM.app" 2>/dev/null
                    else
                        open "$HOME/Applications/AnythingLLM.app" 2>/dev/null
                    fi
                    ;;
                debian)
                    anythingllm &>/dev/null & disown 2>/dev/null || \
                        anythinglm &>/dev/null & disown 2>/dev/null || true
                    ;;
            esac
            print_info "Check the AnythingLLM interface for update options."
            press_enter_to_continue
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "AnythingLLM is not installed."
    print_blank

    if ! ask "Install AnythingLLM now?"; then
        print_info "Skipping AnythingLLM install."
        print_info "You can install it later by running: ./scripts/install-anythingllm.sh"
        exit 0
    fi

    print_step "Opening the AnythingLLM download page..."
    print_blank

    case "$OS" in
        macos)
            open "https://anythingllm.com/download" 2>/dev/null || \
                print_info "Visit https://anythingllm.com/download to download AnythingLLM."
            print_blank
            print_info "Download the macOS installer (.dmg) and follow these steps:"
            print_info "  1. Open the downloaded .dmg file"
            print_info "  2. Drag AnythingLLM to your Applications folder"
            print_info "  3. Open AnythingLLM from your Applications folder"
            print_blank
            print_info "macOS may show a security warning on first launch."
            print_info "If it does: go to System Settings → Privacy & Security → Open Anyway"
            print_blank

            if ! wait_for_path_install "/Applications/AnythingLLM.app" "AnythingLLM"; then
                print_info "Also checking ~/Applications..."
                if ! wait_for_path_install "$HOME/Applications/AnythingLLM.app" "AnythingLLM"; then
                    print_info "Stopping here for now. Run ./scripts/install-anythingllm.sh again when ready."
                    exit 0
                fi
            fi
            ;;
        debian)
            xdg-open "https://anythingllm.com/download" 2>/dev/null || \
                print_info "Visit https://anythingllm.com/download to download AnythingLLM."
            print_blank
            print_info "Download the Linux installer (.deb) and install it with:"
            print_info "  sudo apt install ./AnythingLLM-*.deb"
            print_blank
            print_info "Or download the AppImage, make it executable, and run it:"
            print_info "  chmod +x AnythingLLM-*.AppImage"
            print_info "  ./AnythingLLM-*.AppImage"
            print_blank

            if ! wait_for_tool_install anythingllm "AnythingLLM"; then
                print_info "Stopping here for now. Run ./scripts/install-anythingllm.sh again when ready."
                exit 0
            fi
            ;;
        *)
            print_error "Unsupported platform. Visit https://anythingllm.com/download to download AnythingLLM."
            exit 1
            ;;
    esac

    print_success "AnythingLLM installation complete."
    INSTALL_METHOD="manual download"
fi

# ---------------------------------------------------------------------------
# Connection guidance
# ---------------------------------------------------------------------------
print_blank
print_header "Connect AnythingLLM to Ollama"

print_info "When you open AnythingLLM for the first time, it will walk you through setup."
print_blank
print_info "When it asks you to choose a model provider:"
print_info "  1. Select  Ollama  as the LLM provider"
print_info "  2. Set the Ollama URL to:  http://localhost:11434"
print_info "  3. Set the model to:  ${LOCAL_MODEL}"
print_info "  4. Click Save"
print_blank
print_info "To use document Q&A:"
print_info "  1. Create a workspace"
print_info "  2. Upload documents (PDFs, text files, Word docs) to the workspace"
print_info "  3. Ask questions about your documents in the chat"
print_blank

if ask "Open AnythingLLM now to complete the setup?"; then
    case "$OS" in
        macos)
            open -a "AnythingLLM" 2>/dev/null || \
                open "/Applications/AnythingLLM.app" 2>/dev/null || \
                open "$HOME/Applications/AnythingLLM.app" 2>/dev/null || \
                print_warn "Could not open AnythingLLM automatically. Find it in your Applications folder."
            ;;
        debian)
            anythingllm &>/dev/null & disown 2>/dev/null || \
                anythinglm &>/dev/null & disown 2>/dev/null || true
            ;;
    esac
    print_blank
    print_info "Complete the setup in AnythingLLM, then come back here."
    press_enter_to_continue
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
case "$OS" in
    macos)   CONFIG_LOC="~/Library/Application Support/anythingllm-desktop/" ;;
    debian)  CONFIG_LOC="~/.config/anythingllm-desktop/" ;;
    *)       CONFIG_LOC="see AnythingLLM documentation" ;;
esac

record_install \
    "AnythingLLM" \
    "installed" \
    "$INSTALL_METHOD" \
    "$CONFIG_LOC" \
    "No-code"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "AnythingLLM is ready"

print_success "AnythingLLM is installed."
print_blank
print_info "What you can do now:"
print_info "  • Upload documents to a workspace"
print_info "  • Ask questions about your files using ${LOCAL_MODEL}"
print_info "  • Create multiple workspaces for different projects"
print_blank
print_info "Guide: docs/setup/anythingllm.md"
print_blank
print_state_file_location
