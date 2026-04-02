#!/usr/bin/env bash
# lib/ui.sh
# Print helpers, colors, and prompts.
# Source this file — do not run it directly.

# Colors — disabled automatically if the terminal doesn't support them
if [ -t 1 ] && command -v tput &>/dev/null && tput colors &>/dev/null; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    BOLD=$(tput bold)
    NC=$(tput sgr0)  # Reset
else
    RED="" GREEN="" YELLOW="" BLUE="" BOLD="" NC=""
fi

# ---------------------------------------------------------------------------
# Print functions
# ---------------------------------------------------------------------------

# A prominent section header
print_header() {
    echo ""
    echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "${BOLD}${BLUE}  $1${NC}"
    echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# A step being taken
print_step() {
    echo "${BOLD}→ $1${NC}"
}

# Something completed successfully
print_success() {
    echo "${GREEN}✓ $1${NC}"
}

# A warning — something to be aware of but not a failure
print_warn() {
    echo "${YELLOW}⚠  $1${NC}"
}

# An error — something went wrong
print_error() {
    echo "${RED}✗ $1${NC}"
}

# Plain informational text, indented
print_info() {
    echo "  $1"
}

# A blank line
print_blank() {
    echo ""
}

# A separator line
print_divider() {
    echo "  ────────────────────────────────────────"
}

# ---------------------------------------------------------------------------
# Prompt functions
# ---------------------------------------------------------------------------

# Ask a yes/no question. Returns 0 (true) for yes, 1 (false) for no.
# Usage: if ask "Do you want to continue?"; then ...
ask() {
    local prompt="$1"
    local response
    echo ""
    printf "${BOLD}%s${NC} [y/n] " "$prompt"
    read -r response
    echo ""
    [[ "$response" =~ ^[Yy]$ ]]
}

# Ask the user to choose from a numbered list.
# Prints the number chosen.
# Usage: choice=$(ask_choice "Which option?" "Option A" "Option B" "Option C")
ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice

    echo ""
    echo "${BOLD}$prompt${NC}"
    echo ""
    for i in "${!options[@]}"; do
        echo "  $((i+1)).  ${options[$i]}"
    done
    echo ""
    printf "  Enter a number: "
    read -r choice
    echo ""
    echo "$choice"
}

# Pause and wait for the user to press Enter before continuing
press_enter_to_continue() {
    echo ""
    printf "  Press Enter to continue..."
    read -r
    echo ""
}
