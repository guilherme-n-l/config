dofile(vim.fn.stdpath("config") .. "/utils.lua")
local o = vim.opt

-- Lines
o.nu = true
o.rnu = true
o.wrap = false
o.signcolumn = "yes"

-- Cursor / Nav
o.guicursor = nil
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

-- Theme.
o.termguicolors = true
Colorscheme("kanagawa")
