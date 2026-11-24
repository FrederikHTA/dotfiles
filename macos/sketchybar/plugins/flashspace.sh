#!/bin/bash

. "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

workspace="${WORKSPACE:-$(flashspace get-workspace)}"

if [ "$1" = "$workspace" ]; then
  sketchybar --set "$NAME" label.color="$ACTIVE_TEXT_COLOR" \
    background.drawing=on background.color="$TEXT_COLOR"
else
  sketchybar --set "$NAME" label.color="$MUTED_COLOR" background.drawing=off
fi
