#!/usr/bin/env bash
# lib/platform.sh
# Detect the current operating system and CPU architecture.
# Source this file — do not run it directly.

# Returns: macos | debian | unknown
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ -f /etc/debian_version ]; then
                echo "debian"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Returns: arm64 | x86_64 | unknown
detect_arch() {
    case "$(uname -m)" in
        arm64|aarch64)
            echo "arm64"
            ;;
        x86_64|amd64)
            echo "x86_64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Exits with an error if the platform is not supported
require_supported_platform() {
    local os
    os=$(detect_os)

    if [ "$os" = "unknown" ]; then
        print_error "This script supports macOS and Debian/Ubuntu/Mint Linux."
        print_info  "For Windows, use scripts/setup.ps1 in PowerShell."
        exit 1
    fi

    if [ "$os" = "linux" ] && [ ! -f /etc/debian_version ]; then
        print_warn "This Linux distribution is not officially supported."
        print_info "These scripts are tested on Debian, Ubuntu, and Mint."
        print_info "You can continue, but some steps may need adjustment."
        echo ""
        if ! ask "Continue anyway?"; then
            exit 0
        fi
    fi
}
