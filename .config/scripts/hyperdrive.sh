#!/usr/bin/env bash

hyprctl eval '
local hyprdrive = (hl.get_config("animations.enabled") == false)

if hyprdrive then
    hl.notification.create({ text = "Hyprdrive off", duration = 1300, icon = "info", color = "rgb(d20f39)" })
    hl.exec_cmd("hyprctl reload")
    return
end

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
    },

    animations = {
        enabled = false,
    },

    decoration = {
        shadow = { enabled = false },
        blur = { enabled = false },
        rounding = 0,
    }
})

hl.notification.create({ text = "Hyprdrive on", duration = 1300, icon = "info", color = "rgb(40a02b)" })
'
