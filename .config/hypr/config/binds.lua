-- https://wiki.hypr.land/Configuring/Basics/Binds/

local scripts = HOME .. "/.config/scripts"

local mainMod = "SUPER"
local altMod = "ALT"

local terminal = "kitty"
local browser = "librewolf"
local browser2 = "brave-origin --incognito"
local codeEditor = "codium"
local textEditor = "gedit"
local fileManager = "thunar"

local menu = "pkill rofi || rofi -disable-history -show-icons -show"
local monitor = "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"
local wid = "$(hyprctl -j activeworkspace | jq '.id')"
local layout =
	"$(printf \"scrolling\\nmaster\\ndwindle\\nmonocle\" | rofi         -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 150px;}'         -theme-str 'mainbox {children: [ \"message\", \"listview\" ];}'         -theme-str 'listview {columns: 1; lines: 4; spacing: 10px;}'         -theme-str 'element {padding: 10px 5px;}'         -theme-str 'element-text {font: @primary-font; horizontal-align: 0.5;}'         -theme-str 'textbox {horizontal-align: 0.5;}'         -dmenu         -p 'Layout'         -mesg 'ChangeLayout'         -theme menulist)"

-- Writing hl.ds.exec_cmd() all the time is too long, here is a shortcut
local function run(cmd, window_rules)
	return hl.dsp.exec_cmd(cmd, window_rules)
end

-- Generates layout specific binds to avoid hyprland warnings
-- local function layout_bind(bind_table)
--     return function ()
--         local workspace = hl.get_active_special_workspace() or
--                           hl.get_active_workspace()

--         if not workspace then
--             return
--         end

--         local layout = workspace.tiled_layout

--         if bind_table[layout] then
--             hl.dispatch(bind_table[layout])
--         end
--     end
-- end

local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			hl.notification.create({ text = "layout_bind: no workspace!", duration = 3000, icon = "error" })
			return
		end

		local layout = workspace.tiled_layout

		hl.notification.create({
			text = "layout_bind: layout = " .. tostring(layout),
			duration = 3000,
			icon = "info",
		})

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		else
			hl.notification.create({
				text = "layout_bind: no bind for layout '" .. tostring(layout) .. "'",
				duration = 3000,
				icon = "warning",
			})
		end
	end
end

-- Current workspace layout based bindings
hl.bind(
	mainMod .. " + W",
	layout_bind({
		scrolling = hl.dsp.layout("colresize +conf"), -- Scrolling:, set next column width from config
		dwindle = hl.dsp.layout("movetoroot active"), -- Dwindle: make active window the root window
	})
)

hl.bind(
	mainMod .. " + SHIFT + W",
	layout_bind({
		scrolling = hl.dsp.layout("colresize -conf"), -- Scrolling: set previous column width from config
	})
)

hl.bind(
	mainMod .. " + A",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol l"), -- Scrolling: swap column with left one
		dwindle = hl.dsp.layout("swapsplit"), -- Dwindle: swap window split
		monocle = hl.dsp.layout("cycleprev"), -- Monocle and master: cycle prev window
		master = hl.dsp.layout("cycleprev"),
	})
)

hl.bind(
	mainMod .. " + D",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol r"), -- Scrolling: swap column with right one
		dwindle = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
		monocle = hl.dsp.layout("cyclenext"), -- Monocle and master: cycle next window
		master = hl.dsp.layout("cyclenext"),
	})
)

-- Move focus with mainMod + arrow keys
-- hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
-- hl.bind(mainMod .. " + left", hl.dsp.window.alter_zorder({ mode = "top" }))
-- --hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
-- --hl.bind(mainMod .. " + right", hl.dsp.window.cycle_next({ next = true }))
-- --bind = $mainMod, right, cyclenext, tiled # Needed cause of monocle layout, if not using it comment this out and use the one above
-- --hl.bind(mainMod .. " + right", hl.dsp.window.alter_zorder({ mode = "top" }))
-- hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
-- hl.bind(mainMod .. " + up", hl.dsp.window.alter_zorder({ mode = "top" }))
-- hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
-- hl.bind(mainMod .. " + down", hl.dsp.window.alter_zorder({ mode = "top" }))

-- Grow/shrink windows (resize)
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -70, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 70, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -70, relative = true }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 70, relative = true }))

-- Move focus:   SUPER + arrow keys
-- Swap windows: SUPER + CTRL + arrow keys
-- Move windows: SUPER + SHIFT + arrow keys
local zorder = hl.dsp.window.alter_zorder({ mode = "top" })

local move_offsets = {
	left = { x = -50, y = 0 },
	right = { x = 50, y = 0 },
	up = { x = 0, y = -50 },
	down = { x = 0, y = 50 },
}

for _, dir in ipairs({ "left", "right", "up", "down" }) do
	local off = move_offsets[dir]
	hl.bind(mainMod .. " + " .. dir, function()
		local before = hl.get_active_window()
		hl.dispatch(hl.dsp.focus({ direction = dir }))
		local after = hl.get_active_window()
		-- if focus didn't change (hit tiled/floating boundary), cycle to any window
		if before == after then
			hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
		end
		hl.dispatch(zorder)
	end)
	hl.bind(mainMod .. " + CTRL + " .. dir, function()
		hl.dispatch(hl.dsp.window.swap({ direction = dir }))
		hl.dispatch(zorder)
	end)
	hl.bind(
		mainMod .. " + SHIFT + " .. dir,
		hl.dsp.window.move({ x = off.x, y = off.y, relative = true, window = "activewindow" })
	)
end

-- Switch workspaces: mainMod + [0-9]
-- Move active window to workspace: SUPER + CTRL + [0-9]
-- Move active window to workspace and follow: SUPER + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(altMod .. " + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + L", run("hyprlock"))

-- Group binds
hl.bind(mainMod .. " + O", hl.dsp.group.toggle()) -- Create windows group
hl.bind(mainMod .. " + bracketleft", hl.dsp.group.prev()) -- Show previous window in group
hl.bind(mainMod .. " + bracketright", hl.dsp.group.next()) -- Show next window in group

-- Defaults
hl.bind(mainMod .. " + Return", run(terminal))
hl.bind(mainMod .. " + Space", run(menu))
hl.bind(altMod .. " + T", run("[workspace 4] " .. fileManager))
--hl.bind(altMod .. " + T", run(fileManager))
hl.bind(altMod .. " + F", run(browser))
hl.bind(altMod .. " + B", run(browser2))
hl.bind(altMod .. " + C", run(codeEditor))
hl.bind(altMod .. " + K", run(textEditor))

hl.bind(mainMod .. " + backslash", hl.dsp.window.tag({ tag = "bordered" }))
hl.bind(mainMod .. " + SHIFT + backslash", hl.dsp.window.tag({ tag = "opaque" }))

hl.bind(mainMod .. " + X", run("pkill rofi || " .. scripts .. "/power-menu.sh"), { locked = true })
hl.bind(mainMod .. " + V", run("cursor-clip-toggle"))
hl.bind(mainMod .. " + N", run("swaync-client -t"))

-- Screenshots
hl.bind(
	"Print",
	run(
		'hyprcap shot -zN --select region --raw | satty --filename - --output-filename "$HOME/Pictures/screenshots/ss-$(date +%Y%m%d-%H%M%S).png"'
	)
)
hl.bind(
	"SHIFT + Print",
	run(
		'hyprcap shot -zN --select monitor:active --raw | satty --filename - --output-filename "$HOME/Pictures/screenshots/ss-$(date +%Y%m%d-%H%M%S).png"'
	)
)

-- Screen Brightness
hl.bind(mainMod .. " + Page_Up", run(scripts .. "/brightness/brightness.sh + 10"), { locked = true })
hl.bind(mainMod .. " + Page_Down", run(scripts .. "/brightness/brightness.sh - 10"), { locked = true })

-- Volume Shortcuts
hl.bind(
	altMod .. " + equal",
	run('swayosd-client --monitor "' .. monitor .. '" --output-volume raise --max-volume 100'),
	{ locked = true }
)
hl.bind(
	altMod .. " + minus",
	run('swayosd-client --monitor "' .. monitor .. '" --output-volume lower --max-volume 100'),
	{ locked = true }
)
hl.bind(
	altMod .. " + P",
	run('swayosd-client --monitor "' .. monitor .. '" --output-volume mute-toggle'),
	{ locked = true }
)
--hl.bind(
--	altMod .. " + O",
--	run('swayosd-client --monitor "' .. monitor .. '" --input-volume mute-toggle'),
--	{ locked = true }
--)
hl.bind(altMod .. " + O", run(scripts .. "/mic-toggle.sh"), { locked = true })

hl.bind(altMod .. " + F1", run('playerctl -a -i "mpd" previous'))
hl.bind(altMod .. " + F2", run('playerctl -a -i "mpd" play-pause'), { locked = true })
hl.bind(altMod .. " + F3", run('playerctl -a -i "mpd" next'))
hl.bind(altMod .. " + F9", run('playerctl -p "mpd" previous'))
hl.bind(altMod .. " + F10", run('playerctl -p "mpd" play-pause'), { locked = true })
hl.bind(altMod .. " + F11", run('playerctl -p "mpd" next'))
hl.bind(altMod .. " + F12", run('playerctl -p "mpd" stop'))

hl.bind(altMod .. " + M", run("[workspace 8] kitty -e btop --themes-dir $HOME/.config/matugen/generated/"))
hl.bind(altMod .. " + F7", run("[workspace 8] kitty -e sudo -A lazydocker"))
hl.bind(altMod .. " + F8", run("[workspace 9] kitty -e rmpc"))
--hl.bind(altMod .. " + g", run("env GTK_THEME=VALYRIAN-Blue-Steel lutris"))
hl.bind(altMod .. " + g", run("lutris"))
hl.bind(altMod .. " + F4", run("/opt/AppImages/applaunch.sh ytmusic"))

-- Special Keybinds----
hl.bind(altMod .. " + Return", run("[workspace unset; float; size 1015 615] " .. terminal))
hl.bind(altMod .. " + Space", run("pkill rofi || " .. scripts .. "/wallvas.sh"))
--hl.bind(mainMod .. " + M", run("hyprctl keyword workspace " .. wid .. ", layout:" .. layout))
hl.bind(mainMod .. " + Z", run("pkill rofi || " .. scripts .. "/todo/todo.sh --show-rofi"))
hl.bind(mainMod .. " + period", run("pkill rofi || rofi -modi emoji -theme emoji -show emoji -emoji-format '{emoji}'"))
hl.bind(mainMod .. " + F1", run(scripts .. "/hyperdrive.sh"))
hl.bind(mainMod .. " + F9", run(scripts .. "/game-pause-toggle.sh"))

hl.bind(mainMod .. " + M", function ()
    local layouts   = { "scrolling", "master", "dwindle", "monocle" }
    local workspace = hl.get_active_workspace()
    if hl.get_active_special_workspace() then
        workspace = hl.get_active_special_workspace()
    end

    local next_layout = "master"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = "name:" .. tostring(workspace.name), layout = next_layout })
    end
end)

-- Laptop multimedia keys for volume and LCD brightness
-- bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
-- bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
-- bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
-- bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
-- bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
-- bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

-- Requires playerctl
-- bindl = , XF86AudioNext, exec, playerctl next
-- bindl = , XF86AudioPause, exec, playerctl play-pause
-- bindl = , XF86AudioPlay, exec, playerctl play-pause
-- bindl = , XF86AudioPrev, exec, playerctl previous

-- Tempcuts
-- hl.bind(altMod .. " + R", run("swaync-client --reload-css"))
hl.bind(altMod .. " + R", run("$HOME/.config/waybar/launch.sh"))
