#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/../plugins" && pwd)"
export CONFIG_DIR="$(dirname "$PLUGIN_DIR")"
. "$CONFIG_DIR/colors.sh"

# Mock both CLIs so these checks never change the running desktop.
flashspace() {
  [ "$*" = "get-workspace" ] || return 1
  printf '%s\n' 'Deep Work'
}
sketchybar() {
  printf '%s\n' "$@"
}
export -f flashspace sketchybar
export NAME="flashspace.test"

assert_style() {
  local active="$1" workspace="$2" color="$3" border="$4"
  local actual expected
  expected=$(printf '%s\n' --set "$NAME" "label.color=$color" "background.border_color=$border")
  actual=$(WORKSPACE="$active" "$PLUGIN_DIR/flashspace.sh" "$workspace")
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: active=%s item=%s\nExpected:\n%s\nActual:\n%s\n' \
      "$active" "$workspace" "$expected" "$actual" >&2
    return 1
  fi
}

assert_style '' 'Deep Work' "$TEXT_COLOR" "$MUTED_COLOR"
assert_style '' Browser "$MUTED_COLOR" "$BORDER_COLOR"
assert_style Coding Coding "$TEXT_COLOR" "$MUTED_COLOR"
assert_style Coding Browser "$MUTED_COLOR" "$BORDER_COLOR"
assert_style 'Deep Work' 'Deep Work' "$TEXT_COLOR" "$MUTED_COLOR"
printf 'PASS: FlashSpace startup, event, deselection, and multiword-name checks\n'
