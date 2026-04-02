#!/usr/bin/env bash
# lib/packages.sh
# Detect and use the available package manager.
# Source this file — do not run it directly.

# Returns: brew | apt | none
detect_package_manager() {
    if command -v brew &>/dev/null; then
        echo "brew"
    elif command -v apt &>/dev/null; then
        echo "apt"
    else
        echo "none"
    fi
}

# Returns true when Homebrew manages the given formula.
brew_has_formula() {
    local package="$1"
    command -v brew &>/dev/null && brew list --formula --versions "$package" &>/dev/null
}

# Returns true when Homebrew manages the given cask.
brew_has_cask() {
    local package="$1"
    command -v brew &>/dev/null && brew list --cask --versions "$package" &>/dev/null
}

# Install a package using the available package manager.
# Usage: pkg_install ollama
pkg_install() {
    local package="$1"
    local pm
    pm=$(detect_package_manager)

    case "$pm" in
        brew)
            brew install "$package"
            ;;
        apt)
            sudo apt install -y "$package"
            ;;
        none)
            print_error "No package manager found. Cannot install $package automatically."
            return 1
            ;;
    esac
}

# Install a desktop application (cask) via Homebrew on macOS.
# Falls back gracefully if Homebrew is not available.
pkg_install_cask() {
    local package="$1"

    if command -v brew &>/dev/null; then
        brew install --cask "$package"
    else
        print_warn "Homebrew is not installed — cannot install $package as a cask."
        return 1
    fi
}

# Upgrade an already-installed package.
# Usage: pkg_upgrade ollama
pkg_upgrade() {
    local package="$1"
    local pm
    pm=$(detect_package_manager)

    case "$pm" in
        brew)
            brew upgrade "$package"
            ;;
        apt)
            sudo apt install --only-upgrade -y "$package"
            ;;
        none)
            print_error "No package manager found. Cannot upgrade $package automatically."
            return 1
            ;;
    esac
}

# Run apt update if on a Debian-based system.
# Call this before any apt install to ensure the package list is current.
apt_update_if_needed() {
    if command -v apt &>/dev/null; then
        print_step "Updating package list..."
        sudo apt update -q
    fi
}
