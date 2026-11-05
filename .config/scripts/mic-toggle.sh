#!/usr/bin/env bash

# Why I made this when I can use 'swayosd-client --input-volume mute-toggle' command? , for the love of god I can NOT get that specific swayosd command to work for some reason.

set -euo pipefail

readonly SOURCE="@DEFAULT_AUDIO_SOURCE@"

readonly SOUND_MUTED="$HOME/.config/scripts/sounds/discord-mute.mp3"
readonly SOUND_UNMUTED="$HOME/.config/scripts/sounds/discord-unmute.mp3"

if wpctl get-volume "$SOURCE" | grep -q '\[MUTED\]'; then
    paplay "$SOUND_UNMUTED"
    wpctl set-mute "$SOURCE" toggle
    exit 0
else
    wpctl set-mute "$SOURCE" toggle
    paplay "$SOUND_MUTED"
    exit 1
fi
