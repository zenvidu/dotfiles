#!/bin/bash

killall -9 waybar
#killall -9 swaync

waybar &
#swaync && sleep 1 && notify-send -a "task" -u low -r 9991 -i "volume-mute" "Muted" -t 2000
