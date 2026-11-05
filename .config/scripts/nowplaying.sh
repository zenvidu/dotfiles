#!/usr/bin/env bash

# This script displays the currently playing song from a list of allowed players.
# It updates immediately on changes, excludes browsers, and remembers the last played song.

pkill -f "playerctl -F metadata" 2>/dev/null
trap 'pkill -P $$' EXIT

# Add player names here. Use `playerctl -l` to find the exact names.
# The regex format allows for flexibility (e.g., '^mpd$|^YoutubeMusic$').
ALLOWED_PLAYERS_REGEX="^(mpd|limusic|lowfi(\..*)?)"

LAST_TITLE=""

update_display() {
  local active_player=""
  local status=""

  for player in $(playerctl -l 2>/dev/null | grep -E "$ALLOWED_PLAYERS_REGEX"); do
    if [ "$(playerctl -p "$player" status 2>/dev/null)" == "Playing" ]; then
      active_player="$player"
      status="Playing"
      break
    fi
  done

  if [ -z "$active_player" ]; then
    for player in $(playerctl -l 2>/dev/null | grep -E "$ALLOWED_PLAYERS_REGEX"); do
      if [ "$(playerctl -p "$player" status 2>/dev/null)" == "Paused" ]; then
        active_player="$player"
        status="Paused"
        break
      fi
    done
  fi

  if [ -n "$active_player" ]; then
    local current_title=$(playerctl -p "$active_player" metadata --format "{{ title }}" 2>/dev/null)
    if [ -n "$current_title" ]; then
      LAST_TITLE="$current_title"
    fi
    echo "$LAST_TITLE"
  else
    if [ -n "$LAST_TITLE" ]; then
      echo "$LAST_TITLE"
    else
      echo ""
    fi
  fi
}

update_display

playerctl -F metadata 2>/dev/null | while read -r _; do
  update_display
done
