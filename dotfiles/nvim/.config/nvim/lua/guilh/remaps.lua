local trouble = require("trouble")
local harpoonui = require("harpoon.ui")
local harpoon = require("harpoon.mark")
local harpoon_goto = harpoonui.nav_file
local conform = require("conform")
local utils = require("guilh.utils")

local globals = {
	mapleader = " ",
	camelcasemotion_key = "<leader>",
}

for k, v in pairs(globals) do
	vim.g[k] = v
end

local mappings = {
	n = {
		{ "<leader>x", vim.cmd.bd, {} },

		{ "<leader>ww", "<Plug>CamelCaseMotion_w", { silent = true } },
		{ "<leader>bb", "<Plug>CamelCaseMotion_b", { silent = true } },
		{ "<leader>ee", "<Plug>CamelCaseMotion_e", { silent = true } },

		{ "<leader>pf", ":Pick files<CR>", { silent = true } },
		{ "<leader>pv", ":Oil<CR>", { silent = true } },
		{ "<leader>pg", ":Pick grep_live<CR>", { silent = true } },
		{ "<leader>ph", ":Pick help<CR>", { silent = true } },

		{ "<leader>hm", harpoon.add_file },
		{ "<leader>hn", harpoonui.nav_next },
		{ "<leader>hp", harpoonui.nav_prev },
		{ "<leader>hv", harpoonui.toggle_quick_menu },
		{
			"<leader>1",
			function()
				harpoon_goto(1)
			end,
		},
		{
			"<leader>2",
			function()
				harpoon_goto(2)
			end,
		},
		{
			"<leader>3",
			function()
				harpoon_goto(3)
			end,
		},
		{
			"<leader>4",
			function()
				harpoon_goto(4)
			end,
		},
		{
			"<leader>5",
			function()
				harpoon_goto(5)
			end,
		},
		{
			"<leader>6",
			function()
				harpoon_goto(6)
			end,
		},
		{
			"<leader>7",
			function()
				harpoon_goto(7)
			end,
		},
		{
			"<leader>8",
			function()
				harpoon_goto(8)
			end,
		},
		{
			"<leader>9",
			function()
				harpoon_goto(9)
			end,
		},

		{ "J", "mzJ`z" },
		{ "<C-d>", "<C-d>zz" },
		{ "<C-u>", "<C-u>zz" },

		{ "n", "nzzzv" },
		{ "N", "Nzzzv" },

		{
			"<leader>gr",
			function()
				trouble.toggle("lsp_references")
			end,
		},
		{
			"<leader>gf",
			function()
				conform.format()
			end,
		},
		{ "<leader>gv", vim.cmd.AerialToggle },

		{
			"<leader>xx",
			function()
				utils.toggle_virtual_text()
			end,
		},
		{
			"<leader>xf",
			function()
				vim.diagnostic.open_float()
			end,
		},
		{
			"<leader>xv",
			function()
				trouble.toggle("diagnostics")
			end,
		},
		{ "<leader>xp", vim.diagnostic.goto_prev },
		{ "<leader>xn", vim.diagnostic.goto_next },
		{ "<leader>xu", vim.cmd.UndotreeToggle },

		{ "<leader>vtm", ":TextMode<CR>", { silent = false } },

		{ "<leader>y", '"+y', { noremap = true } },
		{ "<leader>d", '"+d', { noremap = true } },
	},

	v = {
		{ "J", ":m '>+1<CR>gv=gv" },
		{ "K", ":m '<-2<CR>gv=gv" },
	},

	vx = {
		{ "<leader>y", '"+y<CR>' },
		{ "<leader>d", '"+d<CR>' },
	},
}

utils.set_keymaps(mappings)
