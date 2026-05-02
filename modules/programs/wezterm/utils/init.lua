local wt = require("wezterm")
local act = wt.action

return {
	rename = function(description, initial_value, callback)
		return act.PromptInputLine({
			description = description,
			initial_value = initial_value or "",
			action = wt.action_callback(function(win, pane, line)
				if line and callback then
					callback(win, pane, line)
				end
			end),
		})
	end,
}
