local wt = require("wezterm")
-- local utils = require("utils")
local act = wt.action
local mux = wt.mux
local module = {}

function module.apply(config)
	config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }

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
			mods = "LEADER",
			key = "h",
			action = act.ActivateTabRelative(-1),
		},
		{
			mods = "LEADER",
			key = "l",
			action = act.ActivateTabRelative(1),
		},
		{
			mods = "LEADER",
			key = "j",
			action = act.MoveTabRelative(-1),
		},
		{
			mods = "LEADER",
			key = "k",
			action = act.MoveTabRelative(1),
		},
		-- {
		-- 	key = ",",
		-- 	mods = "LEADER",
		-- 	action = utils.rename("Enter new name for tab", "", function(win, _, title)
		-- 		win:active_tab():set_title(title)
		-- 	end),
		-- },
		---- Workspaces
		{
			key = "s",
			mods = "LEADER",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		-- {
		-- 	key = "$",
		-- 	mods = "LEADER",
		-- 	action = utils.rename("Enter new name for workspace", mux.get_active_workspace(), function(_, _, title)
  --                   mux.rename_workspace(mux.get_active_workspace(), name)
		-- 	end)
		-- },
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
