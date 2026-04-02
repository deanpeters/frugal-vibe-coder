#!/usr/bin/env bash
# lib/config.sh
# Load frugal-vibe.conf and validate API keys when needed.
# Source this file — do not run it directly.

# Locate the repo root relative to this lib file
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/../.." && pwd)"
CONFIG_FILE="$REPO_ROOT/frugal-vibe.conf"
CONFIG_LOCAL="$REPO_ROOT/frugal-vibe.conf.local"

# Built-in defaults — these apply if frugal-vibe.conf is missing or incomplete
MODEL_PROVIDER="ollama"
LOCAL_MODEL="qwen3:8b"
PAID_MODEL="claude-haiku-4-5"

# Load settings from frugal-vibe.conf, then from frugal-vibe.conf.local
# (local overrides take precedence over the shared config)
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
    else
        print_warn "frugal-vibe.conf not found — using default settings."
        print_info "Expected location: $CONFIG_FILE"
        echo ""
    fi

    if [ -f "$CONFIG_LOCAL" ]; then
        # shellcheck source=/dev/null
        source "$CONFIG_LOCAL"
    fi
}

# Check that the API key for a paid provider is set in the environment.
# Prints a clear error and returns 1 if it's missing.
# Usage: check_api_key anthropic || exit 1
check_api_key() {
    local provider="$1"

    case "$provider" in
        anthropic)
            if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
                print_error "ANTHROPIC_API_KEY is not set in your environment."
                print_blank
                print_info "To fix this, add the following line to your shell profile:"
                print_blank
                print_info "  Mac/Linux — open ~/.zshrc or ~/.bashrc and add:"
                print_info "    export ANTHROPIC_API_KEY=your-key-here"
                print_blank
                print_info "  Then reload your shell:"
                print_info "    source ~/.zshrc"
                print_blank
                print_info "  Windows — go to:"
                print_info "    System > Advanced system settings > Environment Variables"
                print_info "    Add ANTHROPIC_API_KEY as a new User variable."
                print_blank
                print_info "Or switch back to Ollama by setting MODEL_PROVIDER=ollama"
                print_info "in frugal-vibe.conf."
                return 1
            fi
            ;;
        openai)
            if [ -z "${OPENAI_API_KEY:-}" ]; then
                print_error "OPENAI_API_KEY is not set in your environment."
                print_blank
                print_info "To fix this, add the following line to your shell profile:"
                print_blank
                print_info "  Mac/Linux — open ~/.zshrc or ~/.bashrc and add:"
                print_info "    export OPENAI_API_KEY=your-key-here"
                print_blank
                print_info "  Then reload your shell:"
                print_info "    source ~/.zshrc"
                print_blank
                print_info "  Windows — go to:"
                print_info "    System > Advanced system settings > Environment Variables"
                print_info "    Add OPENAI_API_KEY as a new User variable."
                print_blank
                print_info "Or switch back to Ollama by setting MODEL_PROVIDER=ollama"
                print_info "in frugal-vibe.conf."
                return 1
            fi
            ;;
        ollama)
            # Ollama requires no key — this is always fine
            return 0
            ;;
        *)
            print_warn "Unknown provider: $provider"
            return 1
            ;;
    esac

    return 0
}

# Back up a file before replacing it.
# Prints the backup location so the learner knows how to recover if needed.
backup_file_if_exists() {
    local file_path="$1"
    local label="${2:-$(basename "$file_path")}"
    local backup_path

    if [ ! -f "$file_path" ]; then
        return 0
    fi

    backup_path="${file_path}.bak.$(date '+%Y%m%d-%H%M%S')"
    cp "$file_path" "$backup_path"

    print_info "Backed up your existing ${label} to:"
    print_info "  $backup_path"
}

# Print a summary of the current model configuration
print_config_summary() {
    print_info "Provider:  $MODEL_PROVIDER"
    if [ "$MODEL_PROVIDER" = "ollama" ]; then
        print_info "Model:     $LOCAL_MODEL  (local, free)"
    else
        print_info "Model:     $PAID_MODEL  (paid — requires API key)"
    fi
}
