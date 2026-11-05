
HOME = os.getenv("HOME")

dofile(HOME .. "/.config/matugen/generated/hypr-matugen.lua")

require("config.variables")
require("config.autostart")
require("config.windowrules")
require("config.binds")
require("config.settings")

-- Uncomment only one from below
require("config.horizontal") -- Horizontal animation
--require("config.vertical") -- Vertical animation


-- refer https://deepwiki.com/hyprwm/hyprland-wiki/1-introduction-to-hyprland
