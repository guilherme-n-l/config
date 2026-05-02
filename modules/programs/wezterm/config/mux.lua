local module = {}

function module.apply(config)
	config.unix_domains = {
		{ name = "unix" },
	}

	-- config.default_gui_startup_args = { "connect", "unix" }
end

return module
