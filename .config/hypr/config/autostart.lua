-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local startup = {
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",  -- Update some dbus variables
    "systemctl --user start hyprpolkitagent", -- Policy manager (prompts for sudo access if app requests)
    "hyprctl setcursor Borealis-cursors 24", -- Set cursor theme for hyprland
    "awww-daemon", -- Wallpapers daemon
    "swaync", -- notification daemon
    "swayosd-server", -- on-screen-display for keyboard shortcuts like caps-lock and volume
    "waybar", -- topbar
    "cursor-clip --daemon", -- Enables clipboard persistence
    "hyprsunset", -- Bluelight filter
    "hypridle", -- Idle daemon
    "/usr/bin/kdeconnectd", -- Phone Link
    "kdeconnect-indicator" -- tray icon for phone link
    --"~/.local/bin/at_startup" -- Misc user defined custom shell scripts
}

hl.on("hyprland.start", function()
    for i = 1, #startup do
        hl.exec_cmd(startup[i])
    end
end)
