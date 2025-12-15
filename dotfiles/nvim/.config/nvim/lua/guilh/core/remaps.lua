dofile(vim.fn.stdpath("config") .. "/utils.lua")
local g = vim.g

g.mapleader = " "
g.camelcasemotion_key = "<leader>"

Set_keymaps({
	n = {
		{ "<leader>x", vim.cmd.bd, {} },

		{ "J", "mzJ`z" },
		{ "<C-d>", "<C-d>zz" },
		{ "<C-u>", "<C-u>zz" },

		{ "n", "nzzzv" },
		{ "N", "Nzzzv" },
	},
	v = {
		-- Bring selected Up/Down
		{ "K", ":m '<-2<CR>gv=gv" },
		{ "J", ":m '>+1<CR>gv=gv" },
	},
	nvx = {
		-- Easy clipboard access
		{ "<leader>y", '"+y<CR>' },
		{ "<leader>d", '"+d<CR>' },
	},
})
