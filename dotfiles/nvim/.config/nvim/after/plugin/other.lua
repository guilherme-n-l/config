local plugins = { "mini.pick", "oil" }
for _, i in ipairs(plugins) do
	require(i).setup()
end
