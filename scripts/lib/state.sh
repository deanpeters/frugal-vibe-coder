#!/usr/bin/env bash
# lib/state.sh
# Write and update docs/reference/my-setup.md — the local install log.
# Source this file — do not run it directly.

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/../.." && pwd)"
STATE_FILE="$REPO_ROOT/docs/reference/my-setup.md"
PROGRESS_FILE="$REPO_ROOT/docs/reference/setup-progress.env"

# Create the state file if it doesn't exist yet
init_state_file() {
    mkdir -p "$(dirname "$STATE_FILE")"

    if [ ! -f "$STATE_FILE" ]; then
        cat > "$STATE_FILE" << EOF
# My Setup

*Generated and updated by frugal-vibe-coder install scripts. Last updated: $(date '+%Y-%m-%d %H:%M')*

---

EOF
        return
    fi

    # Update the last-updated timestamp if the file already exists
    local date_str
    date_str=$(date '+%Y-%m-%d %H:%M')
    local tmp_file
    tmp_file=$(mktemp)

    awk -v date="$date_str" '{
        sub(/Last updated: .*\*/, "Last updated: " date "*")
        print
    }' "$STATE_FILE" > "$tmp_file"

    mv "$tmp_file" "$STATE_FILE"
}

# Write or replace a named section in the state file.
# Usage: write_state_section "Ollama" "| Version | 0.3.1 |\n..."
write_state_section() {
    local section_name="$1"
    local content="$2"

    init_state_file

    local tmp_file
    tmp_file=$(mktemp)

    # Use awk to remove the existing section (if present) then append the new one
    awk -v section="## $section_name" '
        BEGIN { in_section=0; done=0 }
        /^## / {
            if (in_section) { in_section=0 }
            if ($0 == section) { in_section=1; next }
        }
        !in_section { print }
    ' "$STATE_FILE" > "$tmp_file"

    # Append the new section
    {
        echo ""
        echo "## $section_name"
        echo ""
        echo -e "$content"
        echo ""
    } >> "$tmp_file"

    mv "$tmp_file" "$STATE_FILE"
}

# Convenience: record a tool install in the state file
# Usage: record_install "Ollama" "0.3.1" "brew" "~/.ollama/" "All surfaces"
record_install() {
    local tool="$1"
    local version="$2"
    local method="$3"
    local config_location="$4"
    local surfaces="$5"

    local content
    content="| Item | Value |
|------|-------|
| Version | $version |
| Installed via | $method |
| Config location | \`$config_location\` |
| Surfaces supported | $surfaces |"

    write_state_section "$tool" "$content"

    print_info "Install recorded in docs/reference/my-setup.md"
}

# Print the path to the state file so the user knows where to find it
print_state_file_location() {
    print_blank
    print_info "Your install log has been updated:"
    print_info "  $STATE_FILE"
    print_blank
}

# ---------------------------------------------------------------------------
# Setup progress checkpoints
# ---------------------------------------------------------------------------

setup_progress_exists() {
    [ -f "$PROGRESS_FILE" ]
}

write_setup_progress_file() {
    local current_step="$1"
    local last_completed_step="$2"
    local next_step="$3"

    mkdir -p "$(dirname "$PROGRESS_FILE")"

    cat > "$PROGRESS_FILE" << EOF
# Local progress checkpoint for scripts/setup.sh
CURRENT_STEP=$current_step
LAST_COMPLETED_STEP=$last_completed_step
NEXT_STEP=$next_step
UPDATED_AT=$(date '+%Y-%m-%d %H:%M')
EOF
}

read_setup_progress_value() {
    local key="$1"

    if [ ! -f "$PROGRESS_FILE" ]; then
        return 1
    fi

    awk -F= -v key="$key" '$1 == key { print substr($0, index($0, "=") + 1); exit }' "$PROGRESS_FILE"
}

get_setup_current_step() {
    read_setup_progress_value "CURRENT_STEP" 2>/dev/null || true
}

get_setup_last_completed_step() {
    read_setup_progress_value "LAST_COMPLETED_STEP" 2>/dev/null || true
}

get_setup_next_step() {
    local next_step
    next_step=$(read_setup_progress_value "NEXT_STEP" 2>/dev/null || true)

    if [ -n "$next_step" ]; then
        echo "$next_step"
    else
        echo "package_manager"
    fi
}

describe_setup_step() {
    case "$1" in
        package_manager) echo "Step 1 of 4 — Package Manager" ;;
        ollama)          echo "Step 2 of 4 — Ollama" ;;
        dyad)            echo "Step 3 of 4 — Dyad" ;;
        opencode)        echo "Step 3 of 4 — OpenCode" ;;
        vscode)          echo "Step 3 of 4 — VS Code" ;;
        paid_models)     echo "Step 4 of 4 — Paid Models" ;;
        *)               echo "$1" ;;
    esac
}

mark_setup_step_started() {
    local step="$1"
    local last_completed_step
    last_completed_step=$(get_setup_last_completed_step)
    write_setup_progress_file "$step" "$last_completed_step" "$step"
}

mark_setup_step_complete() {
    local completed_step="$1"
    local next_step="$2"
    write_setup_progress_file "" "$completed_step" "$next_step"
}

clear_setup_progress() {
    rm -f "$PROGRESS_FILE"
}

print_setup_resume_message() {
    local next_step
    next_step=$(get_setup_next_step)

    if ! setup_progress_exists || [ "$next_step" = "package_manager" ]; then
        return 0
    fi

    print_info "I found a previous setup session that did not finish."
    print_info "We'll continue from: $(describe_setup_step "$next_step")"
    print_info "Your local checkpoint is saved at:"
    print_info "  $PROGRESS_FILE"
    print_blank
}
