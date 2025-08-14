local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--------- GUI ---------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"rebelot/kanagawa.nvim",
	"lewis6991/gitsigns.nvim",
	--------- LSP ---------
	"nvim-treesitter/nvim-treesitter",
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
	},
	"neovim/nvim-lspconfig",
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"mateusbraga/vim-spell-pt-br",
	"stevearc/conform.nvim",
	--------- NAVEGATION ---------
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	"bkad/CamelCaseMotion",
	"echasnovski/mini.pick",
	{
		"theprimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	--------- LANGUAGE SPECIFIC ---------
	"Kicamon/markdown-table-mode.nvim",
	--------- UTILITIES ---------
	"lambdalisue/suda.vim",
	{
		"numToStr/Comment.nvim",
		lazy = false,
	},
	"mbbill/undotree",
	"tpope/vim-fugitive",
	"theprimeagen/git-worktree.nvim",
})
