require("guilh.utils")
require("guilh.pack")
require("guilh.lsps")

local actions = require("guilh.actions")
local o = vim.opt
local g = vim.g

-- Lines
o.nu = true
o.rnu = true
o.wrap = false
o.signcolumn = "yes"

-- Cursor / Nav
o.scrolloff = 8

-- Tabs
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

-- History
o.swapfile = false
o.backup = false
o.undofile = true

-- Search
o.hlsearch = false
o.incsearch = true

-- Menus
o.winborder = "rounded"
o.completeopt = { "menuone", "noselect", "popup" }

-- Theme
o.termguicolors = true
g.colorscheme = "kanagawa-dragon"

-- Keymaps
g.mapleader = " "
g.camelcasemotion_key = "<leader>"

Set_keymaps({
    n = {
        { "<leader>x",   vim.cmd.bd,                       {} },

        -- Claude Code
        { "<leader>ac",  "<cmd>ClaudeCode<cr>",            { desc = "Toggle Claude" } },
        { "<leader>af",  "<cmd>ClaudeCodeFocus<cr>",       { desc = "Focus Claude" } },
        { "<leader>ar",  "<cmd>ClaudeCode --resume<cr>",   { desc = "Resume Claude" } },
        { "<leader>aC",  "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" } },
        { "<leader>am",  "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select model" } },
        { "<leader>ab",  "<cmd>ClaudeCodeAdd %<cr>",       { desc = "Add buffer to Claude" } },
        { "<leader>aa",  "<cmd>ClaudeCodeDiffAccept<cr>",  { desc = "Accept diff" } },
        { "<leader>ad",  "<cmd>ClaudeCodeDiffDeny<cr>",    { desc = "Deny diff" } },

        { "J",           "mzJ`z" },
        { "<C-d>",       "<C-d>zz" },
        { "<C-u>",       "<C-u>zz" },

        { "n",           "nzzzv" },
        { "N",           "Nzzzv" },

        { "gd",          vim.lsp.buf.definition },

        { "gf",          vim.lsp.buf.format },

        -- Open documentation
        { "K",           vim.lsp.buf.hover },

        { "<leader>vca", vim.lsp.buf.code_action },
        { "<leader>vrr", vim.lsp.buf.references },
        { "<leader>vrn", vim.lsp.buf.rename },

        -- LSP Navigation
        { "<leader>xf",  vim.diagnostic.open_float },
        {
            "<leader>xx",
            function()
                vim.diagnostic.config({
                    virtual_text = not vim.diagnostic.config().virtual_text,
                })
            end,
        },
        {
            "<leader>xp",
            function()
                vim.diagnostic.jump({ count = -1 })
            end,
        },
        {
            "<leader>xn",
            function()
                vim.diagnostic.jump({ count = 1 })
            end,
        },
    },
    i = {
        { "<C-h>",              vim.lsp.buf.signature_help },
        { { "<C-n>", "<C-p>" }, actions.completion },
    },
    v = {
        -- Bring selected Up/Down
        { "K",          ":m '<-2<CR>gv=gv" },
        { "J",          ":m '>+1<CR>gv=gv" },

        -- Claude Code
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" } },
    },
    nvx = {
        -- Easy clipboard access
        { "<leader>y",  '"+y<CR>' },
        { "<leader>d",  '"+d<CR>' },
        { "<leader>pv", "<cmd>Oil<cr>",            desc = "Open current directory" },
        { "<leader>pf", actions.pick("files"),     desc = "Fuzzy find files" },
        { "<leader>pg", actions.pick("grep_live"), desc = "Fuzzy find strings recursively" },
        { "<leader>ph", actions.pick("help"),      desc = "Fuzzy find help" },
        { "<leader>xv", actions.diagnostics },
    },
})
