require("guilh.utils")
local add = vim.pack.add

add(Gh({
	-- Looks
	"rebelot/kanagawa.nvim.git",

	-- Utils
	"nvim-mini/mini.pick",
	"numToStr/Comment.nvim",

	-- LSP / Language Support
	"neovim/nvim-lspconfig",
	"nvim-treesitter/nvim-treesitter",
}))

-- Mini
require("mini.pick").setup()

-- Comment
local comment_mapping = { line = " ;", block = " b;" }
require("Comment").setup({
	padding = true,
	sticky = true,
	ignore = nil,
	toggler = comment_mapping,
	opleader = comment_mapping,
	mappings = { basic = true },
	pre_hook = nil,
	post_hook = nil,
})
