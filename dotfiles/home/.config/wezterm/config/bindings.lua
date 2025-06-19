local wt = require("wezterm")
local act = wt.action
local mux = wt.mux
local module = {}

function module.apply(config)
	config.leader = { key = "t", mods = "ALT", timeout_milliseconds = 1000 }

	config.keys = {
		----  Mux
		{
			key = "q",
			mods = "LEADER",
			action = act.SpawnCommandInNewTab({
				args = { "sh", "-c", "kill $(ps aux | grep wezterm-mux-server | grep -v grep | awk '{print $2}')" },
			}),
		},
		----  Tabs
		{
			key = "v",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "c",
			mods = "LEADER",
			action = act.SpawnCommandInNewTab({
				cwd = wt.home_dir,
			}),
		},
		{
			key = "x",
			mods = "LEADER",
			action = act.CloseCurrentTab({ confirm = false }),
		},
		{
			mods = "ALT",
			key = "h",
			action = act.ActivateTabRelative(-1),
		},
		{
			mods = "ALT",
			key = "l",
			action = act.ActivateTabRelative(1),
		},
		{
			key = ",",
			mods = "LEADER",
			action = act.EmitEvent("tabs.manual-update-tab-title"),
		},
		---- Workspaces
		{
			key = "s",
			mods = "LEADER",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		{
			key = "$",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for workspace",
				action = wt.action_callback(function(_, _, line)
					if line then
						local ws = mux.get_active_workspace()
						mux.rename_workspace(ws, line)
					end
				end),
			}),
		},
	}

	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "ALT",
			action = act.ActivateTab(i - 1),
		})
	end
end

return module
