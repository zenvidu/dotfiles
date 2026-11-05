#!/usr/bin/env bash

set -euo pipefail

JQ_BIN="${JQ:-jq}"
PW_DUMP_CMD="${PW_DUMP:-pw-dump}"

mic=0
mic_muted=0
cam=0
scr=0

mic_app=""
cam_app=""
scr_app=""

green="#30D158"
orange="#FF9F0A"
purple="#9B32FA"

status() {
    local label="$1"
    local value="$2"

    if [[ -n "$value" ]]; then
        printf '%s: %s' "$label" "$value"
    else
        printf '%s: off' "$label"
    fi
}

icon() {
    local state="$1"
    local color="$2"
    local glyph="$3"

    printf '<span foreground="%s">%s</span>' "$color" "$glyph"
}

if command -v "$PW_DUMP_CMD" >/dev/null 2>&1 &&
   command -v "$JQ_BIN" >/dev/null 2>&1; then

    dump="$("$PW_DUMP_CMD" 2>/dev/null || true)"

    # Microphone detection logic
    mic="$(
        printf '%s' "$dump" |
        "$JQ_BIN" -r '
        [
          .[]
          | select(.type=="PipeWire:Interface:Node")
          | select(
                .info.props."media.class"=="Audio/Source"
             or .info.props."media.class"=="Audio/Source/Virtual"
          )
          | select((.info.state=="running") or (.state=="running"))
        ]
        | if length>0 then 1 else 0 end
        ' 2>/dev/null || echo 0
    )"

    if [[ "$mic" -eq 1 ]]; then
        mic_app="$(
            printf '%s' "$dump" |
            "$JQ_BIN" -r '
            [
              .[]
              | select(.type=="PipeWire:Interface:Node")
              | select(.info.props."media.class"=="Stream/Input/Audio")
              | select((.info.state=="running") or (.state=="running"))
              | .info.props["node.name"]
            ]
            | unique
            | join(", ")
            ' 2>/dev/null || echo ""
        )"
    fi

    if [[ "$mic" -eq 1 ]] && command -v wpctl >/dev/null 2>&1; then
        if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q '\[MUTED\]'; then
            mic_muted=1
        fi
    fi

    # Screen sharing detection logic
    scr="$(
        printf '%s' "$dump" |
        "$JQ_BIN" -e '
        [
          .[]
          | select(.info?.props?)
          | select(
              (.info.props["media.name"]? // "")
              | test("^(xdph-streaming|gsr-default|game capture)")
          )
        ]
        | length > 0
        ' >/dev/null && echo 1 || echo 0
    )"

    if [[ "$scr" -eq 1 ]]; then
        scr_app="$(
            printf '%s' "$dump" |
            "$JQ_BIN" -r '
            [
              .[]
              | select(.type=="PipeWire:Interface:Node")
              | select(
                   .info.props."media.class"=="Stream/Input/Video"
                or .info.props."media.name"=="gsr-default_output"
                or .info.props."media.name"=="game capture"
              )
              | select((.info.state=="running") or (.state=="running"))
              | .info.props["media.name"]
            ]
            | unique
            | join(", ")
            ' 2>/dev/null || echo ""
        )"
    fi
fi

# Camera detection logic
if command -v fuser >/dev/null 2>&1; then

    declare -A seen_pids=()

    for dev in /dev/video*; do
        [[ -e "$dev" ]] || continue

        if pids=$(fuser "$dev" 2>/dev/null); then
            cam=1

            for pid in $pids; do
                seen_pids["$pid"]=1
            done
        fi
    done

    if ((${#seen_pids[@]})); then

        pid_list="${!seen_pids[*]}"

        cam_app="$(
            ps -p "${pid_list// /,}" -o comm= |
            sort -u |
            paste -sd ', ' -
        )"
    fi
fi

# Icons
text=""

if [[ "$mic" -eq 1 ]]; then
    if [[ "$mic_muted" -eq 1 ]]; then
        text+="$(icon 1 "$green" "")"
    else
        text+="$(icon 1 "$orange" "")"
    fi
fi

if [[ "$cam" -eq 1 ]]; then
    [[ -n "$text" ]] && text+=" "
    text+="$(icon 1 "$orange" "󰄀")"
fi

if [[ "$scr" -eq 1 ]]; then
    [[ -n "$text" ]] && text+=" "
    text+="$(icon 1 "$purple" "")"
fi

# Tooltip
mic_status="$(status "Mic" "$mic_app")"
cam_status="$(status "Cam" "$cam_app")"
scr_status="$(status "Screen sharing" "$scr_app")"

printf -v tooltip '%s\r%s\r%s' \
    "$mic_status" \
    "$cam_status" \
    "$scr_status"

# Waybar classes
classes="privacydot"

[[ $mic -eq 1 ]] && classes+=" mic-on" || classes+=" mic-off"
[[ $cam -eq 1 ]] && classes+=" cam-on" || classes+=" cam-off"
[[ $scr -eq 1 ]] && classes+=" scr-on" || classes+=" scr-off"

# JSON output
jq -c -n \
    --arg text "$text" \
    --arg tooltip "$tooltip" \
    --arg class "$classes" \
    '{text:$text, tooltip:$tooltip, class:$class}'
