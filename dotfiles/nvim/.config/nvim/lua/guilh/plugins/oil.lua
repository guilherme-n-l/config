dofile(vim.fn.stdpath("config") .. "/utils.lua")

local function _for_each_lsp_client(f)
	local current_clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, c in ipairs(current_clients) do
		f(c)
	end
end

local function disable_diagnostics()
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "oil://*",
		callback = function()
			vim.diagnostic.enable(false, { bufnr = 0 })
			_for_each_lsp_client(function(c)
				c.stop()
			end)
		end,
	})
	vim.api.nvim_create_autocmd("BufLeave", {
		pattern = "oil://*",
		callback = function()
			vim.diagnostic.enable(true, { bufnr = 0 })
		end,
	})
end

return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	keys = {
		{ "<leader>pv", "<cmd>Oil<cr>", desc = "Open current directory" },
	},
	config = function()
		require("oil").setup()
		disable_diagnostics()
	end,
	lazy = false,
}
