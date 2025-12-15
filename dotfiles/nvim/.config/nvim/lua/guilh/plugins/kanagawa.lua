local nobg = { bg = "none" }
return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			transparent = true,
			dimInactive = false,
			terminalColors = true,
			overrides = function()
				return {
					LineNr = nobg,
					SignColumn = nobg,
					GitSignsAdd = nobg,
					GitSignsChange = nobg,
					GitSignsDelete = nobg,
				}
			end,
			theme = "dragon",
		})
	end,
}
