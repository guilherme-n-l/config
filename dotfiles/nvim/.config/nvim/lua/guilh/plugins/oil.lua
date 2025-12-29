dofile(vim.fn.stdpath("config") .. "/utils.lua")

return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	keys = {
		{ "<leader>pv", "<cmd>Oil<cr>", desc = "Open current directory" },
	},
	config = function()
		require("oil").setup()
	end,
	lazy = false,
}
