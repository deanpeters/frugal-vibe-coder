#!/usr/bin/env bash
# lib/state.sh
# Write and update docs/reference/my-setup.md — the local install log.
# Source this file — do not run it directly.

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/../.." && pwd)"
STATE_FILE="$REPO_ROOT/docs/reference/my-setup.md"

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
