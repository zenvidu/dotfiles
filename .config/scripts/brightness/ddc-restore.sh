#!/usr/bin/env bash

if [ -f /tmp/ddc_brightness ]; then
    VALUE=$(cat /tmp/ddc_brightness)
    ddcutil setvcp 10 "$VALUE"
fi
