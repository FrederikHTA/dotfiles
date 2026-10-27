#!/bin/bash

TRACK=$(osascript 2>/dev/null <<'APPLESCRIPT'
with timeout of 2 seconds
  if application "Spotify" is not running then return ""
  tell application "Spotify"
    if player state is not playing then return ""
    return name of current track & " — " & artist of current track
  end tell
end timeout
APPLESCRIPT
) || TRACK=""

if [ -n "$TRACK" ]; then
  sketchybar --set "$NAME" drawing=on label="$TRACK"
else
  sketchybar --set "$NAME" drawing=off
fi
