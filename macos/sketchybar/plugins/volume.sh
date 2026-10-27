#!/bin/bash

. "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)') || exit 0
fi

case "$VOLUME" in
  ''|*[!0-9]*) exit 0 ;;
esac

COLOR="$TEXT_COLOR"
case "$VOLUME" in
  [6-9][0-9]|100) ICON="󰕾" ;;
  [3-5][0-9]) ICON="󰖀" ;;
  [1-9]|[1-2][0-9]) ICON="󰕿" ;;
  *) ICON="󰖁"; COLOR="$MUTED_COLOR" ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$VOLUME%"
