require("guilh.utils")
local add = vim.pack.add

add(Gh({
	-- Looks
	"rebelot/kanagawa.nvim.git",
	"nvim-tree/nvim-web-devicons",
	"MunifTanjim/nui.nvim",
	"stevearc/dressing.nvim",
	"MeanderingProgrammer/render-markdown.nvim",
	"folke/snacks.nvim",

	-- Utils
	"nvim-mini/mini.pick",
	"numToStr/Comment.nvim",
	"nvim-lua/plenary.nvim",
	"ibhagwan/fzf-lua",
    "theprimeagen/harpoon",

	-- LSP / Language Support
	"neovim/nvim-lspconfig",
	"nvim-treesitter/nvim-treesitter",

	-- AI
	"coder/claudecode.nvim", -- depends: snacks.nvim
}) --[[@as (string|vim.pack.Spec)[] ]])

Setup_packages({
	"mini.pick",
	"claudecode",
	["Comment"] = {
		padding = true,
		sticky = true,
		ignore = nil,
		toggler = { line = " ;", block = " b;" },
		opleader = { line = " ;", block = " b;" },
		mappings = { basic = true },
		pre_hook = nil,
		post_hook = nil,
	},
})
