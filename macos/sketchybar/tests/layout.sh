#!/bin/bash
set -euo pipefail

export CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export MOCK_WORKSPACES=$'Deep Work\nBrowser\n'

# Record the configuration without changing the running bar.
flashspace() {
  [ "$*" = "list-workspaces" ] || return 1
  printf '%s' "$MOCK_WORKSPACES"
}
sketchybar() {
  printf '%s\n' "$*"
}
export -f flashspace sketchybar

output=$(bash "$CONFIG_DIR/sketchybarrc")
assert_contains() {
  if [[ "$output" != *"$1"* ]]; then
    printf 'FAIL: layout missing %s\n' "$1" >&2
    exit 1
  fi
}

assert_contains 'position=top height=40 color=0x00000000 blur_radius=0'
assert_contains 'topmost=window font_smoothing=on shadow=off padding_left=20 padding_right=15'
assert_contains '--add item flashspace.1 left'
assert_contains 'label=Deep Work'
assert_contains 'flashspace workspace --number 1'
assert_contains '--subscribe flashspace.1 flashspace_workspace_change'
assert_contains '--add bracket workspaces flashspace.1 flashspace.2'
assert_contains '--add item front_app left'
assert_contains '--add item clock right'
assert_contains 'click_script=open -a Calendar'
assert_contains '--add item battery right'
assert_contains '--add item volume right'
assert_contains '--add item spotify right'
assert_contains '--add item weather right'
assert_contains 'update_freq=1800'
assert_contains '--subscribe weather system_woke'

export MOCK_WORKSPACES=''
output=$(bash "$CONFIG_DIR/sketchybarrc")
if [[ "$output" == *'--add bracket workspaces'* ]]; then
  printf 'FAIL: empty workspace list created a bracket\n' >&2
  exit 1
fi
printf 'PASS: floating layout, workspace integration, and widgets\n'
