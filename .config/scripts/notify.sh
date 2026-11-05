#!/usr/bin/env bash

SOUND="$HOME/.config/scripts/sounds/sci-fi.mp3"

[[ "$(swaync-client --get-dnd)" == "true" ]] && exit 0

#exec pw-play --volume 0.3 "$SOUND"
exec pw-play --volume 0.8 "$SOUND"
