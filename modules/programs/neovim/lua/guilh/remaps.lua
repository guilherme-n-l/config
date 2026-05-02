local actions = require("guilh.actions")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

-- Harpoon navigation mappings
local harpoon_goto = {}
for i = 1, 9 do
    table.insert(harpoon_goto, {
        "<leader>" .. i,
        function() harpoon_ui.nav_file(i) end,
        desc = "Navigate to file " .. i,
    })
end

local M = {
    n = {
        { "<leader>x",  vim.cmd.bd, },

        -- Claude Code
        { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add buffer to Claude" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny diff" },

        -- Nav
        { "H",          "mzH`z" },
        { "J",          "mzJ`z" },
        { "<C-d>",      "<C-d>zz" },
        { "<C-u>",      "<C-u>zz" },

        { "n",          "nzzzv" },
        { "N",          "Nzzzv" },

        { "gd",         vim.lsp.buf.definition },

        { "gf",         vim.lsp.buf.format },

        {
            "<leader>hm",
            harpoon_mark.add_file,
            desc = "Add current filepath to list",
        },
        {
            "<leader>hn",
            harpoon_ui.nav_next,
            desc = "Navigate to next filepath in list",
        },
        {
            "<leader>hp",
            harpoon_ui.nav_prev,
            desc = "Navigate to prevous filepath in list",
        },
        {
            "<leader>hv",
            harpoon_ui.toggle_quick_menu,
            desc = "View list",
        },

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
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "Send selection to Claude" },
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
}

vim.list_extend(M.n, harpoon_goto)

return M
