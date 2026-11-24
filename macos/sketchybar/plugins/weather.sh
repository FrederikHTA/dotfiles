#!/bin/bash

# A fixed city avoids inaccurate IP-based geolocation.
WEATHER=$(curl --fail --silent --max-time 8 -G \
  --data-urlencode 'm' --data-urlencode 'format=%l|%c|%t' 'https://wttr.in/Aarhus') || WEATHER=""

if [[ "$WEATHER" == *'|'*'|'* ]]; then
  LOCATION=${WEATHER%%|*}
  WEATHER=${WEATHER#*|}
  ICON=${WEATHER%%|*}
  TEMPERATURE=${WEATHER#*|}
  LOCATION=${LOCATION%%,*}

  if [[ -n "$LOCATION" && -n "${ICON//[[:space:]]/}" && "$TEMPERATURE" =~ ^[+-]?[0-9]+°C$ ]]; then
    sketchybar --set "$NAME" icon="$ICON" label="$LOCATION $TEMPERATURE"
    exit 0
  fi
fi

sketchybar --set "$NAME" icon="☁️" label="Weather --°C"
