#!/usr/bin/env bash

set -euo pipefail

SERVICE_NAME="v2raya.service"
STATE_FILE="/tmp/v2ray_service_state.txt"
SEARXNG_DIR="/opt/Dockerstuff"
SIGNAL="8"

if [[ "${1:-}" == "toggle" ]]; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    sudo -A systemctl stop "$SERVICE_NAME"
  else
    sudo -A systemctl start "$SERVICE_NAME"
  fi

  # Give systemd a moment to update its state
  sleep 1

  # Waybar refresh
  pkill -RTMIN+$SIGNAL waybar

  exit 0
fi

FIRST_RUN=false
if [[ -f "$STATE_FILE" ]]; then
  PREVIOUS_STATE=$(<"$STATE_FILE")
else
  PREVIOUS_STATE="unknown"
  FIRST_RUN=true
fi

if systemctl is-active --quiet "$SERVICE_NAME"; then
  CURRENT_STATE="Secured"
  STATUSBAR_OUTPUT=""
else
  CURRENT_STATE="Stopped"
  STATUSBAR_OUTPUT=""
fi

# -------------------------
# Docker restart (optional)
# -------------------------
run_docker_commands() {
  if [ ! -d "$SEARXNG_DIR" ]; then
    notify-send -a "task" -u low -r 9994 -i "error" "Error" "Directory $SEARXNG_DIR does not exist" -t 5000
    return 1
  fi

  cd "$SEARXNG_DIR" || return 1

  if [ ! -f "docker-compose.yml" ] && [ ! -f "compose.yml" ]; then
    notify-send -a "task" -u low -r 9994 -i "error" "Error" "No compose file found in $SEARXNG_DIR" -t 5000
    return 1
  fi

  docker compose down >/tmp/docker_down.log 2>&1
  sleep 10
  docker compose up -d >/tmp/docker_up.log 2>&1

  notify-send -a "task" -u low -r 9994 "Docker Commands" "$(cat /tmp/docker_up.log)" -t 5000
}

if [[ "$FIRST_RUN" != true && "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
  if [[ "$CURRENT_STATE" == "Secured" ]]; then
    notify-send -a "task" -u low -r 9993 -i "shield-up" "V2ray connected" -t 2500
    # sleep 2m
    # run_docker_commands
  else
    notify-send -a "task" -u low -r 9993 -i "shield-down" "V2ray disconnected" -t 2500
    # sleep 3s
    # run_docker_commands
  fi
fi

echo "$CURRENT_STATE" >"$STATE_FILE"
echo "{\"text\": \"$STATUSBAR_OUTPUT\", \"tooltip\": \"$CURRENT_STATE\"}"
