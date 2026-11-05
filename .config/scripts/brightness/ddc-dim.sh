#!/usr/bin/env bash

# Save current brightness
CURRENT=$(ddcutil getvcp 10 | awk -F 'current value = ' '{print $2}' | cut -d',' -f1)

echo "$CURRENT" > /tmp/ddc_brightness

# Set brightness to 0
ddcutil setvcp 10 0
