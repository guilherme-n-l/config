require("guilh.utils")
require("guilh.pack")
require("guilh.lsps")

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
local function pick(arg)
    return string.format("<cmd>Pick %s<cr>", arg)
end


local diagnostics_ns = vim.api.nvim_create_namespace("diagnostics_preview")
local function diagnostics()
    local diagnostic_tbl = vim.diagnostic.get(0)
    table.sort(diagnostic_tbl, function(a, b)
        return a.lnum < b.lnum
    end)
    local items = {}
    for _, diagnostic in ipairs(diagnostic_tbl) do
        local severity_icon = {
            [vim.diagnostic.severity.ERROR] = "❌",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.INFO] = "ℹ️",
            [vim.diagnostic.severity.HINT] = "💡",
        }

        local display_text = string.format(
            "%s[%d:%d] %s",
            severity_icon[diagnostic.severity] or "⁉️",
            diagnostic.lnum + 1,
            diagnostic.col + 1,
            diagnostic.message
        )

        table.insert(items, {
            text = display_text,
            value = diagnostic,
        })
    end

    local current_win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_get_current_buf()

    local point_to = function(item)
        local diagnostic = item.value
        vim.api.nvim_win_set_cursor(current_win, { diagnostic.lnum + 1, diagnostic.col + 1 })
        vim.diagnostic.open_float({ scope = "cursor" })
    end

    local preview = function(buf_id, item)
        local start = math.max(item.value.lnum - 10, 0)
        local lines = vim.api.nvim_buf_get_lines(bufnr, start, item.value.end_lnum + 10, false)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
        local ft = vim.bo[bufnr].filetype
        vim.bo[buf_id].filetype = ft
        local highlighted = item.value.lnum - start
        vim.api.nvim_buf_set_extmark(buf_id, diagnostics_ns, highlighted, 0, {
            end_row = highlighted,
            end_col = #lines[highlighted + 1],
            hl_group = "MiniPickPreviewRegion",
        })
    end

    require("mini.pick").start({
        source = { items = items, name = "Diagnostics", choose = point_to, preview = preview },
    })
end

local function completion()
    local current_clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, c in ipairs(current_clients) do
        if c.server_capabilities.completionProvider then
            vim.lsp.completion.get()
            return
        end
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
end

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
        { { "<C-n>", "<C-p>" }, completion },
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
        { "<leader>pf", pick("files"),     desc = "Fuzzy find files" },
        { "<leader>pg", pick("grep_live"), desc = "Fuzzy find strings recursively" },
        { "<leader>ph", pick("help"),      desc = "Fuzzy find help" },
        { "<leader>xv", diagnostics },
    },
})
