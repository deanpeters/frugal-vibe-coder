#!/usr/bin/env bash
# install-vscode.sh
# Install VS Code and set it up with the Continue extension for local AI assistance.
#
# Usage:
#   ./scripts/install-vscode.sh
#
# What this does:
#   1. Checks if VS Code is already installed
#   2. Offers to install, or skip
#   3. Installs the Continue extension (connects VS Code to Ollama)
#   4. Creates a workspace config pointing to your local model
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
print_header "VS Code — IDE Surface"

print_info "At some point you'll want to look at the code an AI generated, understand it,"
print_info "and make targeted changes. VS Code is where generated code becomes understood code."
print_blank
print_info "This script installs VS Code and the Continue extension — the AI assistant"
print_info "that connects VS Code to your local Ollama model."
print_blank

# ---------------------------------------------------------------------------
# Check prerequisite: Ollama
# ---------------------------------------------------------------------------
if ! is_installed ollama; then
    print_warn "Ollama is not installed."
    print_info "VS Code's AI features need Ollama to work locally."
    print_info "Install Ollama first: ./scripts/install-ollama.sh"
    print_blank
    if ask "Install Ollama now before continuing?"; then
        bash "$SCRIPT_DIR/install-ollama.sh"
    fi

    if ! is_installed ollama; then
        print_info "Stopping here so you don't end up with a half-configured setup."
        print_info "Run ./scripts/install-vscode.sh again after Ollama is installed."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Check current state
# ---------------------------------------------------------------------------
print_step "Checking your current setup..."
print_blank

OS=$(detect_os)
VSCODE_VERSION=$(get_tool_version code)
INSTALL_METHOD="existing"
CONTINUE_STATUS="Continue config left unchanged."
EXTENSION_STATUS="Continue extension still needs to be installed."
CONTINUE_STATE_CONTENT="| Item | Value |
|------|-------|
| Extension ID | continue.continue |
| Config location | \`$HOME/.continue/config.json\` |
| Status | Existing config left unchanged |"

if [ -n "$VSCODE_VERSION" ]; then
    print_success "VS Code is already installed  ($VSCODE_VERSION)"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Use the current version and continue to extension setup" \
        "Update VS Code  (opens VS Code — use Help > Check for Updates)" \
        "Exit without making changes")

    case "$choice" in
        1)
            print_info "Using existing VS Code installation."
            ;;
        2)
            case "$OS" in
                macos)
                    if command -v brew &>/dev/null; then
                        brew upgrade --cask visual-studio-code
                        INSTALL_METHOD="Homebrew Cask"
                    else
                        open -a "Visual Studio Code" 2>/dev/null
                        print_info "Go to Help > Check for Updates in VS Code."
                        press_enter_to_continue
                        INSTALL_METHOD="existing"
                    fi
                    ;;
                debian)
                    sudo apt install --only-upgrade -y code
                    INSTALL_METHOD="apt"
                    ;;
            esac
            print_success "VS Code updated."
            ;;
        3)
            print_info "Exiting. No changes made."
            exit 0
            ;;
    esac
else
    print_warn "VS Code is not installed."
    print_blank

    if ! ask "Install VS Code now?"; then
        print_info "Skipping VS Code install."
        print_info "You can install it later by running: ./scripts/install-vscode.sh"
        exit 0
    fi

    print_step "Installing VS Code..."
    print_blank

    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                print_info "Using Homebrew..."
                brew install --cask visual-studio-code
                INSTALL_METHOD="Homebrew Cask"
            else
                print_info "Opening the VS Code download page..."
                open "https://code.visualstudio.com/download" 2>/dev/null || \
                    print_info "Visit https://code.visualstudio.com/download to download VS Code."
                print_blank
                print_info "Download the .dmg, open it, and drag VS Code to your Applications folder."
                if ! wait_for_path_install "/Applications/Visual Studio Code.app" "VS Code"; then
                    print_info "Stopping here for now. Run ./scripts/install-vscode.sh again when you're ready."
                    exit 0
                fi
                INSTALL_METHOD="manual download"
            fi
            ;;
        debian)
            print_info "Adding the Microsoft package repository and installing VS Code..."
            sudo apt install -y software-properties-common apt-transport-https curl
            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
            sudo apt update -q
            sudo apt install -y code
            INSTALL_METHOD="apt"
            ;;
        *)
            print_error "Unsupported platform. Visit https://code.visualstudio.com to download VS Code."
            exit 1
            ;;
    esac

    print_success "VS Code installed."
fi

# ---------------------------------------------------------------------------
# Enable the 'code' command on macOS if needed
# ---------------------------------------------------------------------------
if [ "$OS" = "macos" ] && ! command -v code &>/dev/null; then
    print_blank
    print_step "Enabling the 'code' terminal command..."
    print_blank
    print_info "VS Code needs to install its terminal command."
    print_info "We'll open VS Code and walk you through a quick step."
    print_blank

    open -a "Visual Studio Code" 2>/dev/null

    print_info "In VS Code:"
    print_info "  1. Press Cmd+Shift+P to open the command palette"
    print_info "  2. Type: shell command"
    print_info "  3. Select: Shell Command: Install 'code' command in PATH"
    print_blank
    print_info "Then close and reopen your terminal for the change to take effect."
    press_enter_to_continue
fi

# ---------------------------------------------------------------------------
# Install the Continue extension
# ---------------------------------------------------------------------------
print_blank
print_header "Continue Extension"

print_info "Continue is the AI assistant that connects VS Code to your local Ollama model."
print_info "It adds a chat panel and inline suggestions — all running on your machine."
print_blank

if command -v code &>/dev/null; then
    print_step "Installing the Continue extension..."
    code --install-extension continue.continue --force

    if code --list-extensions 2>/dev/null | grep -q "continue.continue"; then
        print_success "Continue extension installed."
        EXTENSION_STATUS="Continue extension is installed."
    else
        print_warn "Could not confirm Continue was installed."
        print_info "Install it manually: open VS Code, go to Extensions (Cmd+Shift+X),"
        print_info "search for 'Continue', and click Install."
    fi
else
    print_warn "The 'code' command is not available — skipping automatic extension install."
    print_info "After installing VS Code, install the Continue extension manually:"
    print_info "  Open VS Code > Extensions (Cmd+Shift+X) > search 'Continue' > Install"
fi

# ---------------------------------------------------------------------------
# Configure Continue to use Ollama
# ---------------------------------------------------------------------------
print_blank
print_step "Configuring Continue to use Ollama (${LOCAL_MODEL})..."

CONTINUE_CONFIG_DIR="$HOME/.continue"
CONTINUE_CONFIG="$CONTINUE_CONFIG_DIR/config.json"

mkdir -p "$CONTINUE_CONFIG_DIR"

if [ -f "$CONTINUE_CONFIG" ]; then
    print_info "A Continue config already exists at $CONTINUE_CONFIG"
    print_blank

    choice=$(ask_choice "What would you like to do?" \
        "Keep the existing config unchanged" \
        "Replace it with the default Ollama config for this repo")

    if [ "$choice" = "2" ]; then
        backup_file_if_exists "$CONTINUE_CONFIG" "Continue config"
        cat > "$CONTINUE_CONFIG" << EOF
{
  "models": [
    {
      "title": "${LOCAL_MODEL} (local)",
      "provider": "ollama",
      "model": "${LOCAL_MODEL}"
    }
  ],
  "tabAutocompleteModel": {
    "title": "${LOCAL_MODEL} (local)",
    "provider": "ollama",
    "model": "${LOCAL_MODEL}"
  }
}
EOF
        print_success "Continue config updated."
        CONTINUE_STATUS="Continue is configured to use ${LOCAL_MODEL} via Ollama."
        CONTINUE_STATE_CONTENT="| Item | Value |
|------|-------|
| Extension ID | continue.continue |
| Config location | \`$CONTINUE_CONFIG\` |
| Provider | ollama |
| Model | ${LOCAL_MODEL} |"
    fi
else
    cat > "$CONTINUE_CONFIG" << EOF
{
  "models": [
    {
      "title": "${LOCAL_MODEL} (local)",
      "provider": "ollama",
      "model": "${LOCAL_MODEL}"
    }
  ],
  "tabAutocompleteModel": {
    "title": "${LOCAL_MODEL} (local)",
    "provider": "ollama",
    "model": "${LOCAL_MODEL}"
  }
}
EOF
    print_success "Continue config created at $CONTINUE_CONFIG"
    CONTINUE_STATUS="Continue is configured to use ${LOCAL_MODEL} via Ollama."
    CONTINUE_STATE_CONTENT="| Item | Value |
|------|-------|
| Extension ID | continue.continue |
| Config location | \`$CONTINUE_CONFIG\` |
| Provider | ollama |
| Model | ${LOCAL_MODEL} |"
fi

# ---------------------------------------------------------------------------
# Record install
# ---------------------------------------------------------------------------
case "$OS" in
    macos)  VSCODE_CONFIG="~/Library/Application Support/Code/User/settings.json" ;;
    debian) VSCODE_CONFIG="~/.config/Code/User/settings.json" ;;
    *)      VSCODE_CONFIG="see VS Code documentation" ;;
esac

VSCODE_VERSION=$(get_tool_version code || echo "installed")

record_install \
    "VS Code" \
    "$VSCODE_VERSION" \
    "$INSTALL_METHOD" \
    "$VSCODE_CONFIG" \
    "IDE"

write_state_section "Continue (VS Code extension)" "$CONTINUE_STATE_CONTENT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_header "VS Code is ready"

print_success "VS Code is installed."
print_info "$EXTENSION_STATUS"
print_info "$CONTINUE_STATUS"
print_blank
print_info "To get started:"
print_info "  1. Open VS Code"
print_info "  2. Click the Continue panel on the left sidebar"
print_info "  3. Ask a question about anything you're building"
print_blank
print_info "Guide: docs/surfaces/ide.md"
print_blank
print_state_file_location
