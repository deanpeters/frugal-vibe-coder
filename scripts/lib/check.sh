#!/usr/bin/env bash
# lib/check.sh
# Check whether tools are installed and get their versions.
# Source this file — do not run it directly.

# Returns the version string for a tool, or empty string if not installed.
# Usage: version=$(get_tool_version ollama)
get_tool_version() {
    local tool="$1"

    case "$tool" in
        brew)
            brew --version 2>/dev/null | head -1
            ;;
        ollama)
            ollama --version 2>/dev/null
            ;;
        opencode)
            opencode --version 2>/dev/null | head -1
            ;;
        code)
            # VS Code — the 'code' CLI command
            code --version 2>/dev/null | head -1
            ;;
        dyad)
            # Dyad is a desktop app — check by application path
            local os
            os=$(detect_os)
            case "$os" in
                macos)
                    [ -d "/Applications/Dyad.app" ] && echo "installed" || echo ""
                    ;;
                debian)
                    command -v dyad &>/dev/null && dyad --version 2>/dev/null || echo ""
                    ;;
                *)
                    echo ""
                    ;;
            esac
            ;;
        *)
            # Generic fallback — just check if the command exists
            command -v "$tool" &>/dev/null && echo "installed" || echo ""
            ;;
    esac
}

# Returns true (0) if the tool is installed, false (1) if not.
# Usage: if is_installed ollama; then ...
is_installed() {
    local tool="$1"
    [ -n "$(get_tool_version "$tool")" ]
}

# Check if an Ollama model has been downloaded.
# Usage: if ollama_model_exists qwen3:8b; then ...
ollama_model_exists() {
    local model="$1"
    ollama list 2>/dev/null | grep -q "^${model}"
}

# Print the current install status of a tool — used in pre-install checks.
# Usage: print_tool_status ollama
print_tool_status() {
    local tool="$1"
    local label="${2:-$tool}"
    local version

    version=$(get_tool_version "$tool")

    if [ -n "$version" ]; then
        print_success "$label is installed  ($version)"
    else
        print_warn "$label is not installed"
    fi
}
