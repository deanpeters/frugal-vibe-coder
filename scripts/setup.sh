#!/usr/bin/env bash
# setup.sh
# Main entry point for setting up frugal-vibe-coder on macOS and Linux.
#
# Usage:
#   ./scripts/setup.sh
#
# This script walks you through installing everything in the recommended order:
#   1. Package manager (if not already present)
#   2. Ollama + default model
#   3. Your chosen learning surface(s): Dyad, OpenCode, VS Code
#
# Windows users: use scripts/setup.ps1 in PowerShell instead.

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
# Welcome
# ---------------------------------------------------------------------------
clear
print_header "frugal-vibe-coder setup"

print_info "This script sets up your local AI-assisted learning environment."
print_info "It will check what you already have, explain each step, and ask"
print_info "before making any changes."
print_blank
print_info "Nothing will be installed without your confirmation."
print_blank
print_info "Current model configuration:"
print_config_summary
print_blank
print_info "To change your model or provider, edit frugal-vibe.conf in this repo,"
print_info "then run this script again."
print_blank
print_setup_resume_message

press_enter_to_continue

# ---------------------------------------------------------------------------
# Platform check
# ---------------------------------------------------------------------------
require_supported_platform
OS=$(detect_os)
NEXT_STEP=$(get_setup_next_step)

# ---------------------------------------------------------------------------
# Step 1 — Package manager
# ---------------------------------------------------------------------------
if [ "$NEXT_STEP" = "package_manager" ]; then
    mark_setup_step_started "package_manager"

    print_header "Step 1 of 4 — Package Manager"

    print_info "A package manager installs, updates, and removes software from a single"
    print_info "command. Using one makes this setup cleaner and easier to maintain."
    print_blank
    print_info "Not sure what this is? Read: docs/concepts/what-is-a-package-manager.md"
    print_blank

    PM=$(detect_package_manager)

    case "$OS" in
        macos)
            if [ "$PM" = "brew" ]; then
                print_success "Homebrew is already installed."
                print_info "We'll use it for all installations."
            else
                print_warn "Homebrew is not installed."
                print_blank
                if ask "Install Homebrew? (recommended)"; then
                    print_step "Installing Homebrew..."
                    run_with_status "Installing Homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    print_success "Homebrew installed."

                    # Add Homebrew to PATH for Apple Silicon Macs
                    if [ "$(detect_arch)" = "arm64" ]; then
                        eval "$(/opt/homebrew/bin/brew shellenv)"
                    fi
                else
                    print_warn "Continuing without Homebrew. Some tools will be installed via direct download."
                fi
            fi
            ;;
        debian)
            print_success "apt is available (pre-installed on Debian/Ubuntu/Mint)."
            print_step "Refreshing package list..."
            run_with_status "Refreshing the package list" sudo apt update -q
            print_success "Package list updated."
            ;;
    esac

    print_blank
    mark_setup_step_complete "package_manager" "ollama"
    NEXT_STEP="ollama"
fi

# ---------------------------------------------------------------------------
# Step 2 — Ollama
# ---------------------------------------------------------------------------
if [ "$NEXT_STEP" = "ollama" ]; then
    mark_setup_step_started "ollama"

    print_header "Step 2 of 4 — Ollama"

    print_info "Ollama runs AI models locally — free, private, and no internet required"
    print_info "after the initial download."
    print_blank
    print_info "Not sure what this is? Read: docs/concepts/what-is-ollama.md"
    print_blank

    if ask "Set up Ollama now?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"

        if ! is_installed ollama; then
            print_warn "Ollama setup did not finish yet."
            print_info "We'll stop here so you can pick back up at Ollama next time."
            print_info "Your local checkpoint is saved at:"
            print_info "  $PROGRESS_FILE"
            exit 0
        fi
    else
        print_info "Skipping Ollama. The learning surfaces won't have AI without it."
        print_info "You can run ./scripts/install-ollama.sh at any time."
    fi

    print_blank
    mark_setup_step_complete "ollama" "dyad"
    NEXT_STEP="dyad"
fi

# ---------------------------------------------------------------------------
# Step 3 — Learning surfaces
# ---------------------------------------------------------------------------
if [ "$NEXT_STEP" = "dyad" ] || [ "$NEXT_STEP" = "opencode" ] || [ "$NEXT_STEP" = "vscode" ]; then
    print_header "Step 3 of 4 — Learning Surfaces"

    print_info "Choose which surfaces to set up. You can install all three or just one."
    print_info "Each is independent — you don't need all of them to get started."
    print_blank
    print_info "  No-code  (Dyad)      — visual builder, fastest first success"
    print_info "  CLI      (OpenCode)  — terminal agent, more transparency and control"
    print_info "  IDE      (VS Code)   — code editor, long-term transferable skills"
    print_blank
    print_info "Not sure which to start with? Read: docs/surfaces/README.md"
    print_blank
fi

if [ "$NEXT_STEP" = "dyad" ]; then
    mark_setup_step_started "dyad"

    if ask "Set up Dyad (no-code surface)?"; then
        bash "$SCRIPT_DIR/install-dyad.sh"

        if ! is_installed dyad; then
            print_warn "Dyad setup did not finish yet."
            print_info "We'll stop here so you can pick back up at Dyad next time."
            print_info "Your local checkpoint is saved at:"
            print_info "  $PROGRESS_FILE"
            exit 0
        fi
    fi

    print_blank
    mark_setup_step_complete "dyad" "opencode"
    NEXT_STEP="opencode"
fi

if [ "$NEXT_STEP" = "opencode" ]; then
    mark_setup_step_started "opencode"

    if ask "Set up OpenCode (CLI surface)?"; then
        bash "$SCRIPT_DIR/install-opencode.sh"

        if ! is_installed opencode; then
            print_warn "OpenCode setup did not finish yet."
            print_info "We'll stop here so you can pick back up at OpenCode next time."
            print_info "Your local checkpoint is saved at:"
            print_info "  $PROGRESS_FILE"
            exit 0
        fi
    fi

    print_blank
    mark_setup_step_complete "opencode" "vscode"
    NEXT_STEP="vscode"
fi

if [ "$NEXT_STEP" = "vscode" ]; then
    mark_setup_step_started "vscode"

    if ask "Set up VS Code (IDE surface)?"; then
        bash "$SCRIPT_DIR/install-vscode.sh"

        if ! is_installed code; then
            print_warn "VS Code setup did not finish yet."
            print_info "We'll stop here so you can pick back up at VS Code next time."
            print_info "Your local checkpoint is saved at:"
            print_info "  $PROGRESS_FILE"
            exit 0
        fi
    fi

    print_blank
    mark_setup_step_complete "vscode" "paid_models"
    NEXT_STEP="paid_models"
fi

# ---------------------------------------------------------------------------
# Step 4 — Paid model setup (optional)
# ---------------------------------------------------------------------------
if [ "$NEXT_STEP" = "paid_models" ]; then
    mark_setup_step_started "paid_models"

    print_header "Step 4 of 4 — Paid Models (Optional)"

    print_info "Your setup is complete and fully functional using free local models."
    print_blank
    print_info "If you'd like to optionally add a paid model (Anthropic or OpenAI),"
    print_info "you can do that now or at any time by editing frugal-vibe.conf."
    print_blank
    print_info "Paid models are never required. Start with what you have."
    print_blank

    if ask "Set up a paid model API key now?"; then
        print_blank
        choice=$(ask_choice "Which provider?" \
            "Anthropic  (claude-haiku-4-5 — cheapest default)" \
            "OpenAI     (gpt-4o-mini — cheapest default)" \
            "Skip — I'll do this later")

        case "$choice" in
            1)
                print_blank
                print_info "To add your Anthropic API key:"
                print_blank
                print_info "  1. Get a key at: https://console.anthropic.com"
                print_info "  2. Add this line to your ~/.zshrc or ~/.bashrc:"
                print_info "       export ANTHROPIC_API_KEY=your-key-here"
                print_info "  3. Run:  source ~/.zshrc"
                print_info "  4. Edit frugal-vibe.conf and set:"
                print_info "       MODEL_PROVIDER=anthropic"
                print_blank
                print_info "Your key stays in your shell environment — never in any file in this repo."
                ;;
            2)
                print_blank
                print_info "To add your OpenAI API key:"
                print_blank
                print_info "  1. Get a key at: https://platform.openai.com/api-keys"
                print_info "  2. Add this line to your ~/.zshrc or ~/.bashrc:"
                print_info "       export OPENAI_API_KEY=your-key-here"
                print_info "  3. Run:  source ~/.zshrc"
                print_info "  4. Edit frugal-vibe.conf and set:"
                print_info "       MODEL_PROVIDER=openai"
                print_blank
                print_info "Your key stays in your shell environment — never in any file in this repo."
                ;;
            3)
                print_info "No problem — your local Ollama setup is complete and ready to use."
                ;;
        esac
    fi

    mark_setup_step_complete "paid_models" "package_manager"
fi

# ---------------------------------------------------------------------------
# Final summary
# ---------------------------------------------------------------------------
print_header "Setup complete"

print_success "Your frugal-vibe-coder environment is ready."
print_blank
print_info "What you have:"
print_blank

is_installed ollama  && print_success "Ollama — local AI model running on your machine" || print_warn "Ollama — not installed"
is_installed dyad    && print_success "Dyad — no-code surface" || print_info "  Dyad — not installed  (./scripts/install-dyad.sh)"
is_installed opencode && print_success "OpenCode — CLI surface" || print_info "  OpenCode — not installed  (./scripts/install-opencode.sh)"
is_installed code    && print_success "VS Code — IDE surface" || print_info "  VS Code — not installed  (./scripts/install-vscode.sh)"

print_blank
print_info "Where to go next:"
print_info "  • Not sure where to start?  docs/surfaces/README.md"
print_info "  • No-code guide:            docs/surfaces/no-code.md"
print_info "  • CLI guide:                docs/surfaces/cli.md"
print_info "  • IDE guide:                docs/surfaces/ide.md"
print_info "  • Your install log:         docs/reference/my-setup.md"
print_blank
print_state_file_location
clear_setup_progress
