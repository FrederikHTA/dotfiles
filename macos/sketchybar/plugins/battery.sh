#!/bin/bash

. "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(printf '%s\n' "$BATTERY_INFO" | grep -Eo '[0-9]+%' | head -n 1 | tr -d '%')
if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

case "$PERCENTAGE" in
  9[0-9]|100) ICON="" ;;
  [6-8][0-9]) ICON="" ;;
  [3-5][0-9]) ICON="" ;;
  [1-2][0-9]) ICON="" ;;
  *) ICON="" ;;
esac

COLOR="$GREEN_COLOR"
if [ "$PERCENTAGE" -le 20 ]; then
  COLOR="$RED_COLOR"
elif [ "$PERCENTAGE" -le 40 ]; then
  COLOR="$ORANGE_COLOR"
fi
case "$BATTERY_INFO" in
  *'AC Power'*) ICON=""; COLOR="$GREEN_COLOR" ;;
esac

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color="$COLOR" label="$PERCENTAGE%"
