#!/usr/bin/env bash

# Need 'ddcutil', 'jq' & 'swayosd' packages to be installed
# Define your serial numbers here
SERIAL_MAIN="CN453802XF"
SERIAL_SECOND="G2524H"

TARGET_SERIAL="" # Empty variable

if [[ "$1" =~ [A-Za-z] ]]; then
  TARGET_SERIAL="$1"
  shift
fi

if [ -z "$TARGET_SERIAL" ]; then
  #FOCUSED_OUTPUT=$(i3-msg -t get_outputs | jq -r '.[] | select(.focused) | .name')
  FOCUSED_OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

  case "$FOCUSED_OUTPUT" in
  DP-1)
    TARGET_SERIAL="$SERIAL_MAIN"
    ;;
  DP-2)
    TARGET_SERIAL="$SERIAL_SECOND"
    ;;
  *)
    TARGET_SERIAL="$SERIAL_MAIN"
    ;;
  esac
fi

output=$(ddcutil --sn "$TARGET_SERIAL" setvcp 10 "$@" 2>/dev/null)

current=$(echo "$output" | awk -F'current value = ' '{print $2}' | awk -F',' '{print $1}')
max=$(echo "$output" | awk -F'max value = ' '{print $2}')

# Fallback if monitor did not return brightness
if [[ -z "$current" || -z "$max" ]]; then
  info=$(ddcutil --sn "$TARGET_SERIAL" getvcp 10)
  current=$(echo "$info" | awk -F'current value = ' '{print $2}' | awk -F',' '{print $1}')
  max=$(echo "$info" | awk -F'max value = ' '{print $2}')
fi

if [[ -n "$current" && -n "$max" ]]; then
  progress=$(awk "BEGIN {printf \"%.3f\", $current/$max}")
  swayosd-client \
    --custom-icon display-brightness-symbolic \
    --custom-progress "$progress" \
    --custom-progress-text "${current}%"
fi
