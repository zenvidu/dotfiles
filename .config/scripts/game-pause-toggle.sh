#!/usr/bin/env bash

FOCUSED_PID=$(hyprctl activewindow -j | jq -r '.pid // empty')

if [[ -z "$FOCUSED_PID" ]]; then
  exit 1
fi

if ! kill -0 "$FOCUSED_PID" 2>/dev/null; then
  exit 1
fi

STATE=$(ps -o state= -p "$FOCUSED_PID" | tr -d ' ')

# Don't trust the notification
if [[ "$STATE" == T* ]]; then
  if kill -CONT "$FOCUSED_PID"; then
    notify-send -a "task" -u low -r 9997 "Game Resumed"
  fi
else
  if kill -STOP "$FOCUSED_PID"; then
    notify-send -a "task" -u low -r 9997 "Game Paused"
  fi
fi
