require("guilh.utils")
local add = vim.pack.add

add(Gh({
    -- Looks
    "rebelot/kanagawa.nvim.git",
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    "folke/snacks.nvim",

    -- Utils
    "nvim-mini/mini.pick",
    "numToStr/Comment.nvim",
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "theprimeagen/harpoon",
    "stevearc/oil.nvim", -- depends: nvim-tree/nvim-web-devicons
    "lambdalisue/vim-suda.git",
    "tpope/vim-fugitive",

    -- LSP / Language Support
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",

    -- AI
    "coder/claudecode.nvim", -- depends: folke/snacks.nvim
    "github/copilot.vim"
}) --[[@as (string|vim.pack.Spec)[] ]])

Setup_packages({
    "mini.pick",
    "oil",
    "claudecode",
    ["lualine"] = { options = { theme = "auto" } },
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
