local module = {}
local wt = require("wezterm")

local mux = wt.mux
function module.apply(_)
	wt.on("update-right-status", function(window, _)
		local prefix = window:leader_is_active() and "$W" or "$"
		local ws = mux.get_active_workspace()

		window:set_left_status(wt.format({
			{ Text = " " .. prefix .. " " },
		}))

		window:set_right_status(wt.format({
			{ Text = "(" .. ws .. ") " },
		}))
	end)
end

return module
