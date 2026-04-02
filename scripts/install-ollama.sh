#!/usr/bin/env bash
# install-ollama.sh
# Install Ollama and download the default local model.
#
# Usage:
#   ./scripts/install-ollama.sh
#
# What this does:
#   1. Checks if Ollama is already installed
#   2. Offers to install, update, or skip
#   3. Pulls the default model (qwen3:8b) if not already downloaded
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
print_header "Ollama"

print_info "Most AI tools send your questions to a server on the internet — they"
print_info "charge per query and your data leaves your machine. Ollama is different:"
print_info "it runs AI models directly on your computer, free and private."
print_blank
print_info "This script will install Ollama and download the default model (${LOCAL_MODEL})."
print_info "The model download is about 5 GB — make sure you're on a good connection."
print_blank

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OLLAMA_VERSION=$(get_tool_version ollama)
OS=$(detect_os)
INSTALL_METHOD="existing"

if [ -n "$OLLAMA_VERSION" ]; then
    print_success "Ollama is already installed  ($OLLAMA_VERSION)"
    print_info "Next, choose whether to keep this version, update it, or stop here."
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue" \
        "Update Ollama to the latest version" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing Ollama installation."
            ;;
        2)
            print_step "Updating Ollama..."
            case "$OS" in
                macos)
                    if command -v brew &>/dev/null; then
                        run_with_status "Updating Ollama" brew upgrade ollama || print_warn "Update failed — continuing with current version."
                        INSTALL_METHOD="Homebrew"
                    else
                        print_warn "Homebrew not found. We'll switch to the manual update path."
                        print_info "Opening the Ollama download page in your browser..."
                        open "https://ollama.com/download/mac" 2>/dev/null || \
                            print_info "Visit https://ollama.com/download to download Ollama manually."
                        print_blank
                        print_info "Download the installer, run it, then come back here."
                        if ! wait_for_tool_install ollama "Ollama"; then
                            print_info "Stopping here for now. Run ./scripts/install-ollama.sh again when you're ready."
                            exit 0
                        fi
                        INSTALL_METHOD="manual download"
                    fi
                    ;;
                debian)
                    run_with_status "Updating Ollama" sh -c 'curl -fsSL https://ollama.com/install.sh | sh'
                    INSTALL_METHOD="install.sh"
                    ;;
            esac
            print_success "Ollama updated."
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
        *)
            print_warn "Unrecognised choice — using existing installation."
            ;;
    esac
else
    print_warn "Ollama is not installed."
    print_blank

    if ! ask "Install Ollama now?"; then
        print_info "Skipping Ollama install."
        print_info "You can install it later by running: ./scripts/install-ollama.sh"
        exit 0
    fi

    # Install Ollama
    print_step "Installing Ollama..."
    print_blank

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                print_info "Using Homebrew..."
                run_with_status "Installing Ollama" brew install ollama
                INSTALL_METHOD="Homebrew"
            else
                print_info "Downloading from ollama.com..."
                print_warn "Homebrew is not installed — installing directly from ollama.com."
                print_info "Consider installing Homebrew for easier updates: https://brew.sh"
                print_blank
                # Direct download — open the download page since we can't automate a .dmg install cleanly
                print_info "Opening the Ollama download page in your browser..."
                open "https://ollama.com/download/mac" 2>/dev/null || \
                    print_info "Visit https://ollama.com/download to download Ollama manually."
                print_blank
                print_info "Download the installer, run it, then come back here."
                if ! wait_for_tool_install ollama "Ollama"; then
                    print_info "Stopping here for now. Run ./scripts/install-ollama.sh again when you're ready."
                    exit 0
                fi
                INSTALL_METHOD="manual download"
            fi
            ;;
        debian)
            print_info "Downloading and running the official Ollama install script..."
            run_with_status "Installing Ollama" sh -c 'curl -fsSL https://ollama.com/install.sh | sh'
            INSTALL_METHOD="install.sh"
            ;;
        *)
            print_error "Unsupported platform. Visit https://ollama.com/download for instructions."
            exit 1
            ;;
    esac

    print_success "Ollama installed."
fi

# ---------------------------------------------------------------------------
# Pull the model
# ---------------------------------------------------------------------------
print_blank
print_step "Checking for model: ${LOCAL_MODEL}..."
print_blank

if ollama_model_exists "$LOCAL_MODEL"; then
    print_success "Model ${LOCAL_MODEL} is already downloaded."
else
    print_info "Model ${LOCAL_MODEL} is not downloaded yet."
    print_info "This is about 5 GB and may take several minutes."
    print_blank

    if ask "Download ${LOCAL_MODEL} now?"; then
        print_step "Pulling ${LOCAL_MODEL}..."
        print_info "You should see model download progress below."
        print_info "If it pauses briefly, it may still be downloading or unpacking files."
        print_blank
        run_with_status "Downloading ${LOCAL_MODEL}" ollama pull "$LOCAL_MODEL"
        print_success "Model ${LOCAL_MODEL} downloaded."
    else
        print_warn "Model not downloaded. You can download it later with:"
        print_info "  ollama pull ${LOCAL_MODEL}"
    fi
fi

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
print_blank
print_step "Verifying Ollama is running..."

if ! ollama list &>/dev/null; then
    print_warn "Ollama doesn't appear to be running. Starting it now..."
    case "$OS" in
        macos)
            open -a Ollama 2>/dev/null || ollama serve &>/dev/null &
            sleep 3
            ;;
        debian)
            ollama serve &>/dev/null &
            sleep 3
            ;;
    esac
fi

if ollama list &>/dev/null; then
    print_success "Ollama is running and ready."
else
    print_warn "Could not confirm Ollama is running."
    print_info "Try running 'ollama serve' in a separate terminal window."
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
OLLAMA_VERSION=$(get_tool_version ollama)
CONFIG_LOCATION="\$HOME/.ollama/"

record_install \
    "Ollama" \
    "${OLLAMA_VERSION:-unknown}" \
    "$INSTALL_METHOD" \
    "$CONFIG_LOCATION" \
    "No-code (Dyad), CLI (OpenCode), IDE (VS Code)"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "Ollama is ready"

print_success "Ollama is installed and running."
if ollama_model_exists "$LOCAL_MODEL"; then
    print_success "Model ${LOCAL_MODEL} is downloaded and ready to use."
fi
print_blank
print_info "Every query runs on your machine — free, private, and available offline."
print_blank
print_info "What this unlocks:"
print_info "  • Dyad (no-code builder) can use your local model"
print_info "  • OpenCode (CLI agent) can use your local model"
print_info "  • VS Code + Continue can use your local model"
print_blank
print_info "Next step — install a learning surface:"
print_info "  No-code:  ./scripts/install-dyad.sh"
print_info "  CLI:      ./scripts/install-opencode.sh"
print_info "  IDE:      ./scripts/install-vscode.sh"
print_blank
print_state_file_location
