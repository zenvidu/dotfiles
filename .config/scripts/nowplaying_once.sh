#!/usr/bin/env bash

ALLOWED_PLAYERS_REGEX="^(mpd|limusic|lowfi(\..*)?)"

for player in $(playerctl -l 2>/dev/null | grep -E "$ALLOWED_PLAYERS_REGEX"); do
  status=$(playerctl -p "$player" status 2>/dev/null)

  if [[ "$status" == "Playing" ]]; then
    playerctl -p "$player" metadata --format "{{ title }}"
    exit
  fi
done

for player in $(playerctl -l 2>/dev/null | grep -E "$ALLOWED_PLAYERS_REGEX"); do
  status=$(playerctl -p "$player" status 2>/dev/null)

  if [[ "$status" == "Paused" ]]; then
    playerctl -p "$player" metadata --format "{{ title }}"
    exit
  fi
done
