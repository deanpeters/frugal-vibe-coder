#!/usr/bin/env bash
# test-ui.sh
# Small smoke tests for shell prompt helpers.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running UI smoke tests..."

output=$(
    printf '1\n' | bash -lc '
        source "'"$SCRIPT_DIR"'/lib/ui.sh"
        choice=$(ask_choice "Pick one" "A" "B")
        printf "choice=%s\n" "$choice"
    ' 2>&1
)

if ! printf '%s\n' "$output" | grep -q "Pick one"; then
    echo "FAIL: ask_choice prompt was not shown."
    exit 1
fi

if ! printf '%s\n' "$output" | grep -q "1\\.  A"; then
    echo "FAIL: ask_choice option 1 was not shown."
    exit 1
fi

if ! printf '%s\n' "$output" | grep -q "2\\.  B"; then
    echo "FAIL: ask_choice option 2 was not shown."
    exit 1
fi

if ! printf '%s\n' "$output" | grep -q "Enter a number:"; then
    echo "FAIL: ask_choice input prompt was not shown."
    exit 1
fi

if ! printf '%s\n' "$output" | grep -q "^choice=1$"; then
    echo "FAIL: ask_choice did not return the expected selection."
    exit 1
fi

echo "PASS: ask_choice shows the prompt and returns the selected value."
