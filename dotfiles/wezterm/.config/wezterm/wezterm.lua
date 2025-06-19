local wt = require("wezterm")
local modules = {
	require("config.mux"),
	require("config.looks"),
	require("config.events"),
	require("config.bindings"),
}

local config = wt.config_builder()
for _, module in ipairs(modules) do
	if module.apply then
		module.apply(config)
	end
end

return config
