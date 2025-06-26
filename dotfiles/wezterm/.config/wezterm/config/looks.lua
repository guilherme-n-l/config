local wt = require("wezterm")
local font = wt.font

local module = {}

function module.apply(config)
    -- Window / Rending
	config.window_close_confirmation = "NeverPrompt"
	config.front_end = "WebGpu"

	-- Colors
	config.color_scheme = "Kanagawa Dragon (Gogh)"

	config.window_background_opacity = 0.9
	config.macos_window_background_blur = 20

	-- Font
	config.font = font("FiraCode Nerd Font Mono")
	config.font_size = 19.

	-- Window / Tab bar
	config.window_padding = {
		left = "1cell",
		right = "1cell",
		top = "0.2cell",
		bottom = "0.2cell",
	}
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true

	-- Cursor
	config.cursor_blink_rate = 800
end

return module
