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
# Long-running command helpers
# ---------------------------------------------------------------------------

# Print a reassuring status message every few seconds while a command runs.
start_status_heartbeat() {
    local label="$1"
    local interval="${2:-8}"

    (
        local tick=0

        while true; do
            sleep "$interval"

            case $((tick % 4)) in
                0)
                    print_info "${label} is still working..."
                    ;;
                1)
                    print_info "${label} can take a few minutes on some machines."
                    ;;
                2)
                    print_info "If you do not see new output yet, that's okay — the script is still running."
                    ;;
                3)
                    print_info "${label} is still in progress..."
                    ;;
            esac

            tick=$((tick + 1))
        done
    ) &

    STATUS_HEARTBEAT_PID=$!
}

# Stop the background status heartbeat.
stop_status_heartbeat() {
    local pid="${1:-${STATUS_HEARTBEAT_PID:-}}"

    if [ -n "${pid:-}" ]; then
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
    fi

    STATUS_HEARTBEAT_PID=""
}

# Run a command in the foreground while printing periodic reassurance.
run_with_status() {
    local label="$1"
    shift

    local exit_code

    start_status_heartbeat "$label"

    set +e
    "$@"
    exit_code=$?
    set -e

    stop_status_heartbeat

    return "$exit_code"
}

# ---------------------------------------------------------------------------
# Prompt functions
# ---------------------------------------------------------------------------

# Ask a yes/no question. Returns 0 (true) for yes, 1 (false) for no.
# Usage: if ask "Do you want to continue?"; then ...
ask() {
    local prompt="$1"
    local response

    while true; do
        echo ""
        printf "${BOLD}%s${NC} [y/n] " "$prompt"
        read -r response
        echo ""

        response=$(printf '%s' "$response" | tr '[:upper:]' '[:lower:]')

        case "$response" in
            y|yes)
                return 0
                ;;
            n|no)
                return 1
                ;;
            *)
                print_warn "Please type y or n."
                ;;
        esac
    done
}

# Ask the user to choose from a numbered list.
# Prints the number chosen.
# Usage: choice=$(ask_choice "Which option?" "Option A" "Option B" "Option C")
ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice

    while true; do
        echo "" >&2
        echo "${BOLD}$prompt${NC}" >&2
        echo "" >&2
        for i in "${!options[@]}"; do
            echo "  $((i+1)).  ${options[$i]}" >&2
        done
        echo "" >&2
        printf "  Enter a number: " >&2
        read -r choice
        echo "" >&2

        case "$choice" in
            ''|*[!0-9]*)
                print_warn "Please enter a number from the list." >&2
                ;;
            *)
                if [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
                    echo "$choice"
                    return 0
                fi
                print_warn "Please enter a number from the list." >&2
                ;;
        esac
    done
}

# Pause and wait for the user to press Enter before continuing
press_enter_to_continue() {
    local prompt="${1:-Press Enter to continue...}"

    echo ""
    printf "  %s" "$prompt"
    read -r
    echo ""
}
