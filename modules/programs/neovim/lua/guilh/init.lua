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

-- Theme
o.termguicolors = true
g.colorscheme = "kanagawa-dragon"

-- Keymaps
local function pick(arg)
	return string.format("<cmd>Pick %s<cr>", arg)
end

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
	end

	local preview = function(buf_id, item)
		local start = math.max(item.value.lnum - 10, 0)
		local lines = vim.api.nvim_buf_get_lines(bufnr, start, item.value.end_lnum + 10, false)
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
		local highlighted = item.value.lnum - start
		vim.api.nvim_buf_add_highlight(buf_id, -1, "MiniPickPreviewRegion", highlighted, 0, #lines[highlighted + 1])
	end

	require("mini.pick").start({
		source = { items = items, name = "Diagnostics", choose = point_to, preview = preview },
	})
	vim.defer_fn(function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, 0)
end

local function completion()
	local current_clients = vim.lsp.get_active_clients({ bufnr = 0 })
	for _, c in ipairs(current_clients) do
		if c.server_capabilities.completionProvider then
			vim.lsp.completion.get()
			return
		end
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
end

local function toggle_virtual_diagnostics()
	local virtual_text_state = false
	return function()
		virtual_text_state = not virtual_text_state
		if virtual_text_state then
			vim.diagnostic.config({ virtual_text = true })
		else
			vim.diagnostic.config({ virtual_text = false })
		end
	end
end

g.mapleader = " "
g.camelcasemotion_key = "<leader>"

Set_keymaps({
	n = {
		{ "<leader>x", vim.cmd.bd, {} },

		{ "J", "mzJ`z" },
		{ "<C-d>", "<C-d>zz" },
		{ "<C-u>", "<C-u>zz" },

		{ "n", "nzzzv" },
		{ "N", "Nzzzv" },

		{ "gd", vim.lsp.buf.definition },

		{ "gf", vim.lsp.buf.format },

		-- Open documentation
		{ "K", vim.lsp.buf.hover },

		{ "<leader>vca", vim.lsp.buf.code_action },
		{ "<leader>vrr", vim.lsp.buf.references },
		{ "<leader>vrn", vim.lsp.buf.rename },

		-- LSP Navigation
		{ "<leader>xf", vim.diagnostic.open_float },
		{ "<leader>xx", toggle_virtual_diagnostics() },
		{ "<leader>xp", vim.diagnostic.goto_prev },
		{ "<leader>xn", vim.diagnostic.goto_next },
	},
	i = {
		{ "<C-h>", vim.lsp.buf.signature_help },
		{ { "<C-n>", "<C-p>" }, completion },
	},
	v = {
		-- Bring selected Up/Down
		{ "K", ":m '<-2<CR>gv=gv" },
		{ "J", ":m '>+1<CR>gv=gv" },
	},
	nvx = {
		-- Easy clipboard access
		{ "<leader>y", '"+y<CR>' },
		{ "<leader>d", '"+d<CR>' },
		{ "<leader>pf", pick("files"), desc = "Fuzzy find files" },
		{ "<leader>pg", pick("grep_live"), desc = "Fuzzy find strings recursively" },
		{ "<leader>ph", pick("help"), desc = "Fuzzy find help" },
		{ "<leader>xv", diagnostics },
	},
})
