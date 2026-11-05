-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

--- Workspace rules ---
--hl.workspace_rule({ workspace = "1", layout = "master" })
--hl.workspace_rule({ workspace = "special:magic", layout = "dwindle" })

--- Window rules ---

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Picture-in-Picture (browser PiP windows)
hl.window_rule({
	name = "Picture in Picture",
	match = {
		title = "Picture-in-Picture",
		--class = "^(librewolf)(.*)$",
	},

	--move = "1239 814",
	--move = { "monitor_w - 670 - 10", "monitor_h - 380 - 10" },
	size = "670 380",
	--move = {"window_w * 0.5", "(monitor_h / 2) + 17"},
	--size = {"monitor_w * 0.5", "monitor_h * 0.5"},
	pin = true,
	float = true,
	no_initial_focus = true,
	focus_on_activate = true,
	keep_aspect_ratio = true,
})

hl.window_rule({
	name = "Screen share picker",
	match = {
		class = "hyprland-share-picker",
	},

	float = true,
	move = "1413 903",
	--size = "1555 985",
	--center = true,
})

-- Thunar File oprations
hl.window_rule({
	name = "Thunar dialogs",
	match = {
		class = "thunar|Thunar",
		title = 'Rename "*.*"|File Operation Progress|Confirm to replace files|Attention',
	},

	float = true,
	center = true,
	persistent_size = true,
})

hl.window_rule({
	name = "Thunar stayfocused",
	match = {
		class = "thunar|Thunar",
		title = 'Attention|Rename "*.*"|Create Document from .*|New .* ...|Create New Folder',
	},

	stay_focused = true,
})

hl.window_rule({
	name = "Thunar move right bottom",
	match = {
		class = "(thunar|Thunar)",
		title = "^(File Operation Progress)$",
	},

	focus_on_activate = false,
	move = "1460 1090",
})

hl.window_rule({
	name = "GUI File manager",
	match = {
		class = "(thunar|Thunar)",
		title = 'negative:(Rename ".+"|File Operation Progress|Confirm to replace files|Attention|Create Document from .*|New .* \\.\\.\\..*|Create New Folder)',
	},
	float = true,
	size = "1005 670",
	center = true,
})

hl.window_rule({
	name = "Text Editor",
	match = {
		class = ".*gedit.*",
	},

	float = true,
	size = "955 590",
	center = true,
})

hl.window_rule({
	name = "Secondary Browser",
	match = {
		class = "brave-.*",
	},

	float = true,
	size = "1555 985",
	center = true,
})

hl.window_rule({
	name = "Float by class",
	match = {
		class = "nwg-look|engrampa|nm-connection-editor|system-config-printer|\
                 |xdg-desktop-portal-gtk|qt6ct|.*pavucontrol.*|.*satty|\
                 |.*nomacs.*|.*zathura|.*localsend.*|.*kdeconnect.*",
	},

	float = true,
	center = true,
	persistent_size = true,
})

hl.window_rule({
	match = {
		title = "Keyguard",
	},
	float = true,
	move = { 1485, 450 },
	size = { 420, 740 },
	no_screen_share = true,
})

hl.window_rule({
	name = "Alternative Discord overlay",
	match = {
		class = "Overlayed.*",
	},
	opacity = 0.7,
	no_initial_focus = true,
	float = true,
	pin = true,
	no_blur = true,
	no_dim = true,
	no_follow_mouse = true,
	no_shadow = true,
	border_size = 0,
	no_focus = true,
	move = { 1582, 990 },
	size = { 275, 435 },
})

hl.window_rule({ match = { class = "zenity", title = "^(Winetricks -)(.*)|winetricks" }, float = true, center = true })

hl.window_rule({ match = { class = "kitty" }, center = true, workspace = "1" })
hl.window_rule({ match = { class = "(?i)librewolf" }, center = true, workspace = "2" })
hl.window_rule({ match = { class = "(?i)codium" }, workspace = "3" })
hl.window_rule({ match = { class = ".*lutris.*" }, center = true, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "(?i)steam" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "seanime-denshi" }, center = true, workspace = "6", no_initial_focus = true })
hl.window_rule({ match = { class = ".*gram" }, workspace = "6" })
hl.window_rule({ match = { class = ".*obsidian.*" }, workspace = "6" })
hl.window_rule({ match = { class = ".*vesktop|discord" }, workspace = "6", no_initial_focus = true })
hl.window_rule({ match = { class = "(?i)gimp" }, workspace = "7" })
hl.window_rule({ match = { class = "(?i).*kdenlive" }, workspace = "7" })
hl.window_rule({ match = { class = "rawtherapee" }, workspace = "7" })
hl.window_rule({ match = { class = "godot" }, workspace = "7" })
hl.window_rule({ match = { class = "virt-manager" }, center = true, workspace = "7" })
hl.window_rule({ match = { class = ".*qBittorrent" }, center = true, workspace = "8" })
hl.window_rule({ match = { class = ".*obs.*" }, workspace = "8" })
hl.window_rule({ match = { class = "btop" }, workspace = "8" })
hl.window_rule({ match = { class = "lazydocker" }, workspace = "8" })
hl.window_rule({ match = { class = ".*jdownloader.*" }, workspace = "8" })
hl.window_rule({ match = { class = "rmpc" }, center = true, workspace = "9" })
hl.window_rule({ match = { class = ".*Limusic.*" }, center = true, workspace = "9", no_initial_focus = true })

--- Layer rules ---

hl.layer_rule({
	match = {
		namespace = "waybar",
	},

	animation = "slide top",
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	match = {
		namespace = "rofi",
	},

	animation = "slide top",
	blur = true,
	ignore_alpha = 0.5,
	above_lock = 2,
})

hl.layer_rule({
	match = {
		namespace = "swaync-control-center",
	},

	animation = "slide right",
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	match = {
		namespace = "swaync-notification-window",
	},

	animation = "slide right",
	blur = true,
	ignore_alpha = 0.5,
	no_screen_share = true,
})

hl.layer_rule({
	match = {
		namespace = "swayosd",
	},

	animation = "slide bottom",
	blur = true,
	ignore_alpha = 0.5,
	above_lock = 1,
})

hl.layer_rule({
	match = {
		namespace = "cursor-clip",
	},

	animation = "popin 40%",
	no_screen_share = true,
})
