#!/bin/bash

. "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

workspace="${WORKSPACE:-$(flashspace get-workspace)}"

if [ "$1" = "$workspace" ]; then
  sketchybar --set "$NAME" label.color="$TEXT_COLOR" background.border_color="$MUTED_COLOR"
else
  sketchybar --set "$NAME" label.color="$MUTED_COLOR" background.border_color="$BORDER_COLOR"
fi
