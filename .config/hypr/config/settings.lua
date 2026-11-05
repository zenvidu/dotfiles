-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 5,
		border_size = 1,

		col = {
            active_border   = { colors = {primary, surface_container, primary, surface_container, primary, surface_container, primary, surface_container, primary, surface_container}, angle = 20 },
			inactive_border = "rgba(00000000)",
		},

		resize_on_border = false,
		allow_tearing = true,

		layout = "scrolling",
	},

	dwindle = {
		preserve_split = true,

		-- specifies the scale factor of windows on the special workspace
		-- AKA extra gaps for special workspaces
		--special_scale_factor = 0.98,
	},

	master = {
		new_status = "master",
		new_on_top = true,
		--special_scale_factor = 1,
	},

	scrolling = {
		explicit_column_widths = "0.7, 0.99, 1.0",
		column_width = 0.99,

		-- when a window is focused, require that at least
		-- a given fraction of it is visible for focus to follow. [0.0 - 1.0]
		-- 1.0 -> follow only on hard input
		follow_min_visible = 1.0,

		-- When a column is focused, what method should be used to bring it into view.
		-- 0: center,
		-- 1: fit
		focus_fit_method = 0,

		-- When enabled, causes hl.dsp.layoutmsg("swapcol l/r") to wrap around at the beginning and end.
		wrap_swapcol = false,
	},

    group = {
        col = {
            border_active = "rgba(00000000)",
            border_inactive = "rgba(00000000)",
        },

        groupbar = {

            font_size = 14,
            gradients = true,
            height = 24,
            gradient_rounding = 6,
            text_color = on_surface,

            indicator_height = 0,
            indicator_gap = 2,
            keep_upper_gap = false,

            col = {
                active = "rgba(000000ff)",
                inactive = "rgba(00000080)",
            },

        },
    },

	decoration = {
		rounding = 6,
		rounding_power = 3,
		active_opacity = 1.0,
		dim_inactive = true,
		dim_strength = 0.1,

		blur = {
			enabled = true,
			size = 2,
			passes = 2,
			vibrancy = 0.01,
		},

		shadow = {
			enabled = false,
			range = 10,
			render_power = 3,
			sharp = false,
			color = 0xee1a1a1a,
		},
	},

	animations = {
		enabled = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		-- 0: disabled
		-- 1: focus will change to the window under the cursor
		--    when changing from tiled-to-floating and vice versa
		-- 2: focus will also follow mouse on float-to-float switches.
		float_switch_override_focus = 2,

		-- Controls the window focus behavior when a window is closed.
		-- 0: focus will shift to the next window candidate.
		-- 1: focus will shift to the window under the cursor.
		-- 2: focus will shift to the most recently used/active window.
		focus_on_close = 1,

		numlock_by_default = true,
		follow_mouse = 0,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},

	cursor = {
		inactive_timeout = 10,
		enable_hyprcursor = false,
	},

	misc = {
		-- Disable default random wallpaper
		force_default_wallpaper = 0,

		disable_hyprland_logo = true,
		disable_splash_rendering = true,

		-- controls the VRR (Adaptive Sync) of your monitors.
		-- 0: off
		-- 1: on
		-- 2: fullscreen only
		-- 3: fullscreen with video or game content type
		vrr = 2,

		enable_swallow = true,
		swallow_regex = "^(kitty)$",

		--- whether to disable the warning about not using start-hyprland
		disable_watchdog_warning = true,
	},

	xwayland = {
		enabled = true,
		force_zero_scaling = true,
	},

	binds = {
		-- If enabled, an attempt to switch to the currently focused workspace
		-- will instead switch to the previous workspace. Akin to i3's auto_back_and_forth
		workspace_back_and_forth = true,

		hide_special_on_workspace_change = true,
		movefocus_cycles_fullscreen = true,
	},

	render = {
		-- Whether the color management pipeline should be enabled or not
		-- (requires a restart of Hyprland to fully take effect)
		cm_enabled = true,

		-- Report content type to allow monitor profile autoswitch
		-- (may result in a black screen during the switch)
		send_content_type = false,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	binds = {
		drag_threshold = 15, -- Fire a drag event only after dragging for more than 10px
	},
})
