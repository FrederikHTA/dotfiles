#!/bin/bash
set -euo pipefail

export CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_DIR="$CONFIG_DIR/plugins"
. "$CONFIG_DIR/colors.sh"
export NAME="test.widget" SENDER=forced MOCK_STATUS=0

# Mock the external commands; these checks never change playback or the bar.
osascript() {
  printf '%s\n' "${MOCK_OUTPUT:-}"
  return "$MOCK_STATUS"
}
pmset() {
  printf '%s\n' "${MOCK_BATTERY:-}"
}
curl() {
  printf '%s\n' "${MOCK_WEATHER:-}"
  return "${MOCK_WEATHER_STATUS:-0}"
}
sketchybar() {
  printf '%s\n' "$@"
}
export -f osascript pmset curl sketchybar

assert_update() {
  local script="$1" actual expected
  shift
  expected=$(printf '%s\n' "$@")
  actual=$("$PLUGIN_DIR/$script")
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: %s\nExpected:\n%s\nActual:\n%s\n' "$script" "$expected" "$actual" >&2
    return 1
  fi
}

export MOCK_OUTPUT='A Song "With Quotes" — Artist & Band'
assert_update spotify.sh --set "$NAME" drawing=on "label=$MOCK_OUTPUT"
export MOCK_OUTPUT=''
assert_update spotify.sh --set "$NAME" drawing=off
export MOCK_OUTPUT='stale track' MOCK_STATUS=1
assert_update spotify.sh --set "$NAME" drawing=off

export MOCK_OUTPUT=13 MOCK_STATUS=0
assert_update volume.sh --set "$NAME" icon=󰕿 "icon.color=$TEXT_COLOR" label=13%
export SENDER=volume_change INFO=72
assert_update volume.sh --set "$NAME" icon=󰕾 "icon.color=$TEXT_COLOR" label=72%
export INFO=0
assert_update volume.sh --set "$NAME" icon=󰖁 "icon.color=$MUTED_COLOR" label=0%
export INFO=invalid
assert_update volume.sh

export MOCK_BATTERY="Now drawing from 'AC Power'
 -InternalBattery-0 80%; AC attached; not charging"
assert_update battery.sh --set "$NAME" drawing=on icon= "icon.color=$GREEN_COLOR" label=80%
export MOCK_BATTERY="Now drawing from 'Battery Power'
 -InternalBattery-0 15%; discharging"
assert_update battery.sh --set "$NAME" drawing=on icon= "icon.color=$RED_COLOR" label=15%
export MOCK_BATTERY="Now drawing from 'Battery Power'
 -InternalBattery-0 35%; discharging"
assert_update battery.sh --set "$NAME" drawing=on icon= "icon.color=$ORANGE_COLOR" label=35%
export MOCK_BATTERY="Now drawing from 'Battery Power'
 -InternalBattery-0 99%; discharging"
assert_update battery.sh --set "$NAME" drawing=on icon= "icon.color=$GREEN_COLOR" label=99%
export MOCK_BATTERY="Now drawing from 'AC Power'"
assert_update battery.sh --set "$NAME" drawing=off

export MOCK_WEATHER='Copenhagen, Denmark|🌦️ |-3°C' MOCK_WEATHER_STATUS=0
assert_update weather.sh --set "$NAME" 'icon=🌦️ ' 'label=Copenhagen -3°C'
export MOCK_WEATHER='Aarhus|☀️ |+7°C'
assert_update weather.sh --set "$NAME" 'icon=☀️ ' 'label=Aarhus +7°C'
export MOCK_WEATHER='unavailable'
assert_update weather.sh --set "$NAME" 'icon=☁️' 'label=Weather --°C'
export MOCK_WEATHER='Aarhus|☀️ |70°F'
assert_update weather.sh --set "$NAME" 'icon=☁️' 'label=Weather --°C'
export MOCK_WEATHER='Aarhus|☀️ |+7°C' MOCK_WEATHER_STATUS=1
assert_update weather.sh --set "$NAME" 'icon=☁️' 'label=Weather --°C'
printf 'PASS: Spotify, volume, battery, and weather checks\n'
