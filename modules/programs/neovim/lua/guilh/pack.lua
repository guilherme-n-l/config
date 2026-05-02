require("guilh.utils")
local add = vim.pack.add

add(Gh({
    -- Looks
    "rebelot/kanagawa.nvim.git",
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    "folke/snacks.nvim",
    "lewis6991/gitsigns.nvim",

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
    ["gitsigns"] = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    },
})
