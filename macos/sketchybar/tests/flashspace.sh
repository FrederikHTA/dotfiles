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
  local active="$1" workspace="$2" actual expected
  shift 2
  expected=$(printf '%s\n' --set "$NAME" "$@")
  actual=$(WORKSPACE="$active" "$PLUGIN_DIR/flashspace.sh" "$workspace")
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: active=%s item=%s\nExpected:\n%s\nActual:\n%s\n' \
      "$active" "$workspace" "$expected" "$actual" >&2
    return 1
  fi
}

assert_style '' 'Deep Work' "label.color=$ACTIVE_TEXT_COLOR" background.drawing=on "background.color=$TEXT_COLOR"
assert_style '' Browser "label.color=$MUTED_COLOR" background.drawing=off
assert_style Coding Coding "label.color=$ACTIVE_TEXT_COLOR" background.drawing=on "background.color=$TEXT_COLOR"
assert_style Coding Browser "label.color=$MUTED_COLOR" background.drawing=off
assert_style 'Deep Work' 'Deep Work' "label.color=$ACTIVE_TEXT_COLOR" background.drawing=on "background.color=$TEXT_COLOR"
printf 'PASS: FlashSpace startup, event, deselection, and multiword-name checks\n'
