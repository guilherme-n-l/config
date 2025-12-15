dofile(vim.fn.stdpath("config") .. "/utils.lua")

local function completion()
	local current_clients = vim.lsp.get_active_clients({ bufnr = 0 })
	for _, c in ipairs(current_clients) do
		if c.server_capabilities.completionProvider then
			vim.lsp.completion.get()
			return
		end
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
end

local function toggle_virtual_diagnostics()
	local virtual_text_state = false
	return function()
		virtual_text_state = not virtual_text_state
		if virtual_text_state then
			vim.diagnostic.config({ virtual_text = true })
		else
			vim.diagnostic.config({ virtual_text = false })
		end
	end
end

local mappings = {
	n = {
		{ "gd", vim.lsp.buf.definition },

		{ "gf", vim.lsp.buf.format },

		-- Open documentation
		{ "K", vim.lsp.buf.hover },

		{ "<leader>vca", vim.lsp.buf.code_action },
		{ "<leader>vrr", vim.lsp.buf.references },
		{ "<leader>vrn", vim.lsp.buf.rename },

		-- LSP Navigation
		{ "<leader>xf", vim.diagnostic.open_float },
		{ "<leader>xx", toggle_virtual_diagnostics() },
		{ "<leader>xp", vim.diagnostic.goto_prev },
		{ "<leader>xn", vim.diagnostic.goto_next },
	},
	i = {
		{ "<C-h>", vim.lsp.buf.signature_help },
		{ { "<C-n>", "<C-p>" }, completion },
	},
}

return {
	"neovim/nvim-lspconfig",
	config = function()
		Set_keymaps(mappings)
	end,
	lazy = false,
}
