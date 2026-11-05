#!/usr/bin/env bash

DIR="$HOME/.config/scripts"
theme='menulist'
TIMEOUT=5

uptime="$(uptime -p | sed -e 's/up //g')"
shutdown=''
reboot=''
lock=''
logout=''
yes='Yes'
no='No'

rofi_cmd() {
    rofi -dmenu \
        -mesg "Uptime: $uptime" \
        -theme "$theme"
}

confirm_cmd() {
    rofi -theme-str 'window {location: north; anchor: north; fullscreen: false; width: 450px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element {padding: 20px 10px;}' \
        -theme-str 'element-text {font: @tertiary-font; horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "$theme"
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$logout\n$lock\n$reboot\n$shutdown" | rofi_cmd
}

terminate_clients() {
    clients=$(hyprctl clients -j | jq -r '.[].pid')

    for pid in $clients; do
        kill -15 "$pid" 2>/dev/null
    done

    start=$(date +%s)

    for pid in $clients; do
        while kill -0 "$pid" 2>/dev/null; do
            now=$(date +%s)
            (( now - start >= TIMEOUT )) && break
            sleep 0.3
        done
    done
}

shutdown_system() {
    confirm="$(confirm_exit)"
    [[ "$confirm" != "$yes" ]] && exit 0

    terminate_clients
    systemctl poweroff
}

reboot_system() {
    confirm="$(confirm_exit)"
    [[ "$confirm" != "$yes" ]] && exit 0

    terminate_clients
    systemctl reboot
}

lock_system() {
    hyprlock
}

logout_system() {
    confirm="$(confirm_exit)"
    [[ "$confirm" != "$yes" ]] && exit 0

    terminate_clients
    sleep 0.2
    command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'
}

chosen="$(run_rofi)"

case "$chosen" in
    "$shutdown")
        shutdown_system
        ;;
    "$reboot")
        reboot_system
        ;;
    "$lock")
        lock_system
        ;;
    "$logout")
        logout_system
        ;;
    *)
        exit 0
        ;;
esac
